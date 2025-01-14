import 'dart:convert';

import 'package:mwc/views/home/scan/scandata.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class FootPrint extends StatefulWidget {
  final String mode;
  const FootPrint({Key? key, required this.mode}) : super(key: key);

  @override
  State<FootPrint> createState() => _FootPrintState();
}

class _FootPrintState extends State<FootPrint> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String ids = '';
  String devicename = '';
  late BluetoothDevice cndevice;
  bool isconnect = false;
  late dynamic subscription;
  late String rawdata = '';
  String temdata = '';
  String finalData = '';
  bool isScanning = false;
  String unit = '';
  double progress = 0;

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

  Future<void> getRawData() async {
    setState(() {
      temdata = '';
      finalData = '';
      isScanning = true;
      progress = 0.0;
    });

    try {
      List<BluetoothService> services = await cndevice!.discoverServices();
      for (var service in services) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.properties.write) {
            await c.write(utf8.encode("AT+MODE=1"));
            await c.read();
            await c.setNotifyValue(true);
            await c.write(utf8.encode("AT+AUTO"));

            final subscription = c.lastValueStream.listen((value) {
              String hexString = value.map((number) => number.toRadixString(16).padLeft(2, '0').toUpperCase()).join('');
              const String atAutoHex = "41542B4155544F"; // "AT+AUTO"의 ASCII 값을 16진수로 변환한 값

              if (!hexString.contains(atAutoHex)) {
                if (hexString.endsWith('F00F') && hexString.length + temdata.length >= 1290) {
                  temdata += hexString;
                  finalData = temdata.substring(temdata.length - 1290);
                  print(finalData);
                  c.setNotifyValue(false);
                } else {
                  temdata += hexString;
                  setState(() {
                    progress = temdata.length / 1290;
                  });
                }
              }
            });

            await Future.delayed(const Duration(milliseconds: 2000));
            subscription.cancel();

            if (finalData.isNotEmpty && finalData.length == 1290) {
              await FootprintApi.footScan(finalData).then((value) {
                if (value == true) {
                  print('asdfa');
                  context.pushNamed('Footresult', extra: 'main');
                  isScanning = false;
                  progress = 0;
                }
                setState(() {
                  isScanning = false;
                  progress = 0;
                });
              });
            } else {
              setState(() {
                isScanning = false;
                progress = 0;
              });
            }
          }
        }
      }
    } catch (e) {
      setState(() {
        isScanning = false;
        progress = 0;
      });
    }
  }

  int targetweight = 77;
  void setScale() async {
    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await c.write(utf8.encode("AT+WEIGHT"));
          List<int> weight = await c.read();
          String weightString = String.fromCharCodes(weight);
          String prefix = "AT+WEIGHT=";
          String finalweigh = weightString.replaceFirst(prefix, '');

          double weightDouble = double.parse(finalweigh);
          int calyvalue = 2400;
          int count = 0;
          while (weightDouble > targetweight + 1 || weightDouble < targetweight - 1) {
            await c.write(utf8.encode("AT+SCALE=$calyvalue"));
            List<int> value = await c.read();
            String decodedString = String.fromCharCodes(value);
            print(decodedString);

            await c.write(utf8.encode("AT+WEIGHT"));
            List<int> weight = await c.read();
            String weightString = String.fromCharCodes(weight);
            String prefix = "AT+WEIGHT=";
            String finalweigh = weightString.replaceFirst(prefix, '').replaceAll('-', '');
            weightDouble = double.parse(finalweigh);
            print(weightDouble);

            double difference = weightDouble - targetweight;

            if (difference.abs() > 50) {
              calyvalue += (difference > 0) ? 500 : -500;
            } else if (difference.abs() > 20) {
              calyvalue += (difference > 0) ? 200 : -200;
            } else if (difference.abs() > 10) {
              calyvalue += (difference > 0) ? 100 : -100;
            } else if (difference.abs() > 2) {
              calyvalue += (difference > 0) ? 50 : -50;
            } else {
              break;
            }

            print(difference > 0 ? 'up' : 'down');
            count++;

            if (count >= 100) {
              break;
            }
            print('count ' + count.toString());
          }
          print('done');
        }
      }
    }
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
            isScanning = false;
          });
        }
      }
    }
  }

  void unitchange(int unit) async {
    List<BluetoothService> services = await cndevice.discoverServices();
    for (var service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await c.write(utf8.encode("AT+UNIT=$unit"));
          List<int> value = await c.read();
          String decodedString = String.fromCharCodes(value);
          print(decodedString);
          await c.setNotifyValue(true);
        }
      }
    }
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
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColors.Black,
            appBar: AppBar(
              backgroundColor: AppColors.Black,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: isconnect ? AppColors.AlertGreen : AppColors.red,
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
                          color: isconnect ? AppColors.AlertGreen : AppColors.red,
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
                    Icons.close,
                    color: AppColors.primaryBackground,
                    size: 24.0,
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
                      child: isconnect ? Image.asset('assets/images/footprint.png') : Image.asset('assets/images/footno.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        isconnect
                            ? SetLocalizations.of(context).getText('scanPlantarPressureDescription')
                            : SetLocalizations.of(context).getText('scanPlantarPressureNoConnectionDescription'),
                        style: AppFont.r16.overrides(
                          color: isconnect ? AppColors.primary : AppColors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                isconnect
                    ? Column(
                        children: [
                          isScanning
                              ? Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Container(
                                    width: 50, // 원형 프로그레스의 크기를 설정
                                    height: 50, // 원형 프로그레스의 크기를 설정
                                    decoration: BoxDecoration(
                                      color: AppColors.Gray100, // 로딩 바 배경 색상
                                      shape: BoxShape.circle, // 원형 모양
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: progress, // 프로그레스 값 (0.0 ~ 1.0)
                                        strokeWidth: 6.0, // 프로그레스 바의 두께
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.AlertGreen), // 채워지는 색상
                                        backgroundColor: Colors.transparent, // 배경 색상
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                              child: LodingButtonWidget(
                                        onPressed: () async {
                                          unitchange(1);
                                          setState(() {
                                            unit = 'kg';
                                          });
                                        },
                                        text: 'Kilogram(kg)',
                                        options: LodingButtonOptions(
                                          height: 40.0,
                                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: (unit == '' || unit == 'lb') ? AppColors.Black : AppColors.primaryBackground,
                                          textStyle: AppFont.s18
                                              .overrides(fontSize: 16, color: (unit == '' || unit == 'lb') ? AppColors.Gray300 : AppColors.Black),
                                          elevation: 0,
                                          borderSide: BorderSide(
                                            color: (unit == '' || unit == 'lb') ? AppColors.Gray300 : AppColors.Black,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                      ))),
                                      Expanded(
                                          child: Container(
                                              child: LodingButtonWidget(
                                        onPressed: () async {
                                          unitchange(2);
                                          setState(() {
                                            unit = 'lb';
                                          });
                                        },
                                        text: 'Pound(lb)',
                                        options: LodingButtonOptions(
                                          height: 40.0,
                                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                          color: (unit == '' || unit == 'kg') ? AppColors.Black : AppColors.primaryBackground,
                                          textStyle: AppFont.s18
                                              .overrides(fontSize: 16, color: (unit == '' || unit == 'kg') ? AppColors.Gray300 : AppColors.Black),
                                          elevation: 0,
                                          borderSide: BorderSide(
                                            color: (unit == '' || unit == 'kg') ? AppColors.Gray300 : AppColors.Black,
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                      )))
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 40),
                            child: Container(
                              width: double.infinity,
                              height: 56.0,
                              child: LodingButtonWidget(
                                onPressed: () async {
                                  setState(() {
                                    isScanning = true;
                                  });
                                  if (widget.mode == 'main') {
                                    getRawData();
                                  } else
                                    testergetRawData();
                                },
                                text: isScanning
                                    ? SetLocalizations.of(context).getText('scanPlantarPressureButtonScanLabel')
                                    : SetLocalizations.of(context).getText('scanPlantarPressureButtonStartLabel'),
                                options: LodingButtonOptions(
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                  color: isScanning ? AppColors.Black : AppColors.primaryBackground,
                                  textStyle: AppFont.s18.overrides(fontSize: 16, color: isScanning ? AppColors.Gray300 : AppColors.Black),
                                  elevation: 0,
                                  borderSide: BorderSide(
                                    color: isScanning ? AppColors.Gray300 : AppColors.Black,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
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

                              if (widget.mode == 'main') {
                                context.pushNamed('FindBlue', extra: 'main');
                              } else {
                                context.pushNamed('testFindBlue', extra: 'tester');
                              }
                            },
                            text: SetLocalizations.of(context).getText(
                              'scanPlantarPressureNoConnectionButtonConnectLabel' /* 다시연결 */,
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
