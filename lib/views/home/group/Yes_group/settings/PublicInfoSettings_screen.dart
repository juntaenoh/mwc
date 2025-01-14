import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';

class PublicInfoSettingsPage extends StatefulWidget {
  const PublicInfoSettingsPage({Key? key}) : super(key: key);

  @override
  _PublicInfoSettingsPageState createState() => _PublicInfoSettingsPageState();
}

class _PublicInfoSettingsPageState extends State<PublicInfoSettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool switchValue1 = false;
  bool switchValue2 = false;
  bool switchValue3 = false;
  bool switchValue4 = false;

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
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: AppColors.Black,
              appBar: AppBar(
                leading: AppIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.chevron_left,
                    color: AppColors.Gray700,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                backgroundColor: Color(0x00CCFF8B),
                automaticallyImplyLeading: false,
                title: Text(
                    SetLocalizations.of(context).getText(
                      'ze1uteze' /* 그룹   */,
                    ),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
                centerTitle: false,
                elevation: 0.0,
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('히스토리 알림', style: AppFont.s12.overrides(color: AppColors.primaryBackground, fontSize: 16)),
                            Text('히스토리 알림', style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 10)),
                          ],
                        ),
                        Switch.adaptive(
                          value: switchValue1,
                          onChanged: (newValue) async {
                            setState(() => switchValue1 = newValue);
                          },
                          activeColor: AppColors.primaryBackground,
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.Gray700,
                          inactiveThumbColor: AppColors.primaryBackground,
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.Gray700,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('히스토리 알림', style: AppFont.s12.overrides(color: AppColors.primaryBackground, fontSize: 16)),
                            Text('히스토리 알림', style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 10)),
                          ],
                        ),
                        Switch.adaptive(
                          value: switchValue2,
                          onChanged: (newValue) async {
                            setState(() => switchValue2 = newValue);
                          },
                          activeColor: AppColors.primaryBackground,
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.Gray700,
                          inactiveThumbColor: AppColors.primaryBackground,
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.Gray700,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('히스토리 알림', style: AppFont.s12.overrides(color: AppColors.primaryBackground, fontSize: 16)),
                            Text('히스토리 알림', style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 10)),
                          ],
                        ),
                        Switch.adaptive(
                          value: switchValue3,
                          onChanged: (newValue) async {
                            setState(() => switchValue3 = newValue);
                          },
                          activeColor: AppColors.primaryBackground,
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.Gray700,
                          inactiveThumbColor: AppColors.primaryBackground,
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.Gray700,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('히스토리 알림', style: AppFont.s12.overrides(color: AppColors.primaryBackground, fontSize: 16)),
                            Text('히스토리 알림', style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 10)),
                          ],
                        ),
                        Switch.adaptive(
                          value: switchValue4,
                          onChanged: (newValue) async {
                            setState(() => switchValue4 = newValue);
                          },
                          activeColor: AppColors.primaryBackground,
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: AppColors.Gray700,
                          inactiveThumbColor: AppColors.primaryBackground,
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.Gray700,
                    )
                  ],
                ),
              ))),
    );
  }
}
