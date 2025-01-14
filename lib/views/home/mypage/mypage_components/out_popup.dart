import 'package:mwc/components/check_cancel_invite.dart';
import 'package:mwc/components/check_delete_group.dart';
import 'package:mwc/components/check_exit_group.dart';
import 'package:mwc/views/home/mypage/mypage_components/ok_pop.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';

import 'package:flutter/material.dart';

import 'package:mwc/index.dart';

class Exitservice extends StatefulWidget {
  final String state;
  const Exitservice({Key? key, required this.state}) : super(key: key);

  @override
  _ExitserviceState createState() => _ExitserviceState();
}

class _ExitserviceState extends State<Exitservice> {
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  String mainText = '';
  String subText = '';

  String buttonText1 = '';
  String buttonText2 = '';
  late VoidCallback action;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateContent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  String gs(String code) {
    return SetLocalizations.of(context).getText(code);
  }

  void updateContent() {
    // 상태에 따라 내용 업데이트
    setState(() {
      if (widget.state == 'logout') {
        mainText = gs('popupDecideLogoutLabel');
        subText = gs('popupDecideLogoutDescription');
        buttonText1 = gs('popupDecideLogoutButtonConfirmLabel');
        buttonText2 = gs('popupDecideLogoutButtonCancelLabel');
        action = logout;
      } else if (widget.state == 'singout') {
        mainText = gs('popupDecideWithdrawalLabel');
        subText = gs('popupDecideWithdrawalDescription');
        buttonText1 = gs('popupDecideWithdrawalButtonConfirmLabel');
        buttonText2 = gs('popupDecideWithdrawalButtonCancelLabel');
        action = singout;
      } else if (widget.state == 'deldevice') {
        mainText = gs('popupInfoDeviceDeleteLabel');
        subText = gs('popupInfoDeviceDeleteDescription');
        buttonText1 = gs('popupInfoDeviceDeleteButtonConfirmLabel');
        buttonText2 = gs('popupInfoDeviceDeleteButtonCancelLabel');
        action = deldevice;
      }
    });
  }

  Future<void> logout() async {
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
              child: OkPopup(state: 'logout_ok'),
            ),
          ),
        );
      },
    );
    print('logout');
    await AppStateNotifier.instance.logout();
  }

  Future<void> singout() async {
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
              child: OkPopup(state: 'singout_ok'),
            ),
          ),
        );
      },
    );
    await UserController.deleteUser();
  }

  Future<void> disconnectAllBluetoothDevices() async {
    // 현재 연결된 모든 블루투스 기기 목록을 가져옵니다.
    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.connectedDevices;
    print(connectedDevices);

    // 각 기기와의 연결을 끊습니다.
    for (BluetoothDevice device in connectedDevices) {
      try {
        await device.disconnect();
        print('Disconnected from ${device.platformName}');
      } catch (e) {
        print('Error disconnecting from ${device.platformName}: $e');
      }
    }
  }

  Future<void> deldevice() async {
    AppStateNotifier.instance.removedevice();
    await disconnectAllBluetoothDevices;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 432,
      decoration: BoxDecoration(
        color: AppColors.Gray850,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 77, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.red,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(
                      mainText,
                      style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(subText, style: AppFont.r16.overrides(color: AppColors.Gray300), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 3, 0, 12),
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      child: LodingButtonWidget(
                        onPressed: () async {
                          action();
                        },
                        text: buttonText1,
                        options: LodingButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: AppColors.primaryBackground,
                          textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: () async {
                        context.safePop();
                      },
                      text: buttonText2,
                      options: LodingButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Colors.transparent,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
