import 'package:mwc/index.dart';
import 'package:mwc/models/WeightData.dart';
import 'package:mwc/views/home/mypage/widgets/calendar.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:mwc/views/home/mypage/widgets/deleteList.dart';
import 'package:mwc/widgets/snackbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/streams.dart';

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<WeightData> weightdata = [];
  List<DateTime> timeData = [];
  List<double> weights = [];
  LineBarSpot? _lastTouchedSpot;
  DateTime? selectedDate2;
  bool isCalendarOpened = false;
  String _selectedItem = 'old';
  bool isshow = false;
  List<String> selectedweight = [];
  List<String> allweight = [];

  void initState() {
    super.initState();
    if (!AppStateNotifier.instance.isweightData) {
      processData();
      selectedDate2 = timeData.last;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void processData() {
    weightdata = AppStateNotifier.instance.weightData!;
    weightdata.sort((a, b) => a.measuredTime.compareTo(b.measuredTime));
    Map<String, WeightData> latestDataByDate = {};
    for (var data in weightdata) {
      String dateKey = DateFormat('yyyy-MM-dd').format(data.measuredDate);
      if (!latestDataByDate.containsKey(dateKey) || data.measuredTime.isAfter(latestDataByDate[dateKey]!.measuredTime)) {
        latestDataByDate[dateKey] = data;
      }
    }
    List<WeightData> filteredList = latestDataByDate.values.toList();
    timeData = [];
    weights = [];
    for (var item in filteredList) {
      DateTime dateTime = item.measuredTime;

      timeData.add(dateTime);
      weights.add((item.weight * 2.20462).ceilToDouble());
    }
    print(weights.length);
  }

  List<Color> gradientColors = [
    AppColors.primary,
    AppColors.Black,
  ];

  bool showAvg = false;
  void _onDateSelected(DateTime newDate) {
    DateTime matchedDate = timeData.firstWhere(
      (date) => date.year == newDate.year && date.month == newDate.month && date.day == newDate.day,
    );
    setState(() {
      selectedDate2 = matchedDate;
    });
  }

  String formatDateTime(DateTime timeStr) {
    Locale? locale = SetLocalizations.getStoredLocale();

    if (locale != null) {
      String formatted = DateFormat('yy/MM/dd EEEE HH:mm', '${locale.languageCode}').format(timeStr);
      return formatted;
    } else
      return '';
  }

  String typestring(String type) {
    switch (type) {
      case 'FOOTPRINT':
        {
          return 'FOOTPRINT';
        }
      case 'WEIGHT':
        {
          return 'WEIGHT';
        }
      case 'USER':
        {
          return 'USER';
        }
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    double chartWidth = timeData.length * 60.0;

    return Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
      allweight = appStateNotifier.weightData!.map((item) => item.weightId).toList();

      return Scaffold(
        backgroundColor: AppColors.Black,
        body: appStateNotifier.isweightData
            ? Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
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
                  ),
                ],
              )
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  height: MediaQuery.sizeOf(context).height * 0.70,
                                                  child: CustomCalendar(
                                                    timeData: timeData,
                                                    selectedDate: selectedDate2,
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
                                    VerticalDivider(
                                      color: AppColors.Gray500,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.list),
                                      color: isCalendarOpened ? AppColors.Gray500 : AppColors.primaryBackground,
                                      onPressed: () {
                                        setState(() {
                                          if (isCalendarOpened) {
                                            isCalendarOpened = false;
                                          }
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
                                    value: selectedDate2,
                                    onChanged: (DateTime? newValue) {
                                      setState(() {
                                        selectedDate2 = newValue;
                                      });
                                    },
                                    items: timeData.map<DropdownMenuItem<DateTime>>((DateTime weightValue) {
                                      String weightDate =
                                          "${weightValue.year}.${weightValue.month.toString().padLeft(2, '0')}.${weightValue.day.toString().padLeft(2, '0')}";

                                      return DropdownMenuItem<DateTime>(
                                        value: weightValue,
                                        child: Text(
                                          weightDate,
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: chartWidth - 10,
                              height: 180,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(35, 35, 35, 10),
                                child: LineChart(
                                  mainData(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildList(context, appStateNotifier),
                  ],
                ),
              ),
      );
    });
  }

//TODOdi
  void showdelAllDialog(List<String> allFootprints) {
    showCustomDialog(
        context: context,
        backGroundtype: 'black',
        checkButtonColor: AppColors.red,
        titleText: SetLocalizations.of(context).getText('popupDecideDeleteReportWeightAllLabel'),
        descriptionText: SetLocalizations.of(context).getText('popupDecideDeleteReportWeightAllDescription'),
        upperButtonText: SetLocalizations.of(context).getText('popupDecideDeleteReportWeightAllButtonConfirmLabel'),
        upperButtonFunction: () async {
          //todo 모든 리포트 삭제
          FootprintApi.deleteAllWegith();
          // for (String item in allFootprints) {
          //   FootprintApi.deleteSomePrint(item);
          // }
          showCustomSnackBar(context, SetLocalizations.of(context).getText('historyDeleteWeightAllToast'));

          print(allFootprints);
          context.safePop();
        },
        lowerButtonText: SetLocalizations.of(context).getText('popupDecideDeleteReportWeightAllButtonCancelLabel'),
        /* 이전으로 돌아가기 */
        lowerButtonFunction: () {
          context.safePop();
        });
  }

  void showcheckbox() {
    setState(() {
      isshow = !isshow;
      print(isshow);
    });
  }

//TODOdi
  void showdelSomeDialog(List<String> selectedFootprints) {
    showCustomDialog(
        context: context,
        checkButtonColor: AppColors.red,
        backGroundtype: 'black',
        titleText: SetLocalizations.of(context).getText(
          'popupDecideDeleteReportWeightLabel',
          values: {
            'count': selectedFootprints.length.toString(),
          },
        ),
        descriptionText: SetLocalizations.of(context).getText('popupDecideDeleteReportWeightDescription'),
        upperButtonText: SetLocalizations.of(context).getText('popupDecideDeleteReportWeightButtonConfirmLabel'),
        upperButtonFunction: () async {
          //todo 선택한리포트 삭제
          for (String item in selectedFootprints) {
            FootprintApi.deleteSomeWegith(item);
            showCustomSnackBar(context, SetLocalizations.of(context).getText('historyDeleteWeightSelectedToast'));
          }
          context.safePop();
          print(selectedFootprints);
        },
        lowerButtonText: SetLocalizations.of(context).getText('popupDecideDeleteReportWeightButtonCancelLabel'),
        lowerButtonFunction: () {
          context.safePop();
        });
  }

  Widget _buildList(BuildContext context, AppStateNotifier appStateNotifier) {
    final Map<String, String> sortitem = {
      'new': SetLocalizations.of(context).getText('groupSettingHistoryFilterSortNewLabel'),
      'old': SetLocalizations.of(context).getText('groupSettingHistoryFilterSortOldLabel'),
    };
    return Stack(
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: sortitem[_selectedItem],
                        onChanged: (String? newValue) {
                          setState(() {
                            String value = sortitem.keys.firstWhere((element) => sortitem[element] == newValue);
                            if (value == 'new') {
                              _selectedItem = 'new';
                            } else if (value == 'old') {
                              _selectedItem = 'old';
                            }
                            appStateNotifier.sortweightdata(_selectedItem); // 데이터 정렬 함수
                          });
                        },
                        underline: Container(),
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        items: sortitem.values.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: AppFont.s12.overrides(fontSize: 18),
                            ),
                          );
                        }).toList(),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: AppColors.Black,
                        ),
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
                                    height: 96,
                                    width: 200,
                                    child: DeleteOptionsWidget(
                                      onshow: () => showcheckbox(),
                                      onDeleteAll: () => showdelAllDialog(allweight), // 함수 호출이 아닌 함수 참조 전달
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: appStateNotifier.weightData!.length,
                    itemBuilder: (context, index) {
                      final item = appStateNotifier.weightData![index];

                      final isChecked = selectedweight.contains(item.weightId);

                      bool plus = true;
                      if (item.weightChange != null) {
                        if (item.weightChange < 0) {
                          plus = true;
                        } else {
                          plus = false;
                        }
                      }
                      return Container(
                        height: 86,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatDateTime(item.measuredTime),
                                        style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 10),
                                      ),
                                      Text(
                                        typestring(item.weightType),
                                        style: AppFont.s12,
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (item.weightChange != 0)
                                        Text(
                                          (item.weightChange * 2.20462).toStringAsFixed(2) + 'lbs',
                                          style: AppFont.s12.overrides(color: plus ? AppColors.AlertGreen : AppColors.red),
                                        ),
                                      Text(
                                        '${(item.weight * 2.20462).toStringAsFixed(2)} lbs',
                                        style: AppFont.s12.overrides(fontSize: 16, color: AppColors.Black),
                                      ),
                                    ],
                                  ),
                                  if (isshow)
                                    Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        unselectedWidgetColor: AppColors.Gray200,
                                      ),
                                      child: Checkbox(
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedweight.add(item.weightId);
                                            } else {
                                              selectedweight.remove(item.weightId);
                                            }
                                          });
                                        },
                                        activeColor: AppColors.Black,
                                        checkColor: AppColors.primaryBackground,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.Gray100,
                            )
                          ],
                        ),

                        // title: Text("Type: ${widget.data[index]['weightType']}"),
                        // subtitle: Text(
                        //     "Date: ${widget.data[index]['measuredDate']} Time: ${widget.data[index]['measuredTime']}\nWeight: ${widget.data[index]['weight']}kg Difference: ${diff != null ? diff.toStringAsFixed(2) : 'N/A'}kg"),
                      );
                    },
                  ),
                ),
                if (isshow)
                  Container(
                    width: 327,
                    height: 60.0,
                  )
              ],
            ),
          ),
        ),
        if (isshow)
          Positioned(
            right: 20,
            bottom: 10,
            child: Container(
              width: 327,
              height: 56.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(1), // 흰색 그림자, 투명도 조절 가능
                    spreadRadius: 82, // 그림자의 범위를 넓힘
                    blurRadius: 15, // 그림자의 흐릿함 정도
                    offset: Offset(0, 50), // 그림자의 방향 (x, y)
                  ),
                ],
              ),
              child: LodingButtonWidget(
                onPressed: () async {
                  selectedweight.isEmpty ? null : showdelSomeDialog(selectedweight);
                },
                text: SetLocalizations.of(context).getText('historyButtonDeleteLabel'),
                options: LodingButtonOptions(
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: selectedweight.isEmpty ? AppColors.Gray200 : AppColors.Black,
                  textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color LineTooltipColor(LineBarSpot touchedSpot) {
    return AppColors.primary;
  }

  LineChartData mainData() {
    final double minYValue = weights.reduce(min);
    final double maxYValue = weights.reduce(max);
    final double margin = 20.0;

    return LineChartData(
      lineTouchData: LineTouchData(
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          setState(() {
            if (event is! FlPointerExitEvent && touchResponse?.lineBarSpots != null) {
              _lastTouchedSpot = touchResponse!.lineBarSpots!.first;
            }
          });
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 16,
          getTooltipColor: LineTooltipColor,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            if (_lastTouchedSpot != null) {
              final textStyle = AppFont.s12.overrides(color: AppColors.Black);
              return [LineTooltipItem('${_lastTouchedSpot!.y}', textStyle)];
            }
            return [];
          },
        ),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.DarkenGreen,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.Black,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final DateTime date = timeData[value.toInt()];
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  '${date.month}/${date.day}',
                  style: AppFont.s12.overrides(color: AppColors.Gray200),
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(bottom: (BorderSide(color: AppColors.Gray700))),
      ),
      minX: 0,
      maxX: timeData.length.toDouble() - 1,
      minY: minYValue - margin,
      maxY: maxYValue + margin,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            timeData.length,
            (index) => FlSpot(index.toDouble(), weights[index]),
          ),
          isCurved: false,
          barWidth: 1,
          color: AppColors.primaryBackground,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              final date = timeData[spot.x.toInt()];
              return FlDotCirclePainter(
                radius: 4,
                color: selectedDate2 != null && date == selectedDate2 ? AppColors.DarkenGreen : AppColors.Gray100,
                strokeWidth: 0,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
