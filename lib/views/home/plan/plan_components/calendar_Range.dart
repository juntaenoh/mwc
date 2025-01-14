import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mwc/index.dart';

class CustomCalendarRange extends StatefulWidget {
  final List<DateTime> timeData;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Function(DateTime, DateTime) onDateRangeSelected;

  CustomCalendarRange({
    required this.timeData,
    this.selectedStartDate,
    this.selectedEndDate,
    required this.onDateRangeSelected,
  });

  @override
  _CustomCalendarRangeState createState() => _CustomCalendarRangeState();
}

class _CustomCalendarRangeState extends State<CustomCalendarRange> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn; // Ca
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late List<DropdownMenuItem<int>> monthDropdownItems;
  late List<DropdownMenuItem<int>> yearDropdownItems;

  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.selectedStartDate;
    _rangeEnd = widget.selectedEndDate;
    selectedMonth = _focusedDay.month;
    selectedYear = _focusedDay.year;
    yearDropdownItems = List.generate(6, (index) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      DropdownButton<int>(
                        dropdownColor: AppColors.Gray850,
                        value: _focusedDay.year,
                        items: yearDropdownItems,
                        style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Gray100),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedYear = value;
                              _focusedDay = DateTime(selectedYear, selectedMonth, _focusedDay.day);
                            });
                          }
                        },
                        underline: Container(),
                        icon: SizedBox.shrink(),
                      ),
                      Text(
                        '. ',
                        style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Gray100),
                      ),
                      DropdownButton<int>(
                        dropdownColor: AppColors.Gray850,
                        value: _focusedDay.month,
                        items: monthDropdownItems,
                        style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Gray100),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedMonth = value;
                              _focusedDay = DateTime(selectedYear, selectedMonth, _focusedDay.day);
                            });
                          }
                        },
                        underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 20),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              TableCalendar(
                headerVisible: false,
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                availableGestures: AvailableGestures.none,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    bool isSelected = false;
                    if (_rangeStart != null && _rangeEnd != null) {
                      isSelected = day.isAfter(_rangeStart!.subtract(Duration(days: 1))) && day.isBefore(_rangeEnd!.add(Duration(days: 1)));
                    }

                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.Black, // 기본 날짜 배경색을 초록색으로 설정
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: AppFont.s18.overrides(color: isSelected ? AppColors.Black : AppColors.Gray100),
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    bool isSelected = false;
                    if (_rangeStart != null && _rangeEnd != null) {
                      isSelected = day.isAfter(_rangeStart!.subtract(Duration(days: 1))) && day.isBefore(_rangeEnd!.add(Duration(days: 1)));
                    }

                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.Gray850, // 기본 날짜 배경색을 초록색으로 설정
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: AppFont.s18.overrides(color: isSelected ? AppColors.Black : AppColors.Gray700),
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    bool isSelected = false;
                    if (_rangeStart != null && _rangeEnd != null) {
                      isSelected = day.isAfter(_rangeStart!.subtract(Duration(days: 1))) && day.isBefore(_rangeEnd!.add(Duration(days: 1)));
                    }

                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.Black, // 기본 날짜 배경색을 초록색으로 설정
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: AppFont.s18.overrides(color: isSelected ? AppColors.Black : AppColors.Gray100),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.Black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Text(
                        day.day.toString(),
                        style: AppFont.s18.overrides(color: AppColors.primary),
                      ),
                    );
                  },
                ),
                calendarStyle: CalendarStyle(
                  rangeHighlightColor: AppColors.primary.withOpacity(0.5), // 범위 강조 색상 설정
                  rangeStartDecoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary, // 외곽선 색상 설정
                      width: 2.0, // 외곽선 두께 설정
                    ),
                    color: AppColors.Black, // 범위 시작 색상 설정
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                  ),
                  rangeEndDecoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary, // 외곽선 색상 설정
                      width: 2.0, // 외곽선 두께 설정
                    ),
                    color: AppColors.Black, // 범위 시작 색상 설정
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _rangeStart = null; // Important to clean those
                      _rangeEnd = null;
                      _rangeSelectionMode = RangeSelectionMode.toggledOff;
                    });
                  }
                },
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _selectedDay = null;
                    _focusedDay = focusedDay;
                    _rangeStart = start;
                    _rangeEnd = end;
                    _rangeSelectionMode = RangeSelectionMode.toggledOn;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Container(
              height: 56,
              width: double.infinity,
              child: LodingButtonWidget(
                onPressed: () {
                  if (_rangeStart != null && _rangeEnd != null) {
                    widget.onDateRangeSelected(_rangeStart!, _rangeEnd!);
                    Navigator.of(context).pop();
                  }
                },
                text: SetLocalizations.of(context).getText(
                  'goeidkfwk' /* 해당일자 선택 */,
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
          ),
        ],
      ),
    );
  }
}
