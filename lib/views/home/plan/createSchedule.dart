import 'package:mwc/utils/fisica_theme.dart';
import 'package:mwc/utils/form_field_controller.dart';
import 'package:mwc/utils/internationalization.dart';
import 'package:mwc/views/home/plan/plan_components/calendar_Range.dart';
import 'package:mwc/views/home/plan/plan_components/checkbox.dart';
import 'package:mwc/widgets/Loding_button_widget.dart';
import 'package:mwc/widgets/flutter_drop_down.dart';
import 'package:flutter/material.dart';

class AddSchedulePage extends StatefulWidget {
  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _memoController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 0, minute: 0);
  String repeat = '반복 없음';
  String repeatPeriod = '없음';
  String location = '미등록';
  String notification = '정각 알림';
  String measurementType = '측정안 분석';
  String _formattedDateRange = '반복 기간';
  Set<String> selectedOptions = {};

  int doseCount = 3;
  List<TimeOfDay> doseTimes = [
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 0, minute: 0),
    TimeOfDay(hour: 0, minute: 0)
  ];

  void _selectDate() async {}

  // void _selectTime(int index) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: doseTimes[index],
  //   );
  //   if (picked != null && picked != doseTimes[index]) {
  //     setState(() {
  //       doseTimes[index] = picked;
  //     });
  //   }
  // }

  void _showDateRangePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.Gray850, // 바텀 시트 배경색을 설정
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 570, // 높이를 570으로 고정
          child: CustomCalendarRange(
            timeData: [], // 필요한 날짜 데이터를 여기에 추가하세요.
            onDateRangeSelected: (startDate, endDate) {
              setState(() {
                _formattedDateRange = _formatDateRange(startDate, endDate);
              });
            },
          ),
        );
      },
    );
  }

  String _formatDateRange(DateTime startDate, DateTime endDate) {
    return '${startDate.year}.${startDate.month}.${startDate.day}~${endDate.year}.${endDate.month}.${endDate.day}';
  }

  void _selectTime(int index) async {}

  void _showBottomSheet(List<String> options, String selected, Function(String) onSelected) {
    showModalBottomSheet(
      backgroundColor: AppColors.primaryBackground,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...options.map((option) => RadioListTile<String>(
                      title: Text(
                        (option), // 옵션 텍스트
                        style: AppFont.s18.overrides(color: AppColors.Black),
                      ),
                      value: option,
                      groupValue: selected,
                      onChanged: (value) {
                        onSelected(value!);
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    child: LodingButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: SetLocalizations.of(context).getText(
                        'goeidkfwk' /* 해당일자 선택 */,
                      ),
                      options: LodingButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: AppColors.Black,
                        textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
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
          ),
        );
      },
    );
  }

  void _showRepeatBottomSheet(List<String> options, Set<String> selectedOptions, Function(Set<String>) onSelected) {
    showModalBottomSheet(
      backgroundColor: AppColors.primaryBackground,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(options[0], style: AppFont.s18),
                        Theme(
                          data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                //fillColor:
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              unselectedWidgetColor: AppColors.Gray200),
                          child: Checkbox(
                            value: selectedOptions.isEmpty,
                            onChanged: (bool? value) {
                              if (value == true) {
                                setState(() {
                                  selectedOptions.clear();
                                });
                                onSelected(Set.from(selectedOptions));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    CustomCheckbox(
                      value: selectedOptions.length == options.length - 2,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedOptions.addAll(options.sublist(2));
                          } else {
                            selectedOptions.clear();
                          }
                        });
                        onSelected(Set.from(selectedOptions));
                      },
                      title: options[1], // "매일"
                    ),
                    ...options.sublist(2).map((option) {
                      return CustomCheckbox(
                        value: selectedOptions.contains(option),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedOptions.add(option);
                            } else {
                              selectedOptions.remove(option);
                            }
                          });
                          onSelected(Set.from(selectedOptions));
                        },
                        title: option,
                      );
                    }).toList(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        child: LodingButtonWidget(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: SetLocalizations.of(context).getText(
                            'goeidkfwk' /* 해당일자 선택 */,
                          ),
                          options: LodingButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: AppColors.Black,
                            textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildForm() {
    switch (dropDownValue) {
      case '약복용':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('복용약', _titleController, 'textholder'),
            SizedBox(height: 16),
            _buildDateField(),
            _peel(),
            _buildRepeatField(),
            _buildRepeatPeriodField(),
            _buildNotificationField(),
            _buildSubmitButton(),
          ],
        );
      case '운동':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('일정명', _titleController, 'textholder'),
            SizedBox(height: 16),
            _buildDateField(),
            _buildTimeFields(),
            _buildRepeatField(),
            _buildRepeatPeriodField(),
            _buildLocationField(),
            _buildNotificationField(),
            _buildSubmitButton(),
          ],
        );
      case '측정하기':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('측정명', _titleController, 'textholder'),
            SizedBox(height: 16),
            _buildDropdownField('측정종류', measurementType, ['측정안 분석', '체중', 'Vision 분석', '기타'], (value) {
              setState(() {
                measurementType = value;
              });
            }),
            _buildDateField(),
            _buildTimeFields(),
            _buildRepeatField(),
            _buildRepeatPeriodField(),
            _buildNotificationField(),
            _buildMemoField(),
            _buildSubmitButton(),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('일정명', _titleController, 'textholder'),
            SizedBox(height: 16),
            _buildDateField(),
            _buildTimeFields(),
            _buildRepeatField(),
            _buildRepeatPeriodField(),
            _buildLocationField(),
            _buildNotificationField(),
            _buildSubmitButton(),
          ],
        );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFont.s12.overrides(color: AppColors.Gray700)),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          onChanged: (String? newValue) {
            onChanged(newValue!);
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.day.toString().padLeft(2, '0')}'),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _peel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('일일 복용 횟수'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (doseCount > 1) doseCount--;
                        });
                      },
                    ),
                    Text('$doseCount'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          doseCount++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          '복용 시간',
          style: AppFont.s18.overrides(color: AppColors.Black, fontSize: 16),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: List.generate(doseCount, (i) {
              return GestureDetector(
                onTap: () => _selectTime(i),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${doseTimes[i].format(context)}',
                            style: AppFont.s18.overrides(color: AppColors.Black, fontSize: 16),
                          ),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                    if (i != doseCount - 1) // 마지막 항목이 아닌 경우에만 Divider 추가
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      ),
                  ],
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  Widget _buildTimeFields() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate,
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    startTime.format(context),
                    style: AppFont.s18.overrides(color: AppColors.Black, fontSize: 16),
                  ),
                  Icon(Icons.access_time),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate,
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    endTime.format(context),
                    style: AppFont.s18.overrides(color: AppColors.Black, fontSize: 16),
                  ),
                  Icon(Icons.access_time),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatField() {
    return GestureDetector(
      onTap: () {
        _showRepeatBottomSheet(
          ['반복 없음', '매일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
          selectedOptions,
          (value) {
            setState(() {
              selectedOptions = value;
            });
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedOptions.isEmpty ? '반복 없음' : selectedOptions.join(', '),
                style: AppFont.s18.overrides(color: AppColors.Black, fontSize: 16),
                overflow: TextOverflow.ellipsis, // 긴 텍스트가 있을 경우 생략 표시
              ),
            ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatPeriodField() {
    return GestureDetector(
      onTap: () {
        _showDateRangePicker(context);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formattedDateRange,
              style: AppFont.s18.overrides(color: AppColors.Black, fontSize: 16),
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationField() {
    return GestureDetector(
      onTap: () {
        _showBottomSheet(
          ['정각 알림', '10분 전 알림', '30분 전 알림', '1시간 전 알림'],
          notification,
          (value) {
            setState(() {
              notification = value;
            });
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (notification), // 선택된 알림 텍스트 표시
              style: AppFont.s18.overrides(color: AppColors.primaryBackground),
            ),
            Icon(Icons.notifications),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ('메모'), // 메모
          style: AppFont.s18.overrides(color: AppColors.primaryBackground),
        ),
        TextField(
          controller: _memoController,
          decoration: InputDecoration(
            hintText: ('메모를 입력하세요'), // 메모를 입력하세요
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // 등록하기 로직
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48),
      ),
      child: Text(
        ('등록하기'), // 등록하기
        style: AppFont.s18.overrides(color: AppColors.primaryBackground),
      ),
    );
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: () {
        // 위치 선택 로직을 여기에 추가합니다.
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (location), // 미등록
              style: AppFont.s18.overrides(color: AppColors.primaryBackground),
            ),
            Icon(Icons.location_on),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 등록'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '종류', // 종류
              style: AppFont.s12.overrides(color: AppColors.Black),
            ),
            SizedBox(height: 8),
            FlutterDropDown<String>(
              controller: dropDownValueController ??= FormFieldController<String>(null),
              options: ['운동', '약복용', '병원', '측정하기', '기타'],
              onChanged: (value) async {
                print('value  = $value');
                setState(() {
                  dropDownValue = value!;
                  print(dropDownValue);
                });
              },
              width: double.infinity,
              height: 38.0,
              textStyle: AppFont.r16.overrides(color: AppColors.Gray500),
              elevation: 2,
              borderColor: AppColors.Gray200,
              borderWidth: 1.0,
              borderRadius: 8.0,
              borderStyle: 'all',
              margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
              hidesUnderline: true,
              isSearchable: false,
              isMultiSelect: false,
              hintText: '종류',
            ),
            SizedBox(height: 16),
            _buildForm(),
          ],
        ),
      ),
    );
  }
}
