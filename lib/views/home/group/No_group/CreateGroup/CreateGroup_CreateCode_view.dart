import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';

class GeneratCodeWidget extends StatefulWidget {
  const GeneratCodeWidget({Key? key}) : super(key: key);

  @override
  _GeneratCodeWidgetState createState() => _GeneratCodeWidgetState();
}

class _GeneratCodeWidgetState extends State<GeneratCodeWidget> {
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.Black,
        appBar: AppBar(
          backgroundColor: Color(0x00CCFF8B),
          automaticallyImplyLeading: false,
          title: Text(
            SetLocalizations.of(context).getText(
              'todakld' /* 그룹 생성 완료 */,
            ),
            style: AppFont.s18.overrides(color: AppColors.primaryBackground),
          ),
          actions: [
            AppIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 60,
              icon: Icon(
                Icons.close,
                color: AppColors.primaryBackground,
                size: 20,
              ),
              onPressed: () async {
                context.goNamed('home');
              },
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 40, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      SetLocalizations.of(context).getText(
                        'todtjdhskyh' /* 그룹 생성 완료 */,
                      ),
                      style: AppFont.b24.overrides(color: AppColors.primaryBackground),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 50, 8, 0),
                        child: Container(
                          height: 185,
                          decoration: ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFCFDFF).withOpacity(0.20), // 시작 색상
                                Color(0xFFFCFDFF).withOpacity(0.04), // 끝 색상
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
                            padding: const EdgeInsets.fromLTRB(12, 23, 12, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      SetLocalizations.of(context).getText(
                                        'cheozhemqkfr', //초대 코드를 발급해 주세요.
                                      ),
                                      style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                                    ),
                                    Text(
                                      SetLocalizations.of(context).getText(
                                        'dldkwlkt', //초대 코드의 유효 기간은 72시간입니다.
                                      ),
                                      style: AppFont.r16.overrides(color: AppColors.Gray300),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 56.0,
                                  child: LodingButtonWidget(
                                    onPressed: () async {
                                      await GroupApi.createInvitationCode();
                                      context.pushNamed('GroupInvitation');
                                    },
                                    text: SetLocalizations.of(context).getText(
                                      'zhemqkfkr', //초대 코드 발급
                                    ),
                                    options: LodingButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: AppColors.primaryBackground,
                                      textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
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
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 12),
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: () {
                        context.goNamed('home');
                      },
                      text: SetLocalizations.of(context).getText(
                        'rmfnqghq',
                      ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
