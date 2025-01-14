import 'package:mwc/components/1.1.1_Agreement_PopUp.dart';
import 'package:mwc/views/home/mypage/mypage_components/out_popup.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';

class MySetting extends StatefulWidget {
  const MySetting({Key? key}) : super(key: key);

  @override
  _MySettingState createState() => _MySettingState();
}

class _MySettingState extends State<MySetting> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
                state: 'logout',
              ),
            ),
          ),
        );
      },
    );
  }

  _showDeleteDialog() {
    print("tst");
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
              child: Exitservice(state: 'singout'),
            ),
          ),
        );
      },
    );
  }

  // void findPw() async {
  //   try {
  //     await _authService.resetPassword(
  //       email: AppStateNotifier.instance.userdata.,
  //       context: context,
  //     );
  //     await showAlignedDialog(
  //       context: context,
  //       isGlobal: true,
  //       avoidOverflow: false,
  //       targetAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
  //       followerAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
  //       builder: (dialogContext) {
  //         return Material(
  //           color: Colors.transparent,
  //           child: GestureDetector(
  //             child: Container(
  //               height: 432,
  //               width: 327,
  //               child: resetPwWidget(email: widget.email),
  //             ),
  //           ),
  //         );
  //       },
  //     ).then((value) => setState(() {}));
  //   } on FirebaseAuthException catch (e) {
  //     print(e.code);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> Menu = {
      'settingButtonDeviceLabel': 'DevicerManager',
      //'알림 설정': 'GroupJoinRequest',
      'settingButtonLanguageLabel': 'SettingLang',
      //'popupErrorLoginLabel5': 'SettingLang',
      //'로그인 방식 추가': 'InvitationCodeManage',
      //'전화번호 변경': 'DeleteGroup',
      'settingButtonPrivacyPolicyLabel': 'PublicInfoSetting',
      'settingButtonTermsServiceLabel': 'NotificationSetting',
      'settingButtonLogoutLabel': 'GroupHistory',
      'settingButtonWithdrawalLabel': 'GroupHistory',
    };

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
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColors.Black,
            appBar: AppBar(
              backgroundColor: AppColors.Black,
              leading: AppIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.chevron_left,
                  color: AppColors.primaryBackground,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pop();
                },
              ),
              automaticallyImplyLeading: false,
              title: Text(
                  SetLocalizations.of(context).getText(
                    'settingButtonReturnLabel' /* 설정  */,
                  ),
                  style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: ListView.builder(
              itemCount: Menu.length,
              itemBuilder: (context, index) {
                String menuKey = Menu.keys.elementAt(index);
                String menuTitle = SetLocalizations.of(context).getText(menuKey);
                return ListTile(
                  title: Text(menuTitle, style: AppFont.s12.overrides(fontSize: 16, color: AppColors.Gray100)),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.Gray100,
                  ),
                  onTap: () async {
                    if (menuKey == 'settingButtonLogoutLabel') {
                      _showLeaveDialog();
                    } else if (menuKey == 'settingButtonWithdrawalLabel') {
                      _showDeleteDialog();
                    } else if (menuKey == 'settingButtonPrivacyPolicyLabel') {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: Container(
                                  height: MediaQuery.sizeOf(context).height * 0.6,
                                  child: UptosWidget(
                                    index: 2,
                                    onAgree: (value) {},
                                  )),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    } else if (menuKey == 'settingButtonTermsServiceLabel') {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: Container(
                                  height: MediaQuery.sizeOf(context).height * 0.6,
                                  child: UptosWidget(
                                    index: 1,
                                    onAgree: (value) {},
                                  )),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    } else {
                      context.pushNamed(Menu[menuKey]!);
                    }
                  },
                );
              },
            ),
          )),
    );
  }
}
