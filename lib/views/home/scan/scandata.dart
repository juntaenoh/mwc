import 'package:mwc/models/FootData.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:mwc/utils/TypeManager.dart';
import 'package:mwc/views/home/home_page/unity_widget.dart';
import 'package:mwc/views/home/scan/switch.dart';
import 'package:flutter/material.dart';
import 'package:mwc/index.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ScanData extends StatefulWidget {
  final String mode;
  final Map<String, dynamic> footdata;
  const ScanData({Key? key, required this.mode, required this.footdata}) : super(key: key);
  @override
  _ScanDataState createState() => _ScanDataState();
}

class _ScanDataState extends State<ScanData> {
  var data;
  List<ClassType> classTypes = [];
  List<Item> filteredItems = [];
  bool _showWidget = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showWidget = true;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  bool _isDescriptionShown = false;
  bool _isDescriptionShown2 = false;

  bool _isDescriptionShown3 = false;
  int selectedIndex = 0; // 선택된 항목 인덱스

  void _toggleDescription() {
    setState(() {
      _isDescriptionShown = !_isDescriptionShown;
    });
  }

  void _toggleDescription2() {
    setState(() {
      _isDescriptionShown2 = !_isDescriptionShown2;
    });
  }

  void _toggleDescription3() {
    setState(() {
      _isDescriptionShown3 = !_isDescriptionShown3;
    });
  }

  Future<void> _loadUnityWidget() async {
    await Future.delayed(Duration(seconds: 2));
  }

  String gs(String code) {
    return SetLocalizations.of(context).getText(code);
  }

  // 테이블 헤더 셀
  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: AppFont.s12.overrides(fontSize: 16, color: AppColors.primaryBackground)),
    );
  }

  // 테이블 데이터 행 생성 함수
  TableRow _buildTableRow(String category, double? angle) {
    String direction = angle == null ? '-' : (angle.isNegative ? 'Right' : 'Left');
    String value = angle != null ? angle.abs().toStringAsFixed(2) : '-';
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      children: [
        _buildTableCell(category),
        _buildTableCell(direction),
        _buildTableCell(value),
      ],
    );
  }

  // 각 셀 데이터
  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: AppFont.s12.overrides(fontSize: 16)),
    );
  }

  final converter = CmToFeetInchConverter();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> typeLabels = [
      'footprintTypeLabel0',
      'footprintTypeLabel1',
      'footprintTypeLabel2',
      'footprintTypeLabel3',
      'footprintTypeLabel4',
      'footprintTypeLabel5',
      'footprintTypeLabel6',
      'footprintTypeLabel7',
      'footprintTypeLabel8',
    ];

    final List<String> typeTitles = [
      'footprintTitle0',
      'footprintTitle1',
      'footprintTitle2',
      'footprintTitle3',
      'footprintTitle4',
      'footprintTitle5',
      'footprintTitle6',
      'footprintTitle7',
      'footprintTitle8',
    ];

    final List<String> typeScripts = [
      'footprintScript0',
      'footprintScript1',
      'footprintScript2',
      'footprintScript3',
      'footprintScript4',
      'footprintScript5',
      'footprintScript6',
      'footprintScript7',
      'footprintScript8',
    ];

    classTypes = [
      ClassType(
        type: 1,
        items: [
          Item(title: gs('PossibleConditions1a'), description: gs('PossibleConditionsScript1a')),
          Item(title: gs('PossibleConditions1b'), description: gs('PossibleConditionsScript1b')),
          Item(title: gs('PossibleConditions1c'), description: gs('PossibleConditionsScript1c')),
          Item(title: gs('PossibleConditions1d'), description: gs('PossibleConditionsScript1d')),
          Item(title: gs('PossibleConditions1e'), description: gs('PossibleConditionsScript1e')),
        ],
      ),
      ClassType(
        type: 2,
        items: [
          Item(title: gs('PossibleConditions2a'), description: gs('PossibleConditionsScript2a')),
          Item(title: gs('PossibleConditions2b'), description: gs('PossibleConditionsScript2b')),
          Item(title: gs('PossibleConditions2c'), description: gs('PossibleConditionsScript2c')),
          Item(title: gs('PossibleConditions2d'), description: gs('PossibleConditionsScript2d')),
          Item(title: gs('PossibleConditions2e'), description: gs('PossibleConditionsScript2e')),
        ],
      ),
      ClassType(
        type: 3,
        items: [
          Item(title: gs('PossibleConditions3a'), description: gs('PossibleConditionsScript3a')),
          Item(title: gs('PossibleConditions3b'), description: gs('PossibleConditionsScript3b')),
          Item(title: gs('PossibleConditions3c'), description: gs('PossibleConditionsScript3c')),
          Item(title: gs('PossibleConditions3d'), description: gs('PossibleConditionsScript3d')),
          Item(title: gs('PossibleConditions3e'), description: gs('PossibleConditionsScript3e')),
        ],
      ),
      ClassType(
        type: 4,
        items: [
          Item(title: gs('PossibleConditions4a'), description: gs('PossibleConditionsScript4a')),
          Item(title: gs('PossibleConditions4b'), description: gs('PossibleConditionsScript4b')),
          Item(title: gs('PossibleConditions4c'), description: gs('PossibleConditionsScript4c')),
          Item(title: gs('PossibleConditions4d'), description: gs('PossibleConditionsScript4d')),
          Item(title: gs('PossibleConditions4e'), description: gs('PossibleConditionsScript4e')),
        ],
      ),
      ClassType(
        type: 5,
        items: [
          Item(title: gs('PossibleConditions5a'), description: gs('PossibleConditionsScript5a')),
          Item(title: gs('PossibleConditions5b'), description: gs('PossibleConditionsScript5b')),
          Item(title: gs('PossibleConditions5c'), description: gs('PossibleConditionsScript5c')),
          Item(title: gs('PossibleConditions5d'), description: gs('PossibleConditionsScript5d')),
        ],
      ),
      ClassType(
        type: 6,
        items: [
          Item(title: gs('PossibleConditions5a'), description: gs('PossibleConditionsScript5a')),
          Item(title: gs('PossibleConditions5b'), description: gs('PossibleConditionsScript5b')),
          Item(title: gs('PossibleConditions5c'), description: gs('PossibleConditionsScript5c')),
          Item(title: gs('PossibleConditions5d'), description: gs('PossibleConditionsScript5d')),
        ],
      ),
      ClassType(
        type: 7,
        items: [
          Item(title: gs('PossibleConditions6a'), description: gs('PossibleConditionsScript6a')),
          Item(title: gs('PossibleConditions6b'), description: gs('PossibleConditionsScript6b')),
          Item(title: gs('PossibleConditions6c'), description: gs('PossibleConditionsScript6c')),
          Item(title: gs('PossibleConditions6d'), description: gs('PossibleConditionsScript6d')),
          Item(title: gs('PossibleConditions6e'), description: gs('PossibleConditionsScript6e')),
        ],
      ),
    ];

    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.4, // 처음 표시될 때의 크기
          minChildSize: 0.4, // 최소 크기
          maxChildSize: 1, // 최대 크기
          builder: (BuildContext context, ScrollController scrollController) {
            return Consumer<AppStateNotifier>(builder: (context, AppStateNotifier, child) {
              final result = converter.convertCmToFeetInches(AppStateNotifier.testUser?.height ?? 180);

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 10, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: AppColors.Gray850,
                              height: 2,
                              width: 40,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Container(width: 60, height: 4)],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 20),
                          child: Text(
                            "${widget.footdata['measuredDate']} Overall analysis results",
                            style: AppFont.b24.overrides(fontSize: 20),
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: AppColors.Gray100,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Divider(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    SetLocalizations.of(context).getText('homeUserHeightLabel'),
                                                    style: AppFont.s12,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    child: Text(
                                                      AppStateNotifier.iscm
                                                          ? (AppStateNotifier.testUser?.height.toString() ?? '180') + 'cm'
                                                          : ('${result['feet']} feet ${result['inches']} inch'),
                                                      style: AppFont.b24.overrides(fontSize: 20),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    SetLocalizations.of(context).getText('reportPlantarPressureDetailWeightLabel'),
                                                    style: AppFont.s12,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 12),
                                                    child: AppStateNotifier.iskg
                                                        ? Text(
                                                            (widget.footdata['weight']?.toString() ?? 'na') + 'kg',
                                                            style: AppFont.b24.overrides(fontSize: 20),
                                                          )
                                                        : Text(
                                                            widget.footdata['weight'] != null
                                                                ? (double.parse(widget.footdata['weight'].toString()) * 2.20462).toStringAsFixed(2) +
                                                                    ' lbs'
                                                                : 'na',
                                                            style: AppFont.b24.overrides(fontSize: 20),
                                                          ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 20),
                          child: Text(
                            widget.footdata['firstClassType'] != 0
                                ? SetLocalizations.of(context).getText('reportPlantarPressureDetailPainLabel' /* 이린 부외  */)
                                : SetLocalizations.of(context).getText('reportPlantarPressureNomalLabel' /* 이린 부외  */),
                            style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Black),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ToggleImageSwitch(footdata: widget.footdata, selectedIndex: selectedIndex),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.Black,
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: List.generate(4, (index) {
                                  return Expanded(
                                    flex: selectedIndex == index ? 1 : 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            color: selectedIndex == index ? AppColors.primaryBackground : AppColors.Gray700,
                                            borderRadius: BorderRadius.circular(32),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                                              child: Text(
                                                index == 0 ? "Highlight" : "$index",
                                                style: AppFont.s12.overrides(
                                                  color: selectedIndex == index ? AppColors.Black : AppColors.Gray300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Your plantar pressure\nanalysis results\nThe top three types.',
                          style: AppFont.b24.overrides(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.Gray200,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20), // 왼쪽 상단 둥글게
                                topRight: Radius.circular(20), // 오른쪽 상단 둥글게
                                bottomLeft: Radius.circular(0), // 왼쪽 하단은 직각
                                bottomRight: Radius.circular(0), // 오른쪽 하단은 직각
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Primary Type'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        SetLocalizations.of(context).getText(typeLabels[widget.footdata['firstClassType'].toInt()]),
                                        style: AppFont.b24.overrides(fontSize: 20),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _isDescriptionShown ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.Black,
                                        ),
                                        onPressed: _toggleDescription,
                                      ),
                                    ],
                                  ),
                                  if (_isDescriptionShown) ...[
                                    Divider(color: AppColors.primaryBackground),
                                    Text('Accuracy', style: AppFont.s12.overrides(color: AppColors.Gray700)),
                                    Text('${widget.footdata['firstAccuracy']}%', style: AppFont.b24.overrides(fontSize: 20)),
                                    Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        SetLocalizations.of(context).getText(typeScripts[widget.footdata['firstClassType'].toInt()]),
                                        style: TextStyle(color: AppColors.Gray700),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.Gray100,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Secondary type'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      SetLocalizations.of(context).getText(typeLabels[widget.footdata['secondaryClassType'].toInt()]),
                                      style: AppFont.b24.overrides(fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _isDescriptionShown2 ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.Black,
                                      ),
                                      onPressed: _toggleDescription2,
                                    ),
                                  ],
                                ),
                                if (_isDescriptionShown2) ...[
                                  Divider(color: AppColors.primaryBackground),
                                  Text('Accuracy', style: AppFont.s12.overrides(color: AppColors.Gray700)),
                                  Text('${widget.footdata['secondaryAccuracy']}%', style: AppFont.b24.overrides(fontSize: 20)),
                                  Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      SetLocalizations.of(context).getText(typeScripts[widget.footdata['secondaryClassType'].toInt()]),
                                      style: TextStyle(color: AppColors.Gray700),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(243, 244, 246, 1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0), // 왼쪽 상단 둥글게
                              topRight: Radius.circular(0), // 오른쪽 상단 둥글게
                              bottomLeft: Radius.circular(20), // 왼쪽 하단은 직각
                              bottomRight: Radius.circular(20), // 오른쪽 하단은 직각
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tertiary Type'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      SetLocalizations.of(context).getText(typeLabels[widget.footdata['thirdClassType'].toInt()]),
                                      style: AppFont.b24.overrides(fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _isDescriptionShown3 ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                        color: AppColors.Black,
                                      ),
                                      onPressed: _toggleDescription3,
                                    ),
                                  ],
                                ),
                                if (_isDescriptionShown3) ...[
                                  Divider(color: AppColors.primaryBackground),
                                  Text('Accuracy', style: AppFont.s12.overrides(color: AppColors.Gray700)),
                                  Text('${widget.footdata['thirdAccuracy']}%', style: AppFont.b24.overrides(fontSize: 20)),
                                  Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      SetLocalizations.of(context).getText(typeScripts[widget.footdata['thirdClassType'].toInt()]),
                                      style: TextStyle(color: AppColors.Gray700),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 20),
                          child: Text(
                            SetLocalizations.of(context).getText('reportPlantarPressureDetailSymptomLabel' /* 이린 부외  */),
                            style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Black),
                          ),
                        ),
                        if (widget.footdata['firstClassType'] != 0) ...[
                          _buildPossibleConditions(context, widget.footdata['firstClassType'].toInt()),
                        ],
                        if (widget.footdata['firstClassType'] == 0) ...[
                          _buildPossibleConditions(context, widget.footdata['secondaryClassType'].toInt()),
                        ],

                        if (AppStateNotifier.visiondata != null || AppStateNotifier.visiondata?['imageUrl'] != null) ...[
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 20),
                            child: Text(
                              'We analyzed your posture\nwith Fisica AI',
                              style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Black),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Image(image: NetworkImage(AppStateNotifier.visiondata!['imageUrl'])),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                            child: Text(
                              'Vision analysis is a method used to assess the degree of imbalance in body posture by analyzing factors such as head tilt, shoulder height differences, and pelvic misalignment. The greater the variance in these measurements, the more imbalanced the posture, which can lead to pain in areas like the neck, shoulders, and lower back if left uncorrected.',
                              style: AppFont.r16.overrides(color: AppColors.Black),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white, // 전체 테이블 배경
                              borderRadius: BorderRadius.circular(12), // 모서리 둥글게
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // 그림자 위치
                                ),
                              ],
                            ),
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(2), // Category 컬럼 넓이
                                1: FlexColumnWidth(2), // Direction 컬럼 넓이
                                2: FlexColumnWidth(1), // Value 컬럼 넓이
                              },
                              border: TableBorder(
                                horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
                              ), // 행 사이에 구분선
                              children: [
                                // 헤더 행
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                  children: [
                                    _buildTableHeaderCell('Category'),
                                    _buildTableHeaderCell('Direction'),
                                    _buildTableHeaderCell('Value'),
                                  ],
                                ),
                                // 데이터 행 1
                                _buildTableRow('Front/ Face', AppStateNotifier.visiondata?['angleFace']),
                                _buildTableRow('Front/ Shoulder', AppStateNotifier.visiondata?['angleShoulder']),
                                _buildTableRow('Front/ Pelvis', AppStateNotifier.visiondata?['anglePelvis']),
                              ],
                            ),
                          ),
                        ],
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 80, 0, 20),
                          child: Text(
                            'Your avatar was created\nbased on the analyzed content!',
                            style: AppFont.b24.overrides(fontSize: 20, color: AppColors.Black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Text(
                            'The current avatar is a default form that is loaded based on your primary plantar pressure type and does not reflect your body type. As Fisica continues to evolve, we plan to create a perfect digital-twin avatar that fully reflects your body type. ',
                            style: AppFont.r16.overrides(color: AppColors.Black),
                          ),
                        ),
                        _showWidget
                            ? FutureBuilder<void>(
                                future: _loadUnityWidget(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error loading Unity Widget');
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Container(
                                        height: 480,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                        child: UnityWidgetWrapper(
                                          height: 380,
                                          type: widget.footdata['firstClassType'].toInt(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : CircularProgressIndicator(),
                        Container(
                          height: 40,
                        ),
                        // Container(
                        //   width: 327,
                        //   height: 56.0,
                        //   child: LodingButtonWidget(
                        //     onPressed: () async {
                        //       showCustomDialog(
                        //         context: context,
                        //         backGroundtype: 'black',
                        //         checkButtonColor: AppColors.DarkenGreen,
                        //         titleText: 'Schedule send E-mail',
                        //         descriptionText: 'It is scheduled to be sent\nin batches around November',
                        //         upperButtonText: 'Exit',
                        //         upperButtonFunction: () async {
                        //           Navigator.pop(context);
                        //         },
                        //       );
                        //     },
                        //     text: 'Send Report to E-mail',
                        //     options: LodingButtonOptions(
                        //       height: 40.0,
                        //       padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        //       iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        //       color: AppColors.Black,
                        //       textStyle: AppFont.s18.overrides(
                        //         fontSize: 16,
                        //         color: AppColors.primaryBackground,
                        //       ),
                        //       elevation: 0,
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
        //   if (widget.mode != 'histroy')
        //     Positioned(
        //       right: 20,
        //       bottom: 60,
        //       child: Container(
        //         width: 327,
        //         height: 56.0,
        //         decoration: BoxDecoration(
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.white.withOpacity(1), // 흰색 그림자, 투명도 조절 가능
        //               spreadRadius: 82, // 그림자의 범위를 넓힘
        //               blurRadius: 15, // 그림자의 흐릿함 정도
        //               offset: Offset(0, 50), // 그림자의 방향 (x, y)
        //             ),
        //           ],
        //         ),
        //         child: LodingButtonWidget(
        //           onPressed: () async {
        //             //context.goNamed('Footprint', extra: 'test');
        //           },
        //           text: 'Send Report to E-mail',
        //           options: LodingButtonOptions(
        //             height: 40.0,
        //             padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
        //             iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        //             color: AppColors.Black,
        //             textStyle: AppFont.s18.overrides(
        //               fontSize: 16,
        //               color: AppColors.primaryBackground,
        //             ),
        //             elevation: 0,
        //             borderRadius: BorderRadius.circular(8.0),
        //           ),
        //         ),
        //       ),
        //     ),
      ],
    );
  }

  Widget _buildPossibleConditions(BuildContext context, int type) {
    if (type != 0) {
      filteredItems = classTypes.firstWhere((classType) => classType.type == type).items;
    }
    return Container(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];

            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: AppColors.Gray100, borderRadius: BorderRadius.all(Radius.circular(16))),
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppFont.s18.overrides(color: AppColors.Black),
                        ),
                        Divider(
                          color: AppColors.primaryBackground,
                        ),
                        Container(
                          child: Text(
                            item.description,
                            style: AppFont.r16.overrides(color: AppColors.Gray500, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                )
              ],
            );
          },
        ));
  }
}

class ClassType {
  final int type;
  final List<Item> items;

  ClassType({required this.type, required this.items});
}

class Item {
  final String title;
  final String description;

  Item({required this.title, required this.description});
}

class CmToFeetInchConverter {
  /// Converts centimeters to feet and inches
  Map<String, int> convertCmToFeetInches(double cm) {
    const double cmPerFoot = 30.48;
    const double cmPerInch = 2.54;

    // Calculate total feet (floating point)
    double totalFeet = cm / cmPerFoot;

    // Extract feet (integer part)
    int feet = totalFeet.floor();

    // Calculate remaining centimeters and convert to inches
    double remainingCm = (totalFeet - feet) * cmPerFoot;
    int inches = (remainingCm / cmPerInch).round();

    // Handle case where inches == 12 (carry over to feet)
    if (inches == 12) {
      feet += 1;
      inches = 0;
    }

    return {"feet": feet, "inches": inches};
  }
}
