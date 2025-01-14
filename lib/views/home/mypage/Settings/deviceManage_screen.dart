import 'package:mwc/views/home/group/widgets/member_more.dart';
import 'package:mwc/models/GroupData.dart';
import 'package:mwc/views/home/mypage/mypage_components/out_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class DevicerManagementPage extends StatefulWidget {
  const DevicerManagementPage({Key? key}) : super(key: key);

  @override
  _DevicerManagementPageState createState() => _DevicerManagementPageState();
}

class _DevicerManagementPageState extends State<DevicerManagementPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showLeaveDialog() {
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
              height: 432,
              width: 327,
              child: Exitservice(
                state: 'deldevice',
              ),
            ),
          ),
        );
      },
    );
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
                actions: [
                  AppIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.close,
                      color: AppColors.primaryBackground,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pop();
                    },
                  ),
                ],
                backgroundColor: AppColors.Black,
                automaticallyImplyLeading: false,
                title: Text(SetLocalizations.of(context).getText('settingButtonDeviceLabel'),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
                centerTitle: false,
                elevation: 0.0,
              ),
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    if (!AppStateNotifier.isdevice) ...[
                      _buildnoDevice(context),
                      SizedBox(height: 20),
                      _buildaddDevice(context),
                      SizedBox(height: 20),
                      //_buildcaliDevice(context)
                    ] else ...[
                      _buildDevice(context),
                      SizedBox(height: 20),
                      _buildyesDevice(context),
                      SizedBox(height: 20),
                      //_buildcaliDevice(context)
                    ]
                  ],
                ),
              ))));
    });
  }

  Widget _buildnoDevice(BuildContext context) {
    return Container(
        height: 76,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.Gray850,
        ),
        //등록 디바이스가 없습니다.
        child: Center(
            child: Text(SetLocalizations.of(context).getText('settingDeviceNoDeviceLabel'),
                style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 12))));
  }

  Widget _buildaddDevice(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed('FindBlue', extra: 'main');
      },
      child: Container(
          height: 76,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.primaryBackground),
            color: AppColors.Black,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_outlined,
                color: AppColors.primaryBackground,
              ),
              SizedBox(
                width: 12,
              ),
              Text(SetLocalizations.of(context).getText('settingDeviceButtonAddDeviceLabel'),
                  style: AppFont.s18.overrides(color: AppColors.primaryBackground, fontSize: 16)),
            ],
          ))),
    );
  }

  Widget _buildcaliDevice(BuildContext context) {
    return InkWell(
      onTap: () {
        context.goNamed('DeviceCalibration');
      },
      child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.primaryBackground),
            color: AppColors.Black,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Calibration', style: AppFont.s18.overrides(color: AppColors.primaryBackground, fontSize: 16)),
            ],
          ))),
    );
  }

  Widget _buildDevice(BuildContext context) {
    return Container(
        height: 84,
        width: double.infinity,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFCFDFF).withOpacity(0.20),
              Color(0xFFFCFDFF).withOpacity(0.04),
            ],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.50, color: Color(0x33FBFCFF)),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: [
            BoxShadow(
              color: Color(0xB2121212),
              blurRadius: 8,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              Text(
                AppStateNotifier.instance.device!,
                style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
              )
            ]),
            InkWell(
              onTap: () {
                _showLeaveDialog();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.red, width: 1),
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.red,
                  size: 25,
                ),
              ),
            )
          ]),
        ));
  }

  Widget _buildyesDevice(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
          height: 76,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: AppColors.Gray500),
            color: AppColors.Black,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_outlined,
                color: AppColors.Gray500,
              ),
              SizedBox(
                width: 12,
              ),
              Text(SetLocalizations.of(context).getText('ecnrk'), style: AppFont.s18.overrides(color: AppColors.Gray500, fontSize: 16)),
            ],
          ))),
    );
  }
}
