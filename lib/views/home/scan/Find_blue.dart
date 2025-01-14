import 'package:mwc/components/Success_device.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:mwc/views/home/scan/utils/extra.dart';
import 'package:mwc/views/home/scan/widgets/scan_result_tile.dart';
import 'package:mwc/views/home/scan/widgets/system_device_tile.dart';

import '../../../widgets/App_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';

class FindBlue extends StatefulWidget {
  final String mode;
  const FindBlue({Key? key, required this.mode}) : super(key: key);

  @override
  State<FindBlue> createState() => _FindBlueState();
}

class _FindBlueState extends State<FindBlue> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _scanResults.clear();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {});
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
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

    Future onScanPressed() async {
      print('scan');
      List<BluetoothDevice> connectedDevices = await FlutterBluePlus.connectedDevices;

      _scanResults.clear();
      try {
        _systemDevices = (await FlutterBluePlus.systemDevices) as List<BluetoothDevice>;
      } catch (e) {}
      try {
        await FlutterBluePlus.startScan(withNames: ["Fisica Scale", "Scale2"], timeout: const Duration(seconds: 5));
      } catch (e) {}
      if (mounted) {
        setState(() {});
      }
    }

    Future onStopPressed() async {
      try {
        FlutterBluePlus.stopScan();
      } catch (e) {}
    }

    void onConnectPressed(BluetoothDevice device) {
      device.connect(autoConnect: false, mtu: null).then((value) {
        device.requestMtu(645);
        print(device.remoteId);
        AppStateNotifier.instance.Updevice(device.platformName.toString());

        showAlignedDialog(
          context: context,
          isGlobal: true,
          avoidOverflow: false,
          targetAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
          followerAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
          builder: (dialogContext) {
            return Material(
              color: Colors.transparent,
              child: GestureDetector(
                child: Container(
                  height: 366,
                  width: 327,
                  child: SuccessDevice(
                    name: device.platformName,
                    mode: widget.mode,
                  ),
                ),
              ),
            );
          },
        );
      }).catchError((e) {
        print('Failure');
      });
    }

    Future onRefresh() {
      if (_isScanning == false) {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      }
      if (mounted) {
        setState(() {});
      }
      return Future.delayed(Duration(milliseconds: 500));
    }

    Widget buildScanButton(BuildContext context) {
      if (FlutterBluePlus.isScanningNow) {
        return LodingButtonWidget(
          text: SetLocalizations.of(context).getText('settingAddDeviceButtonSearchingLabel'),
          onPressed: onStopPressed,
          options: LodingButtonOptions(
            height: 56.0,
            width: double.infinity,
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: AppColors.Black,
            textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
            elevation: 0,
            borderSide: BorderSide(
              color: AppColors.primaryBackground,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      } else {
        return LodingButtonWidget(
            text: SetLocalizations.of(context).getText('settingAddDeviceButtonSearchLabel'),
            options: LodingButtonOptions(
              height: 56.0,
              width: double.infinity,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: AppColors.primaryBackground,
              textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
              elevation: 0,
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            onPressed: onScanPressed);
      }
    }

    // List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    //   return _systemDevices
    //       .map(
    //         (d) => SystemDeviceTile(
    //           device: d,
    //           onOpen: () => Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) => DeviceScreen(device: d),
    //               settings: RouteSettings(name: '/DeviceScreen'),
    //             ),
    //           ),
    //           onConnect: () => onConnectPressed(d),
    //         ),
    //       )
    //       .toList();
    // }

    List<Widget> _buildScanResultTiles(BuildContext context) {
      return _scanResults
          .map(
            (r) => ScanResultTile(
              result: r,
              onTap: () => onConnectPressed(r.device),
            ),
          )
          .toList();
    }

    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.Black,
        appBar: AppBar(
          surfaceTintColor: AppColors.Black,
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
              context.pop();
            },
          ),
          backgroundColor: AppColors.Black,
          automaticallyImplyLeading: false,
          title: Text(SetLocalizations.of(context).getText('settingAddDeviceButtonReturnLabel'),
              style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                alignment: Alignment(0.0, -0.4),
                decoration: BoxDecoration(
                  // 원형 그라데이션 정의
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary, // 중심에서 투명
                      AppColors.Black
                    ],
                    center: Alignment(0.0, -0.4),
                    radius: 0.35, // 그라데이션의 반경을 설정
                    stops: [0.1, 1.0], // 색상이 변경되는 지점을 정의
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth),
                    Text(
                      'BLUETOOTH',
                      style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Black),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        ..._buildScanResultTiles(context),
                      ],
                    ),
                  ),
                  Container(
                    height: 120,
                    child: Column(children: [
                      Text(
                        SetLocalizations.of(context).getText('settingAddDeviceDescription'),
                        style: AppFont.r16.overrides(
                          color: AppColors.DarkenGreen,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                    child: buildScanButton(context),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
