import 'package:mwc/index.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/models/testuser.dart';
import 'package:mwc/utils/TypeManager.dart';
import 'package:mwc/views/home/mypage/widgets/calendar.dart';
import 'package:mwc/views/home/mypage/widgets/footlist.dart';
import 'package:mwc/views/home/scan/scandata.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Footreport extends StatefulWidget {
  const Footreport({
    Key? key,
  }) : super(key: key);

  @override
  State<Footreport> createState() => _Footreport2State();
}

class _Footreport2State extends State<Footreport> with SingleTickerProviderStateMixin {
  String type = '';
  List<DateTime> dateList = [];
  DateTime? selectedDate1;
  bool isCalendarOpened = false;
  bool islistOpened = false;
  TestUserRecord? selectedFoot;

  void initState() {
    super.initState();
    if (AppStateNotifier.instance.testUser != null) {
      dateList = AppStateNotifier.instance.testUser!.TestUserRecords.map((data) => data.measuredDate).toList();
      _onDateSelected(dateList.first);
    }
  }

  Future<void> showModalBottomSheetWithStates(BuildContext context) async {
    print('showModalBottomSheetWithStates');
    Map<String, dynamic> footDataAsMap = selectedFoot!.toJson();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => ScanData(mode: 'histroy', footdata: footDataAsMap),
    );
  }

  void _onDateSelected(DateTime newDate) {
    int index = dateList.indexWhere(
      (date) => date.year == newDate.year && date.month == newDate.month && date.day == newDate.day,
    );
    if (index != -1) {
      setState(() {
        selectedDate1 = dateList[index];
        print(selectedDate1);

        selectedFoot = AppStateNotifier.instance.testUser!.TestUserRecords.firstWhere(
          (data) => data.measuredDate == selectedDate1,
        );
        print('=');
        print(selectedFoot!.imageUrl);
      });
    }
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
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 44,
                      width: 112,
                      decoration: BoxDecoration(
                        color: AppColors.Gray850,
                        borderRadius: BorderRadius.circular(42),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            color: isCalendarOpened ? AppColors.primaryBackground : AppColors.Gray500,
                            onPressed: () {
                              showModalBottomSheet(
                                barrierColor: Colors.transparent,
                                isScrollControlled: true,
                                backgroundColor: AppColors.Gray850,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: Container(
                                        height: 550,
                                        child: CustomCalendar(
                                          timeData: dateList,
                                          selectedDate: selectedDate1,
                                          onDateSelected: _onDateSelected,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {
                                    isCalendarOpened = false;
                                  }));
                              setState(() {
                                isCalendarOpened = true;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: VerticalDivider(
                              color: AppColors.Gray500,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.list),
                            color: islistOpened ? AppColors.primaryBackground : AppColors.Gray500,
                            onPressed: () {
                              showModalBottomSheet(
                                barrierColor: Colors.transparent,
                                isScrollControlled: true,
                                backgroundColor: AppColors.Gray850,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return GestureDetector(
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.75,
                                        child: FootList(
                                          onSharePressed: () {},
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {
                                    islistOpened = false;
                                  }));
                              setState(() {
                                islistOpened = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 44,
                      width: 160,
                      decoration: BoxDecoration(
                        color: AppColors.Gray850,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: DropdownButton<DateTime>(
                          dropdownColor: AppColors.Gray850,
                          value: selectedDate1,
                          onChanged: (DateTime? newValue) {
                            _onDateSelected(newValue!);
                          },
                          items: dateList.map<DropdownMenuItem<DateTime>>((DateTime value) {
                            String formattedDate = "${value.year}.${value.month.toString().padLeft(2, '0')}.${value.day.toString().padLeft(2, '0')}";

                            return DropdownMenuItem<DateTime>(
                              value: value,
                              child: Text(
                                formattedDate,
                                style: AppFont.s12.overrides(fontSize: 16, color: AppColors.Gray100),
                              ),
                            );
                          }).toList(),
                          underline: SizedBox.shrink(),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            //color: AppColors.Gray100,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              (AppStateNotifier.testUser == null)
                  ? Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              SetLocalizations.of(context).getText('epdjdkdjqt'),
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
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
                            child: selectedFoot!.imageUrl != null
                                ? Image.network(
                                    selectedFoot!.imageUrl,
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
                                context.pushNamed('FootDetail', extra: selectedFoot!.imageUrl ?? '');
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
