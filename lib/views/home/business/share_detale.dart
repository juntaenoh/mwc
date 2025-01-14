import 'package:mwc/index.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/utils/TypeManager.dart';
import 'package:mwc/views/home/mypage/widgets/calendar.dart';
import 'package:mwc/views/home/mypage/widgets/footlist.dart';
import 'package:mwc/views/home/scan/scandata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class sharereport extends StatefulWidget {
  const sharereport({
    Key? key,
  }) : super(key: key);

  @override
  State<sharereport> createState() => _sharereport2State();
}

class _sharereport2State extends State<sharereport> with SingleTickerProviderStateMixin {
  String type = '';
  List<DateTime> dateList = [];
  DateTime? selectedDate1;
  bool isCalendarOpened = false;
  bool islistOpened = false;
  Map<String, dynamic>? selectedFoot;

  void initState() {
    super.initState();
    selectedFoot = {
      "recordId": "e5197008-a8bf-4194-8cb2-59f2940bdf27",
      "measuredDate": "2024-12-25",
      "measuredTime": "08:00:00",
      "rawData":
          "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000270E00120000000000000000000B000000000000000703170E261400000000000B0A0E1B0E0D000000001100000009335A000000000020160000003A470000000000020200100300003100000000000000001C00000000202C32410D1A0000000000280B1B1F0D00000000002B33352425261E0000000000152248333119000000113868290B1E1331000000000D2B28367448550A00008B283A32130F0A15000000002B3443262A6E52424F455D2D292804120100000000000020190F2D3A464D3B003981251D000000000000000000000000102027849800272D180100000000000000000000000000131F260000080B0A0000000000000000000000000000271C13000000091C0300000000000000000000000009084B0000000011050000000000000000000000000000130D00000000001300000000000000000A00000000030B090000000000090900000000000000000000000C210B00000000000001101F000000000000000000021718000000000000001B18181C0A00000000000336243F380000000000000000191D522300000000004543273627000000000000000030263B351F0000001470262A211000000000000000001958395E6A000000B442242119000000000000000000141D2C41270000001A2D2B2E2B0000000000000000000031361700000000003F1D55000000000000000000000004000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000F00F5D0460F00F",
      "firstClassType": 0.0,
      "firstAccuracy": 91.611,
      "secondaryClassType": 3.0,
      "secondaryAccuracy": 2.136,
      "thirdClassType": 5.0,
      "thirdAccuracy": 1.961,
      "leftFootLength": 258.62068965517244,
      "leftFootWidth": 61.36363636363637,
      "rightFootLength": 237.93103448275863,
      "rightFootWidth": 75.0,
      "footprintImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/945c7cb0-cb14-4f70-a18f-f4a6491c8abe-2024-12-17_10-40-19-fData.png",
      "combineFrontImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/945c7cb0-cb14-4f70-a18f-f4a6491c8abe-2024-12-17_10-40-19-front.png",
      "combineLeftImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/945c7cb0-cb14-4f70-a18f-f4a6491c8abe-2024-12-17_10-40-19-left.png",
      "combineRightImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/945c7cb0-cb14-4f70-a18f-f4a6491c8abe-2024-12-17_10-40-19-right.png",
      "combineBackImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/945c7cb0-cb14-4f70-a18f-f4a6491c8abe-2024-12-17_10-40-19-back.png",
      "firstClassTypeFrontImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/0_original_female_front.png",
      "firstClassTypeLeftImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/0_original_female_left.png",
      "firstClassTypeRightImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/0_original_female_right.png",
      "firstClassTypeBackImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/0_original_female_back.png",
      "secondClassTypeFrontImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/3_original_female_front.png",
      "secondClassTypeLeftImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/3_original_female_left.png",
      "secondClassTypeRightImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/3_original_female_right.png",
      "secondClassTypeBackImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/3_original_female_back.png",
      "thirdClassTypeFrontImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/5_original_female_front.png",
      "thirdClassTypeLeftImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/5_original_female_left.png",
      "thirdClassTypeRightImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/5_original_female_right.png",
      "thirdClassTypeBackImageUrl": "http://15.165.125.100:8085/demo/v1/aws/download/5_original_female_back.png",
      "weight": 93.4
    };
  }

  Future<void> showModalBottomSheetWithStates(BuildContext context) async {
    print('showModalBottomSheetWithStates');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => ScanData(mode: 'tester', footdata: selectedFoot!),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, AppStateNotifier, child) {
      return Scaffold(
        backgroundColor: AppColors.Black,
        appBar: AppBar(
          backgroundColor: AppColors.Black,
          title: const Text(
            '',
            style: AppFont.b24w,
          ),
          iconTheme: IconThemeData(color: AppColors.primaryBackground),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 327,
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: selectedFoot!['footprintImageUrl'] != null
                          ? Image.network(
                              selectedFoot!['footprintImageUrl'],
                              width: 190,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Text('이미지를 로드할 수 없습니다.', style: TextStyle(color: Colors.white));
                              },
                            )
                          : Container(
                              color: Colors.black, // Display a black container if selectedUrl is null
                            ),
                    ),
                    Container(
                      width: 252,
                      height: 52.0,
                      decoration: BoxDecoration(),
                      child: LodingButtonWidget(
                        onPressed: () async {
                          context.pushNamed('FootDetail', extra: selectedFoot!['footprintImageUrl'] ?? '');
                        },
                        text: SetLocalizations.of(context).getText(
                          'reportPlantarPressureButtonCompareLabel' /*이상적인 Page Title */,
                        ),
                        options: LodingButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: AppColors.primary,
                          textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 56.0,
                            decoration: BoxDecoration(),
                            child: LodingButtonWidget(
                              onPressed: () {
                                showModalBottomSheetWithStates(context);
                              },
                              text: SetLocalizations.of(context).getText(
                                'reportPlantarPressureDetailbutton' /*리포트 상세 내용 보기 */,
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
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
