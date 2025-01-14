import 'package:flutter/material.dart';

import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

// 다른 필요한 패키지들을 여기에 임포트하세요.

class WaitgroupScreen extends StatefulWidget {
  const WaitgroupScreen({Key? key}) : super(key: key);
  @override
  _WaitgroupScreenState createState() => _WaitgroupScreenState();
}

class _WaitgroupScreenState extends State<WaitgroupScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
      return GestureDetector(
        child: Scaffold(
          backgroundColor: AppColors.Black,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 42, 0, 83),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.Gray850,
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                      child: Text(
                                          SetLocalizations.of(context).getText(
                                            'dlalqhsoa' /* 보냈네요 */,
                                          ),
                                          style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground)),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                      child: Text(
                                          AppStateNotifier.instance.groupInvitation!.first.group!.groupName +
                                              SetLocalizations.of(context).getText(
                                                'ghkrdlsanswk' /* 기다려 */,
                                              ),
                                          style: AppFont.r16.overrides(fontSize: 12, color: AppColors.Gray300)),
                                    ),
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            height: 232,
                            decoration: BoxDecoration(
                              color: AppColors.Gray850,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                        child: Text(
                                            SetLocalizations.of(context).getText(
                                              'tlscjtndl' /* 취소하세요 */,
                                            ),
                                            style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground)),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                        child: Text(
                                            SetLocalizations.of(context).getText(
                                                  'dkssod' /*22 */,
                                                ) +
                                                AppStateNotifier.instance.groupInvitation!.first.group!.groupName +
                                                SetLocalizations.of(context).getText(
                                                  'dafdf' /*22 */,
                                                ),
                                            style: AppFont.r16.overrides(fontSize: 12, color: AppColors.Gray300)),
                                      ),
                                    ],
                                  ),
                                  LodingButtonWidget(
                                    onPressed: () async {
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
                                                child: cancelinvite(),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    text: SetLocalizations.of(context).getText(
                                      'cnlgh' /* 취소하기 */,
                                    ),
                                    options: LodingButtonOptions(
                                      width: double.infinity,
                                      height: 56.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: AppColors.primaryBackground,
                                      textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                                      elevation: 0,
                                      borderSide: BorderSide(
                                        color: AppColors.Black,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
