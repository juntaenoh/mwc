import 'dart:convert';

import 'package:mwc/views/home/scan/scandata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FootDetail extends StatefulWidget {
  final String url;
  const FootDetail({Key? key, required this.url}) : super(key: key);

  @override
  State<FootDetail> createState() => _FootDetailState();
}

class _FootDetailState extends State<FootDetail> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var data;
  bool main = true;
  String? firstName;
  String? lastName;
  Map<String, dynamic>? testerData;
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
    return Consumer<AppStateNotifier>(builder: (context, AppStateNotifier, child) {
      if (AppStateNotifier.userdata?.firstName == null) {
        firstName = 'test';
        lastName = 'er';
      } else {
        firstName = AppStateNotifier.userdata!.firstName;
        lastName = AppStateNotifier.userdata!.lastName;
      }

      return GestureDetector(
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: AppColors.Black,
            appBar: AppBar(
              backgroundColor: Color(0x00CCFF8B),
              automaticallyImplyLeading: false,
              title: Text(
                SetLocalizations.of(context).getText(
                  'reportPlantarPressureCompareLabel' /* Page Title */,
                ),
                style: AppFont.s18.overrides(color: AppColors.primaryBackground),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.primaryBackground,
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 307,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Image.network(
                      widget.url,
                      width: 307,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.Gray100),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(color: AppColors.Black, borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                          child: Center(
                            child: Text(
                              SetLocalizations.of(context)
                                  .getText('reportPlantarPressureCompareButtonAbnormalLabel', values: {'name': "${firstName}${lastName}"}),
                              style: AppFont.s18.overrides(color: AppColors.primaryBackground, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: AppColors.Gray100, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        child: Center(
                          child: Text(
                            SetLocalizations.of(context).getText('reportPlantarPressureCompareButtonNormalLabel'),
                            style: AppFont.s18.overrides(color: AppColors.Black, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: AppColors.Gray100),
                    child: Image.asset(
                      'assets/images/standard.png',
                      width: 327,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }
}
