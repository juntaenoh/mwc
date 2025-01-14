import 'package:mwc/components/Setting_type.dart';
import 'package:mwc/models/GroupHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class ButtonPopup {
  String title;
  Widget page;

  ButtonPopup({required this.title, required this.page});
}

class GroupHistoryPage extends StatefulWidget {
  const GroupHistoryPage({Key? key}) : super(key: key);

  @override
  _GroupHistoryPageState createState() => _GroupHistoryPageState();
}

class _GroupHistoryPageState extends State<GroupHistoryPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<GroupHistory> histories = [];
  List<GroupHistory> _filteredGroupHistoryList = [];
  List<String> _selectedCategory = [];
  List<String> _selectedMember = [];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isDescending = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _filterGroupHistoryList() {
    print(_selectedCategory);
    print(_selectedMember);
    setState(() {
      _filteredGroupHistoryList = histories.where((history) {
        bool matchesCategory = _selectedCategory.contains(history.shortDescription);
        bool matchesMember = _selectedMember.contains('${history.firstName} ${history.lastName}');
        bool matchesDateRange = (_startDate == null && _endDate == null) ||
            (DateFormat('yyyy-MM-dd').parse(history.date).isAfter(_startDate!) && DateFormat('yyyy-MM-dd').parse(history.date).isBefore(_endDate!));
        return matchesCategory && matchesMember && matchesDateRange;
      }).toList();

      if (_isDescending) {
        _filteredGroupHistoryList.sort((a, b) => DateFormat('yyyy-MM-dd').parse(b.date).compareTo(DateFormat('yyyy-MM-dd').parse(a.date)));
      } else {
        _filteredGroupHistoryList.sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.date).compareTo(DateFormat('yyyy-MM-dd').parse(b.date)));
      }
    });
    print(_filteredGroupHistoryList);
  }

  List<String> NamesFromHistories(List<GroupHistory> histories) {
    return histories.map((history) => history.firstName + history.lastName).toList();
  }

  List<String> TaypeFromHistories(List<GroupHistory> histories) {
    return histories.map((history) => history.shortDescription).toList();
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            for (var category in histories.map((e) => e.shortDescription).toSet())
              ListTile(
                title: Text(category),
                onTap: () {
                  if (_selectedCategory.contains(category)) {
                    setState(() {
                      _selectedCategory.remove(category);
                      _filterGroupHistoryList();
                    });
                  } else
                    setState(() {
                      _selectedCategory.add(category);
                      _filterGroupHistoryList();
                    });
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }

  void _showMemberBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            for (var member in histories.map((e) => '${e.firstName} ${e.lastName}').toSet())
              ListTile(
                title: Text(member),
                onTap: () {
                  if (_selectedMember.contains(member)) {
                    setState(() {
                      _selectedMember.remove(member);
                      _filterGroupHistoryList();
                    });
                  } else
                    setState(() {
                      _selectedMember.add(member);
                      _filterGroupHistoryList();
                    });
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }

  void _showDateRangeBottomSheet(BuildContext context) {
    DateTimeRange? selectedDateRange;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            ElevatedButton(
              child: Text('Select Date Range'),
              onPressed: () async {
                selectedDateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDateRange != null) {
                  setState(() {
                    _startDate = selectedDateRange!.start;
                    _endDate = selectedDateRange!.end;
                  });
                  _filterGroupHistoryList();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSortOrderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            ListTile(
              title: Text('최신순'),
              onTap: () {
                setState(() {
                  _isDescending = true;
                });
                _filterGroupHistoryList();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('오래된순'),
              onTap: () {
                setState(() {
                  _isDescending = false;
                });
                _filterGroupHistoryList();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String timeElapsedSince(String logTimeStr) {
    DateTime logTime = DateTime.parse(logTimeStr);
    DateTime currentTime = DateTime.now();
    Duration timeDifference = currentTime.difference(logTime);
    int months = (currentTime.year - logTime.year) * 12 + currentTime.month - logTime.month;
    int days = timeDifference.inDays;
    int hours = timeDifference.inHours % 24;
    String timeDiffStr = "";
    if (months > 0) {
      timeDiffStr += "$months 개월, ";
    } else if (days > 0) {
      timeDiffStr += "$days 일, ";
    } else if (hours > 0) {
      timeDiffStr += "$hours 시간, ";
    }

    timeDiffStr = timeDiffStr.trimRight().replaceAll(RegExp(r',$'), '');

    return timeDiffStr.isEmpty ? "지금" : timeDiffStr + " 전";
  }

  List<String> buttonTexts = ["유형", "멤버", "기간", "최신순"];

  // void _showModalBottomSheet(BuildContext context, int buttonIndex) {
  //   List<String> type = TaypeFromHistories(histories);
  //   if (buttonIndex == 0) {
  //     Map<String, bool> checkboxes = {for (var option in type) option: false};
  //     showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return SettingType(
  //           name: '유형',
  //           checkboxes: checkboxes,
  //           onCompleted: (String value) {
  //             setState(() {
  //               selectedType = value;
  //               buttonTexts[buttonIndex] = value.isEmpty ? '유형' : value;
  //               _filterHistories();
  //             });
  //           },
  //         );
  //       },
  //     );
  //   } else if (buttonIndex == 1) {
  //     List<String> names = NamesFromHistories(histories);
  //     Map<String, bool> checkboxes = {for (var option in names) option: false};
  //     showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return SettingType(
  //           name: '멤버',
  //           checkboxes: checkboxes,
  //           onCompleted: (String value) {
  //             setState(() {
  //               selectedMember = value;
  //               buttonTexts[buttonIndex] = value.isEmpty ? '멤버' : value;
  //               _filterHistories();
  //             });
  //           },
  //         );
  //       },
  //     );
  //   } else if (buttonIndex == 2) {
  //     Map<String, bool> checkboxes = {"Option 1": false, "Option 2": false};
  //     showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return SettingType(
  //           name: '기간',
  //           checkboxes: checkboxes,
  //           onCompleted: (String value) {
  //             setState(() {
  //               selectedPeriod = value;
  //               buttonTexts[buttonIndex] = value.isEmpty ? '기간' : value;
  //               _filterHistories();
  //             });
  //           },
  //         );
  //       },
  //     );
  //   } else if (buttonIndex == 3) {
  //     Map<String, bool> checkboxes = {"최신순": selectedOrder == '최신순', "오래된순": selectedOrder == '오래된순'};
  //     showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return SettingType(
  //           name: '정렬',
  //           checkboxes: checkboxes,
  //           onCompleted: (String value) {
  //             setState(() {
  //               selectedOrder = value;
  //               buttonTexts[buttonIndex] = value.isEmpty ? '정렬' : value;
  //               _filterHistories();
  //             });
  //           },
  //         );
  //       },
  //     );
  //   }
  // }

  bool isselected() {
    return true;
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

    return Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
      histories = appStateNotifier.groupHistroy!;

      return GestureDetector(
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
                  color: AppColors.primaryBackground,
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
                    'ngpljxdi' /* 그룹 히스토리   */,
                  ),
                  style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showCategoryBottomSheet(context),
                          child: Text('유형'),
                        ),
                        ElevatedButton(
                          onPressed: () => _showMemberBottomSheet(context),
                          child: Text('맴버'),
                        ),
                        ElevatedButton(
                          onPressed: () => _showDateRangeBottomSheet(context),
                          child: Text('기간 선택'),
                        ),
                        ElevatedButton(
                          onPressed: () => _showSortOrderBottomSheet(context),
                          child: Text('정렬 순서'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        child: ListView.builder(
                          itemCount: _filteredGroupHistoryList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.Gray850,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                width: 232,
                                height: 90,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.network(
                                              'https://picsum.photos/seed/279/600',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 13),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _filteredGroupHistoryList[index].firstName + _filteredGroupHistoryList[index].lastName,
                                                  style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                                                ),
                                                Text(_filteredGroupHistoryList[index].shortDescription,
                                                    style: AppFont.r16.overrides(fontSize: 12, color: AppColors.primaryBackground)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            timeElapsedSince(_filteredGroupHistoryList[index].date),
                                            //timeElapsedSince('2024-01-27 21:21:51'),

                                            style: AppFont.r16.overrides(fontSize: 10, color: AppColors.Gray200),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
