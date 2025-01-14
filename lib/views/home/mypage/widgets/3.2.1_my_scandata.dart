import 'package:mwc/models/FootData.dart';
import 'package:mwc/models/UserData.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:mwc/utils/TypeManager.dart';
import 'package:mwc/views/home/scan/switch.dart';
import 'package:flutter/material.dart';
import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class MyScanData extends StatefulWidget {
  @override
  _MyScanDataState createState() => _MyScanDataState();
}

class _MyScanDataState extends State<MyScanData> {
  String type = '';
  int accuracy = 0;
  double height = 150; // 초기 높이
  IconData buttonIcon = Icons.keyboard_arrow_down; // 초기 아이콘
  bool togle = true;
  late List<FootData>? foot;
  late UserData mydata;
  @override
  void initState() {
    super.initState();
  }

  void _toggleHeight() {
    setState(() {
      if (togle) {
        togle = false;
        height = 100;
        buttonIcon = Icons.keyboard_arrow_up; // 위 화살표로 변경
      } else {
        togle = true;
        height = 150;
        buttonIcon = Icons.keyboard_arrow_down; // 아래 화살표로 변경
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, AppStateNotifier, child) {
      final TypeManager typeManager = TypeManager();
      typeManager.setType(context, AppStateNotifier.footdata?.first.classType);
      mydata = AppStateNotifier.userdata!;
      return Container(
        child: Column(
          children: [
            IconButton(
              onPressed: _toggleHeight, // 토글 함수 연결
              icon: Icon(
                buttonIcon,
                color: AppColors.Gray500,
              ), // 상태에 따라 달라지는 아이콘
            ),
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.Gray850,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                ),
              ),
              child: togle
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 44),
                      child: Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                SetLocalizations.of(context).getText('homeUserHeightLabel'),
                                style: AppFont.s12.overrides(color: AppColors.Gray500),
                              ),
                              Text(
                                mydata.height.toString() + 'cm',
                                style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                SetLocalizations.of(context).getText('homeUserWeightLabel'),
                                style: AppFont.s12.overrides(color: AppColors.Gray500),
                              ),
                              Text(
                                mydata.weight.toString() + 'kg',
                                style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Footprint',
                                style: AppFont.s12.overrides(color: AppColors.Gray500),
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 70,
                                    child: Text(
                                      typeManager.type,
                                      style: AppFont.b24.overrides(fontSize: 20, color: AppColors.primaryBackground),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    (AppStateNotifier.footdata != null) ? AppStateNotifier.footdata!.first.accuracy.toString() + '%' : '',
                                    style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Gray300),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ]),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      child: Text(
                        SetLocalizations.of(context).getText('rjsrkdwjdqh'),
                        style: AppFont.s12.overrides(fontSize: 16, color: AppColors.Gray500),
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
