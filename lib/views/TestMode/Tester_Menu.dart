import 'package:mwc/index.dart';

import 'package:flutter/material.dart';

import 'package:mwc/index.dart';

class TesterMenu extends StatefulWidget {
  const TesterMenu({super.key});

  @override
  State<TesterMenu> createState() => _TesterMenuState();
}

class _TesterMenuState extends State<TesterMenu> {
  BluetoothDevice? targetDevice;
  BluetoothDevice? targetDevice1;
  BluetoothDevice? targetDevice2;
  bool isConnecting = false;

  Future<void> _disconnectConnectedDevices() async {
    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.connectedDevices;
    for (BluetoothDevice device in connectedDevices) {
      await device.disconnect();
      targetDevice1 = null;
      targetDevice2 = null;
      print('연결 해제 ${device.platformName}');
    }
  }

  Future<bool> _searchAndConnect(String name) async {
    bool resultscan = false;
    setState(() {
      isConnecting = true;
    });

    await _disconnectConnectedDevices();

    FlutterBluePlus.startScan(
      withNames: [name, 'Scale2'],
      timeout: Duration(seconds: 10),
    );

    var subscription = FlutterBluePlus.scanResults.listen(
      (results) async {
        for (ScanResult result in results) {
          print('${result.device.remoteId}: "${result.device.platformName}" found!');

          if (result.device.platformName == name || result.device.platformName == 'Scale2') {
            targetDevice = result.device;

            await FlutterBluePlus.stopScan();

            await targetDevice?.connect();

            setState(() {
              isConnecting = false;
            });

            if (targetDevice != null) {
              resultscan = true;
              print('Connected to ${targetDevice!.platformName}');
            } else {
              print('Failed to connect to the device');
            }
            break;
          }
        }
      },
    );

    // 10초 스캔 딜레이 대신, 타겟 디바이스를 찾은 즉시 종료
    await Future.delayed(Duration(milliseconds: 500)); // 딜레이를 추가하여 안정성 확보
    subscription.cancel(); // 구독 취소
    await FlutterBluePlus.stopScan(); // 스캔 종료

    setState(() {
      isConnecting = false;
    });

    return resultscan;
  }

  Future<bool> _searchAndConnectAll() async {
    print('_searchAndConnectAll');
    if ((targetDevice1 != null && targetDevice2 != null)) {}
    await _disconnectConnectedDevices();

    bool resultScan1 = false;
    bool resultScan2 = false;
    setState(() {
      isConnecting = true;
    });

    await FlutterBluePlus.startScan(
      withNames: ['AT+AUTO', 'mwc Scale'],
      timeout: Duration(seconds: 10),
    );

    var subscription = FlutterBluePlus.scanResults.listen(
      (results) async {
        for (ScanResult result in results) {
          print('${result.device.remoteId}: "${result.device.platformName}" found!');

          if (result.device.platformName == 'AT+AUTO' && targetDevice1 == null) {
            print('AUTO');
            targetDevice1 = result.device;
            await targetDevice1?.connect();
            if (targetDevice1 != null) {
              resultScan1 = true;
              print('Connected to ${targetDevice1!.platformName}');
            } else {
              print('Failed to connect to the device AT+AUTO');
            }
          } else if (result.device.platformName == 'mwc Scale' && targetDevice2 == null) {
            print('Scale');

            targetDevice2 = result.device;
            await targetDevice2?.connect();

            if (targetDevice2 != null) {
              resultScan2 = true;
              print('Connected to ${targetDevice2!.platformName}');
            } else {
              print('Failed to connect to the device mwc Scale');
            }
          }
        }
      },
    );

    await Future.delayed(Duration(seconds: 15));
    subscription.cancel();
    FlutterBluePlus.stopScan();
    setState(() {
      isConnecting = false;
    });
    return resultScan1 & resultScan2;
  }

  void divice1() async {
    await _searchAndConnect('AT+AUTO').then((value) => value ? context.goNamed('Teseter_Scan', extra: 1) : null);
  }

  void divice2() async {
    await _searchAndConnect('mwc Scale')
        .then((value) => value ? context.goNamed('Teseter_Scan', extra: 2) : context.goNamed('Teseter_Scan', extra: 2));
  }

  void alldivice() async {
    await _searchAndConnectAll().then((value) => value ? context.goNamed('Teseter_Scan', extra: 2) : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Black,
      appBar: AppBar(
        leading: AppIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.chevron_left,
            color: AppColors.primaryBackground,
            size: 30,
          ),
          onPressed: () async {
            AppStateNotifier.instance.resetTestState();
            AppStateNotifier.instance.logout();
            context.pushNamed('home');
          },
        ),
        backgroundColor: Color(0x00CCFF8B),
        automaticallyImplyLeading: false,
        title: Text(SetLocalizations.of(context).getText('titketset'), style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // LodingButtonWidget(
              //   text: '1번 기기 측정',ㅇㄹㅇ
              //   onPressed: () => divice1(),
              //   options: LodingButtonOptions(
              //     height: 100.0,
              //     width: double.infinity,
              //     padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              //     iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              //     color: AppColors.Gray700,
              //     textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
              //     elevation: 0,
              //     borderRadius: BorderRadius.circular(8.0),
              //   ),
              // ),
              SizedBox(
                height: 15,
              ),
              LodingButtonWidget(
                text: SetLocalizations.of(context).getText('xmrwjdkglr'),
                onPressed: () => divice2(),
                options: LodingButtonOptions(
                  height: 100.0,
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: (AppStateNotifier.instance.test2) ? AppColors.Black : AppColors.Gray700,
                  textStyle: (AppStateNotifier.instance.test2)
                      ? AppFont.s18.overrides(fontSize: 16, color: AppColors.Gray500)
                      : AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              LodingButtonWidget(
                text: SetLocalizations.of(context).getText('tkwlsckh'),
                onPressed: () {
                  context.goNamed('testvisionScan', extra: 'test');
                },
                options: LodingButtonOptions(
                  height: 100.0,
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: (AppStateNotifier.instance.cam) ? AppColors.Black : AppColors.Gray700,
                  textStyle: (AppStateNotifier.instance.cam)
                      ? AppFont.s18.overrides(fontSize: 16, color: AppColors.Gray500)
                      : AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              LodingButtonWidget(
                text: SetLocalizations.of(context).getText('ehddutkd'),
                onPressed: () {
                  context.goNamed('VideoUpload');
                },
                options: LodingButtonOptions(
                  height: 100.0,
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: (AppStateNotifier.instance.vid) ? AppColors.Black : AppColors.Gray700,
                  textStyle: (AppStateNotifier.instance.vid)
                      ? AppFont.s18.overrides(fontSize: 16, color: AppColors.Gray500)
                      : AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (AppStateNotifier.instance.test2)
                LodingButtonWidget(
                  text: SetLocalizations.of(context).getText('tnwlqdy'),
                  onPressed: () {
                    AppStateNotifier.instance.resetTestState();
                    AppStateNotifier.instance.logout();
                    context.goNamed('home');
                  },
                  options: LodingButtonOptions(
                    height: 100.0,
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: AppColors.primaryBackground,
                    textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    targetDevice1?.disconnect();
    targetDevice2?.disconnect();
    super.dispose();
  }
}
