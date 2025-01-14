import 'package:mwc/models/Schedule.dart';
import 'package:mwc/views/home/plan/plan_components/AddSchedule.dart';
import 'package:mwc/views/home/plan/plan_components/Plan_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../widgets/App_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';

class planWidget extends StatefulWidget {
  const planWidget({Key? key}) : super(key: key);

  @override
  _planWidgetState createState() => _planWidgetState();
}

class _planWidgetState extends State<planWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _tempSelectedDate;
  late int selectedMonth;
  late int selectedYear;
  late List<DropdownMenuItem<int>> monthDropdownItems;
  late List<DropdownMenuItem<int>> yearDropdownItems;
  late List<DateTime> timeData;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<String> buttonTexts = ["유형", "일정종류", "최신순"];

  @override
  void initState() {
    super.initState();
    selectedMonth = _focusedDay.month;
    selectedYear = _focusedDay.year;
    yearDropdownItems = List.generate(6, (index) {
      // 2020년부터 2025년까지 예시
      int year = 2020 + index;
      return DropdownMenuItem<int>(
        value: year,
        child: Text("$year"),
      );
    });
    monthDropdownItems = List.generate(12, (index) {
      String month = (index + 1).toString().padLeft(2, '0');
      return DropdownMenuItem<int>(
        value: index + 1,
        child: Text(month),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      if (details.primaryDelta! > 0 && _calendarFormat != CalendarFormat.month) {
        setState(() {
          _calendarFormat = CalendarFormat.month;
        });
      } else if (details.primaryDelta! < 0 && _calendarFormat != CalendarFormat.week) {
        setState(() {
          _calendarFormat = CalendarFormat.week;
        });
      }
    }
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
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.Black,
        appBar: AppBar(
          backgroundColor: AppColors.Gray850,
          automaticallyImplyLeading: false,
          title: Text(
              SetLocalizations.of(context).getText(
                '4a0fxxdm' /* 계정 생성 */,
              ),
              style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: AppColors.Gray850,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                      child: Column(
                        children: [
                          _buildCustomHeader(),
                          _tableBuilder(appStateNotifier.targetdata!),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onVerticalDragUpdate: _onVerticalDragUpdate,
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: 20.0,
                      alignment: Alignment.center,
                      child: Container(
                        height: 3.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      children: [
                        _buildSubHead(),
                        _buildfilter(appStateNotifier.scheduleData!),
                        _buildList(appStateNotifier.scheduleData!, _tempSelectedDate),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showAddSchedulePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddSchedulePopup(
          onAddMySchedule: _addMySchedule,
          onAddGroupSchedule: _addGroupSchedule,
        );
      },
    );
  }

  void _addMySchedule() {
    // 내 일정 추가하기 로직 구현
    context.goNamed('AddSchedule');
    // 일정 추가 로직 작성
  }

  void _addGroupSchedule() {
    // 그룹 멤버 일정 추가하기 로직 구현
    Navigator.of(context).pop();
    // 일정 추가 로직 작성
  }

  void _showModalBottomSheet(BuildContext context, int buttonIndex) {
    if (buttonIndex == 0) {
      List<String> names = ['그룹 일정', '개인 일정'];
      List<String> selectedValues = buttonTexts[buttonIndex].split(', ');

      Map<String, bool> checkboxes = {
        for (var option in names) option: selectedValues.contains(option),
      };

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Plantype(
            name: '유형',
            checkboxes: checkboxes,
            onCompleted: (String value) {
              if (value.isEmpty) {
                setState(() {
                  buttonTexts[buttonIndex] = '유형';
                });
              } else {
                print(value);
                setState(() {
                  buttonTexts[buttonIndex] = value;
                });
              }
            },
          );
        },
      );
    } else if (buttonIndex == 1) {
      List<String> names = ['운동', '약복용', '병원', '측정하기', '기타'];
      List<String> selectedValues = buttonTexts[buttonIndex].split(', ');

      Map<String, bool> checkboxes = {
        for (var option in names) option: selectedValues.contains(option),
      };

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Plantype(
            name: '일정 종류',
            checkboxes: checkboxes,
            onCompleted: (String value) {
              if (value.isEmpty) {
                setState(() {
                  buttonTexts[buttonIndex] = '일정 종류';
                });
              } else {
                setState(() {
                  buttonTexts[buttonIndex] = value;
                });
              }
            },
          );
        },
      );
    } else if (buttonIndex == 2) {
      List<String> names = ['최신순', '오래된순'];
      List<String> selectedValues = buttonTexts[buttonIndex].split(', ');

      Map<String, bool> checkboxes = {
        for (var option in names) option: selectedValues.contains(option),
      };
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Plantype(
            name: '정렬',
            checkboxes: checkboxes,
            onCompleted: (String value) {
              if (value.isEmpty) {
                setState(() {
                  buttonTexts[buttonIndex] = '정렬';
                });
              } else {
                setState(() {
                  buttonTexts[buttonIndex] = value;
                });
              }
            },
          );
        },
      );
    }
  }

  void _showDatePicker() {}

  Widget _buildList(List<ScheduleData> rowdata, DateTime? selectedDate) {
    if (selectedDate == null) return Container();

    List<ScheduleData> selecteddata = rowdata.where((data) => isSameDay(data.targetDate, selectedDate)).toList();
    return Container(
      height: 400,
      child: ListView.builder(
        itemCount: selecteddata.length,
        itemBuilder: (context, index) {
          ScheduleData data = selecteddata[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.Gray850,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.category, // 카테고리
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                  ),
                  SizedBox(height: 8),
                  Text(
                    data.title, // 타이틀
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _formatTimeOfDay(data.startTime), // 시작 시간
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildfilter(List<ScheduleData> rowdata) {
    // if (selectedSort == '최신순') {
    //   filteredData.sort((a, b) => b.startDate.compareTo(a.startDate));
    // } else if (selectedSort == '오래된순') {
    //   filteredData.sort((a, b) => a.startDate.compareTo(b.startDate));
    // }
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: buttonTexts.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8),
            child: LodingButtonWidget(
              options: LodingButtonOptions(
                height: 30.0,
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: ["유형", "일정 종류", "최신순"].contains(buttonTexts[index]) ? Colors.transparent : AppColors.primary,
                textStyle: AppFont.s18.overrides(
                  fontSize: 12,
                  color: ["유형", "일정 종류", "최신순"].contains(buttonTexts[index]) ? AppColors.Gray300 : AppColors.Black,
                ),
                elevation: 0,
                borderSide: BorderSide(
                  color: ["유형", "일정 종류", "최신순"].contains(buttonTexts[index]) ? AppColors.Gray300 : AppColors.primary,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(24.0),
              ),
              onPressed: () => _showModalBottomSheet(context, index),
              text: buttonTexts[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubHead() {
    if (_tempSelectedDate == null) {
      return Container();
    }

    final DateFormat formatter = DateFormat('M월 d일 EEEE', 'ko');
    final String formattedDate = formatter.format(_tempSelectedDate!);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            formattedDate,
            style: AppFont.s18.overrides(color: AppColors.primaryBackground),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          color: AppColors.primaryBackground,
          onPressed: _showAddSchedulePopup,
        ),
      ],
    );
  }

  Widget _tableBuilder(List<DateTime> targetDates) {
    double height = 40;

    return TableCalendar(
      rowHeight: 54,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      headerVisible: false,
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_tempSelectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _tempSelectedDate = selectedDay;
        });
      },
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          Color backgroundColor = _calendarFormat == CalendarFormat.week ? Colors.transparent : AppColors.Black;
          bool isTargetDate = false;

          for (DateTime date in targetDates) {
            if (isSameDay(date, day)) {
              isTargetDate = true;
              break;
            }
          }
          if (isTargetDate) {
            return Column(
              children: [
                Container(
                  height: height,
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    day.day.toString(),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                  ),
                ),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  height: height,
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    day.day.toString(),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                  ),
                ),
              ],
            );
          }
        },
        outsideBuilder: (context, day, focusedDay) {
          Color backgroundColor = _calendarFormat == CalendarFormat.week ? Colors.transparent : AppColors.Gray850;
          Color textColor = _calendarFormat == CalendarFormat.week ? AppColors.primaryBackground : AppColors.Gray500;
          double radius = _calendarFormat == CalendarFormat.week ? 24 : 8;
          bool isTargetDate = targetDates.contains(day);

          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Text(
                  day.day.toString(),
                  style: AppFont.s18.overrides(color: textColor),
                ),
              ),
              if (isTargetDate)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          );
        },
        todayBuilder: (context, day, focusedDay) {
          Color backgroundColor = _calendarFormat == CalendarFormat.week ? Colors.transparent : AppColors.Black;
          bool isTargetDate = false;

          for (DateTime date in targetDates) {
            if (isSameDay(date, day)) {
              isTargetDate = true;
              break;
            }
          }
          if (isTargetDate) {
            return Column(
              children: [
                Container(
                  height: height,
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    day.day.toString(),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                  ),
                ),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  height: height,
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    day.day.toString(),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                  ),
                ),
              ],
            );
          }
        },
        selectedBuilder: (context, day, focusedDay) {
          Color backgroundColor = _calendarFormat == CalendarFormat.week ? AppColors.primary : AppColors.Black;
          Color textColor = _calendarFormat == CalendarFormat.week ? AppColors.Black : AppColors.primary;
          double radius = _calendarFormat == CalendarFormat.week ? 24 : 8;
          bool isTargetDate = false;

          for (DateTime date in targetDates) {
            if (isSameDay(date, day)) {
              isTargetDate = true;
              break;
            }
          }
          if (isTargetDate) {
            return Column(
              children: [
                Container(
                  height: height,
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    day.day.toString(),
                    style: AppFont.s18.overrides(color: textColor),
                  ),
                ),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  height: height,
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    day.day.toString(),
                    style: AppFont.s18.overrides(color: textColor),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCustomHeader() {
    String formattedDate = DateFormat('yyyy.MM').format(_focusedDay);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(formattedDate, style: AppFont.b24.overrides(fontSize: 20, color: AppColors.primaryBackground)),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down_outlined),
              color: AppColors.primaryBackground,
              onPressed: () {
                _showDatePicker();
              },
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.keyboard_arrow_left_outlined),
              color: AppColors.primaryBackground,
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month - 1,
                  );
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right_outlined),
              color: AppColors.primaryBackground,
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month + 1,
                  );
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
