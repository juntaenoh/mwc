import 'dart:convert';

import 'package:mwc/views/home/scan/scandata.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class DeviceCalibration extends StatefulWidget {
  const DeviceCalibration({Key? key}) : super(key: key);

  @override
  State<DeviceCalibration> createState() => _DeviceCalibrationState();
}

class _DeviceCalibrationState extends State<DeviceCalibration> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String ids = '';
  String devicename = '';
  late BluetoothDevice cndevice;
  bool isconnect = false;
  late dynamic subscription;
  late String rawdata = '';
  bool isscaning = false;
  final _controller = TextEditingController();
  double measuredWeight = 0.0;
  double error = 0.0;
  String calibrationStatus = "Not Calibrated";

  @override
  void initState() {
    super.initState();
    final device = FlutterBluePlus.connectedDevices;
    if (device.isEmpty) {
      isconnect = false;
    } else if (device.isNotEmpty) {
      isconnect = true;
      cndevice = device[0];
    }

    subscription = FlutterBluePlus.events.onConnectionStateChanged.listen((event) {
      if (mounted) {
        if (event.connectionState == BluetoothConnectionState.disconnected) {
          setState(() {
            isconnect = false;
          });
        } else if (event.connectionState == BluetoothConnectionState.connected) {
          setState(() {
            isconnect = true;
            cndevice = event.device;
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void getRawData() async {
    String finalData = '';
    String temdata = '';

    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await c.write(utf8.encode("AT+MODE=1"));
          List<int> value = await c.read();
          String decodedString = String.fromCharCodes(value);
          await c.setNotifyValue(true);

          await c.write(utf8.encode("AT+AUTO"));

          final subscription = c.lastValueStream.listen((value) {
            String hexString = value.map((number) => number.toRadixString(16).padLeft(2, '0').toUpperCase()).join('');

            const String atAutoHex = "41542B4155544F"; // "AT+AUTO"의 ASCII 값을 16진수로 변환한 값

            if (!hexString.contains(atAutoHex)) {
              if (hexString.endsWith('F00F') && hexString.length + temdata.length >= 1290) {
                temdata += hexString;
                finalData = temdata.substring(temdata.length - 1290);
                c.setNotifyValue(false);
              } else {
                temdata += hexString;
              }
            } else {}
          });

          await Future.delayed(const Duration(milliseconds: 2000));
          subscription.cancel();
          print(finalData.length);
          if (finalData.isNotEmpty && finalData.length == 1290) {
            print('ok');

            await FootprintApi.footScan(finalData).then((value) {
              print('footScanbool ' + value.toString());
              if (value == true) {
                context.pushNamed('Footresult', extra: 'main');
              }
              isscaning = false;
            });
          }
          print('no');
        }
      }
    }
  }

  void setScale(double targetweight) async {
    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          List<int> value = await c.read();
          String decodedString = String.fromCharCodes(value);
          print(decodedString);
          readWeight(c);

          double weightDouble = 0;
          int calyvalue = -11600;
          int count = 0;
          while (weightDouble > targetweight + 0.5 || weightDouble < targetweight - 0.5) {
            await c.write(utf8.encode("AT+SCALE=$calyvalue"));
            List<int> value = await c.read();
            String decodedString = String.fromCharCodes(value);
            print(decodedString);

            await c.write(utf8.encode("AT+WEIGHT"));
            List<int> weight = await c.read();
            String weightString = String.fromCharCodes(weight);
            String prefix = "AT+WEIGHT=";
            String finalweigh = weightString.replaceFirst(prefix, '');
            weightDouble = double.parse(finalweigh);
            print(weightDouble);

            if (!weightDouble.isNegative) {
              double difference = weightDouble - targetweight;

              if (difference.abs() > 50) {
                calyvalue -= (difference > 0) ? 500 : -500;
              } else if (difference.abs() > 20) {
                calyvalue -= (difference > 0) ? 200 : -200;
              } else if (difference.abs() > 3) {
                calyvalue -= (difference > 0) ? 100 : -100;
              } else if (difference.abs() > 1) {
                calyvalue -= (difference > 0) ? 50 : -50;
              } else {
                break;
              }
            } else {
              double difference = weightDouble + targetweight;
              if (difference.abs() > 50) {
                calyvalue += (difference > 0) ? 500 : -500;
              } else if (difference.abs() > 20) {
                calyvalue += (difference > 0) ? 200 : -200;
              } else if (difference.abs() > 3) {
                calyvalue += (difference > 0) ? 100 : -100;
              } else if (difference.abs() > 1) {
                calyvalue += (difference > 0) ? 50 : -50;
              } else {
                break;
              }
            }

            count++;

            if (count >= 50) {
              break;
            }
            print('count ' + count.toString());
          }
          print('done');
        }
      }
    }
  }

  Future<double> readWeight(BluetoothCharacteristic c) async {
    await c.write(utf8.encode("AT+WEIGHT"));
    final weight = await c.read();
    String hexString = weight.map((number) => number.toRadixString(16).padLeft(2, '0').toUpperCase()).join('');
    print(hexString);
    String weightString = String.fromCharCodes(weight);

    String prefix = "AT+WEIGHT=";
    String finalweigh = weightString.replaceFirst(prefix, '');

    print(finalweigh);
    return double.parse(finalweigh);
  }

  Future<void> adjustSensitivity(BluetoothCharacteristic c, int sensitivity) async {
    await c.write(utf8.encode("AT+SCALE=$sensitivity"));
    List<int> value = await c.read();
    String decodedString = String.fromCharCodes(value);
    print(decodedString);
  }

  Future<void> calibrateScale(double goalWeight) async {
    int sensitivity = -11600; // 초기 민감도
    int minSensitivity = -50000; // 민감도의 최소값
    int maxSensitivity = 50000; // 민감도의 최대값
    double measuredWeight;
    const int maxIterations = 10; // 최대 반복 횟수
    int iteration = 0;

    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          while (iteration < maxIterations) {
            measuredWeight = await readWeight(c);
            if ((measuredWeight - goalWeight).abs() <= 0.05) {
              break; // 루프 탈출
            }
            if (measuredWeight > goalWeight) {
              minSensitivity = sensitivity + 1;
            } else {
              maxSensitivity = sensitivity - 1;
            }

            sensitivity = (minSensitivity + maxSensitivity) ~/ 2; // 이진 탐색으로 새로운 민감도 설정
            adjustSensitivity(c, sensitivity); // 민감도 조정 함수 호출
            await Future.delayed(Duration(seconds: 1)); // 조정 후 안정화 대기
            iteration++;
          }
        }
      }
    }
    print("최적 민감도: $sensitivity");
  }

  void setzero() async {
    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await c.write(utf8.encode("AT+OFFSET"));
          List<int> value = await c.read();
          String decodedString = String.fromCharCodes(value);
          print(decodedString);
        }
      }
    }
  }

  void get() async {
    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await readWeight(c);
        }
      }
    }
  }

  void getRawData2() async {
    String finalData =
        '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F';
    await FootprintApi.footScan(finalData).then((value) {
      print('footScanbool ' + value.toString());
      if (value == true) {
        context.pushNamed('Footresult', extra: 'main');
      }
      isscaning = false;
    });
  }

  void testergetRawData() async {
    List<String> testdata = [];
    String finalData = '';
    String temdata = '';

    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await c.write(utf8.encode("AT+MODE=1"));
          List<int> value = await c.read();
          String decodedString = String.fromCharCodes(value);
          print(decodedString);
          await c.setNotifyValue(true);

          await c.write(utf8.encode("AT+AUTO"));
          testdata = [];
          final subscription = c.lastValueStream.listen((value) {
            String hexString = value.map((number) => number.toRadixString(16).padLeft(2, '0').toUpperCase()).join('');

            const String atAutoHex = "41542B4155544F"; // "AT+AUTO"의 ASCII 값을 16진수로 변환한 값

            if (!hexString.contains(atAutoHex)) {
              if (hexString.endsWith('F00F') && hexString.length + temdata.length >= 1290) {
                temdata += hexString;
                finalData = temdata.substring(temdata.length - 1290);
                testdata.add(finalData);
                print(finalData);
                temdata = '';
                print(testdata.length);
                if (testdata.length >= 10) {
                  c.setNotifyValue(false);
                }
              } else {
                temdata += hexString;
              }
            }
          });

          await Future.delayed(const Duration(milliseconds: 10000));
          c.setNotifyValue(false);
          subscription.cancel();

          await FootprintApi.testfootScan(testdata).then((value) {
            print('footScanbool ' + value.toString());
            if (value == true) {
              context.pushNamed('testFootresult', extra: 'tester');
            }
            isscaning = false;
          });
        }
      }
    }
  }

  void testergetRawData2() async {
    isscaning = true;
    List finalData = [
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F',
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001214050F11010000001708000A0200000000000000070108082F0C02000000150C02060615000000000000090000000500000000000C030000000B1A0000000033000005000000000000000000000200002D00000000001731311D07100400000007080A1B090D0000000001031D1E0F1A140F05000000150C0D0D23270902000002174721180B0C10040000000E0F0E0A1F1B221400001F2D2E27080F0B10030000000E0D0E13191F2D2200008B66261008090602010000000C06061214272679000037110D070300000000000000000000000A19383F00000008000100000000000000000000000000150600000000050D00000000000000000000000000000C0400000000000000000000000000000000000000000C000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000020000000000000000000009050000000000000000090A020000000000000001020714180903000000010B160C140000000000000003180E16142006000000041A191B0D000000000000000316131419261200000021171B140D01000000000000030B17151A21550000002D1B1F0E0F0100000000000104051813171839000000171F171A150100000000000000000710050801000000010C0C06000000000000000000000710050801000000010C0C06000000000000000000000000000000000000000000000000000000F00F0D085EF00F'
    ];

    await FootprintApi.testfootScan(finalData).then((value) {
      print('footScanbool ' + value.toString());
      if (value == true) {
        print('go');
        context.pushNamed('testFootresult', extra: 'tester');
      }
      isscaning = false;
    });
  }

  @override
  void dispose() {
    // also, make sure you cancel the subscription when done!
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Consumer<AppStateNotifier>(builder: (context, AppStateNotifier, child) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColors.Black,
            appBar: AppBar(
              backgroundColor: Color(0x00CCFF8B),
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: isconnect ? AppColors.primary : AppColors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Container(
                      height: 32,
                      width: 128,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: isconnect ? AppColors.primary : AppColors.red,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStateNotifier.device!,
                            style: AppFont.s12.overrides(color: AppColors.primaryBackground),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    size: 20,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment(0.0, 0.35),
                      width: double.infinity,
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppColors.Black,
                            isconnect ? AppColors.primary : AppColors.red,
                            isconnect ? AppColors.primary : AppColors.red,
                            isconnect ? const Color.fromARGB(182, 205, 255, 139) : Color.fromARGB(89, 233, 88, 88),
                            Color.fromARGB(18, 26, 28, 33)
                          ],
                          center: Alignment(0.0, 0.3),
                          radius: 0.38,
                          stops: [0.85, 0.85, 0.86, 0.86, 1.0],
                        ),
                      ),
                      child: Text(
                        'Calibration',
                        style: AppFont.b24.overrides(color: AppColors.primaryBackground),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        isconnect ? SetLocalizations.of(context).getText('cmrwjdwnd') : SetLocalizations.of(context).getText('rlrldusrufhgkrdls'),
                        style: AppFont.r16.overrides(
                          color: isconnect ? AppColors.primary : AppColors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                (isconnect)
                    ? Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 40),
                        child: Column(
                          children: [
                            Container(
                              width: 200,
                              child: TextFormField(
                                controller: _controller,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                    labelText: '목표 체중 입력',
                                    labelStyle: AppFont.b24.overrides(color: AppColors.primaryBackground),
                                    hintStyle: AppFont.s12,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.Gray200,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.Gray200,
                                        width: 1,
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.Gray200,
                                        width: 1,
                                      ),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.Gray200,
                                        width: 1,
                                      ),
                                    ),
                                    suffix: Text(
                                      'kg',
                                      style: AppFont.r16.overrides(color: AppColors.Gray200),
                                    )),
                                keyboardType: TextInputType.number,
                                style: AppFont.r16.overrides(color: AppColors.Gray200),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 56.0,
                              child: LodingButtonWidget(
                                onPressed: () async {
                                  print(double.parse(_controller.text));
                                  setScale(double.parse(_controller.text));
                                },
                                text: 'calibration',
                                options: LodingButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: isscaning ? AppColors.Black : AppColors.primaryBackground,
                                  textStyle: AppFont.s18.overrides(fontSize: 16, color: isscaning ? AppColors.Gray300 : AppColors.Black),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: isscaning ? AppColors.Gray300 : AppColors.Black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 56.0,
                              child: LodingButtonWidget(
                                onPressed: () async {
                                  setzero();
                                },
                                text: 'zero',
                                options: LodingButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: isscaning ? AppColors.Black : AppColors.primaryBackground,
                                  textStyle: AppFont.s18.overrides(fontSize: 16, color: isscaning ? AppColors.Gray300 : AppColors.Black),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: isscaning ? AppColors.Gray300 : AppColors.Black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 40),
                        child: Container(
                          width: double.infinity,
                          height: 56.0,
                          child: LodingButtonWidget(
                            onPressed: () async {
                              //getRawData2();

                              //testergetRawData2();

                              context.pushNamed('FindBlue', extra: 'cali');
                            },
                            text: SetLocalizations.of(context).getText(
                              'elqkdltmdus' /* 다시연결 */,
                            ),
                            options: LodingButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: AppColors.Black,
                              textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                              elevation: 0,
                              borderSide: BorderSide(
                                color: AppColors.primaryBackground,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
              ],
            )),
      );
    });
  }
}
