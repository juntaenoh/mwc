import 'package:flutter/material.dart';
import '/index.dart';

class OkPopup extends StatefulWidget {
  final String state;

  const OkPopup({Key? key, required this.state}) : super(key: key);

  @override
  State<OkPopup> createState() => _CheckExitState();
}

class _CheckExitState extends State<OkPopup> {
  @override
  String mainText = '';
  String subText = '';
  late VoidCallback action;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateContent());
  }

  String gs(String code) {
    return SetLocalizations.of(context).getText(code);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateContent() {
    // 상태에 따라 내용 업데이트
    setState(() {
      if (widget.state == 'logout_ok') {
        mainText = gs('popupCompleteLogoutLabel');
        subText = gs('popupCompleteLogoutDescription');
        action = logout;
      } else if (widget.state == 'singout_ok') {
        mainText = gs('popupCompleteWithdrawalLabel');
        subText = gs('popupCompleteWithdrawalDescription');
        action = logout;
      }
    });
  }

  void logout() {
    context.goNamed('LandingScreen');
  }

  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 366,
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
                    color: AppColors.DarkenGreen,
                    size: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 20),
                    child: Text(
                      mainText,
                      style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                    ),
                  ),
                  Text(
                    subText,
                    style: AppFont.r16.overrides(color: AppColors.Gray300),
                    textAlign: TextAlign.center,
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
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: () async {
                        action();
                      },
                      text: SetLocalizations.of(context).getText(
                        'popupCompleteGroupJoinRequestButtonConfirmLabel' /* 확인 */,
                      ),
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
                        borderRadius: BorderRadius.circular(8.0),
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
