import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:mwc/index.dart';

class TesterData1 extends StatefulWidget {
  const TesterData1({Key? key}) : super(key: key);

  @override
  _TesterData1State createState() => _TesterData1State();
}

class _TesterData1State extends State<TesterData1> {
  String selectedDate = '';
  String selectedGender = 'none';
  bool isNone = false;

  final TextEditingController fiController = TextEditingController();
  final fiFocusNode = FocusNode();

  final TextEditingController namController = TextEditingController();
  final namFocusNode = FocusNode();

  final TextEditingController biController = TextEditingController();
  final biFocusNode = FocusNode();

  final TextEditingController heController = TextEditingController();
  final heFocusNode = FocusNode();
  final TextEditingController heController2 = TextEditingController();
  final heFocusNode2 = FocusNode();

  final TextEditingController weController = TextEditingController();
  final weFocusNode = FocusNode();

  final TextEditingController haController = TextEditingController();
  final haFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final TextEditingController addressController = TextEditingController();
  final addressFocusNode = FocusNode();

  final TextEditingController detailAddressController = TextEditingController();
  final detailAddressFocusNode = FocusNode();
  bool _iscm = true;
  List<bool> _isSelected = [true, false];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _toggleNone() {
    setState(() {
      if (isNone) {
        haController.text = '';
      } else {
        haController.text = 'none';
      }
      isNone = !isNone;
    });
  }

  bool get areFieldsValid {
    return (biController.text.isNotEmpty) && selectedGender != 'none' && heController.text.isNotEmpty;
  }

  bool get areFieldsValidit {
    return fiController.text.isNotEmpty &&
        namController.text.isNotEmpty &&
        (selectedDate != '') &&
        selectedGender != 'none' &&
        haController.text.isNotEmpty;
  }

  List<int> years = List.generate(2024 - 1800 + 1, (index) => 1800 + index);

  @override
  void dispose() {
    fiFocusNode.dispose();
    fiController.dispose();

    namFocusNode.dispose();
    namController.dispose();

    biFocusNode.dispose();
    biController.dispose();

    heFocusNode.dispose();
    heController.dispose();
    heFocusNode2.dispose();
    heController2.dispose();

    weFocusNode.dispose();
    weController.dispose();

    haFocusNode.dispose();
    haController.dispose();

    emailFocusNode.dispose();
    emailController.dispose();

    addressFocusNode.dispose();
    addressController.dispose();

    detailAddressFocusNode.dispose();
    detailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onVerticalDragStart: (details) => FocusScope.of(context).unfocus(), // 수직 드래그 종료 시 키보드 숨김
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0x00CCFF8B),
          automaticallyImplyLeading: false,
          leading: AppIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Text('Enter experiencer information', style: AppFont.s18.overrides(color: AppColors.Black)),
              ),
              Text(
                'The upper right red dot is a required input',
                style: AppFont.s12.overrides(color: AppColors.Gray300, fontSize: 12),
              )
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Row(
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: [
                        //     Expanded(
                        //       child: Padding(
                        //         padding: EdgeInsetsDirectional.fromSTEB(0, 20, 8, 0),
                        //         child: TextFormField(
                        //           controller: fiController,
                        //           focusNode: fiFocusNode,
                        //           autofocus: false,
                        //           obscureText: false,
                        //           decoration: InputDecoration(
                        //             label: Row(
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Text(
                        //                   SetLocalizations.of(context).getText(
                        //                     'signupUserInfoInputLastNameLabel' /*성 */,
                        //                   ),
                        //                   style: AppFont.s12.overrides(color: AppColors.Black),
                        //                 ),
                        //                 Container(
                        //                   height: 6, // Height of the dot
                        //                   width: 6, // Width of the dot
                        //                   decoration: BoxDecoration(
                        //                     shape: BoxShape.circle,
                        //                     color: AppColors.red, // Color of the dot
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             labelStyle: AppFont.s12.overrides(color: AppColors.Black),
                        //             hintStyle: AppFont.s12,
                        //             enabledBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //             focusedBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //             errorBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //             focusedErrorBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //           ),
                        //           style: AppFont.s12,
                        //           validator: (value) {
                        //             if (value == null || value.isEmpty) {
                        //               return 'Field cannot be empty';
                        //             }
                        //             bool isKorean = RegExp(r"[\uac00-\ud7af]").hasMatch(value);
                        //             bool isJapanese = RegExp(r"[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9faf]").hasMatch(value);
                        //             if (isKorean && value.length > 2) {
                        //               return '한글은 2자 이하로 입력해주세요';
                        //             } else if (isJapanese && value.length > 20) {
                        //               return '日本語は20文字以内で入力してください';
                        //             } else if (!isKorean && !isJapanese && value.length > 12) {
                        //               return '영어는 12자 이하로 입력해주세요';
                        //             }
                        //             return null; // null means input is valid
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Padding(
                        //         padding: EdgeInsetsDirectional.fromSTEB(8, 20, 0, 0),
                        //         child: TextFormField(
                        //           controller: namController,
                        //           focusNode: namFocusNode,
                        //           autofocus: false,
                        //           obscureText: false,
                        //           decoration: InputDecoration(
                        //             label: Row(
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Text(
                        //                   SetLocalizations.of(context).getText(
                        //                     'signupUserInfoInputFirstNameLabel' /* Label here... */,
                        //                   ),
                        //                   style: AppFont.s12.overrides(color: AppColors.Black),
                        //                 ),
                        //                 Container(
                        //                   height: 6, // Height of the dot
                        //                   width: 6, // Width of the dot
                        //                   decoration: BoxDecoration(
                        //                     shape: BoxShape.circle,
                        //                     color: AppColors.red, // Color of the dot
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             hintStyle: AppFont.s12,
                        //             enabledBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //             focusedBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //             errorBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //             focusedErrorBorder: UnderlineInputBorder(
                        //               borderSide: BorderSide(
                        //                 color: AppColors.Gray200,
                        //                 width: 1,
                        //               ),
                        //             ),
                        //           ),
                        //           style: AppFont.s12,
                        //           validator: (value) {
                        //             if (value == null || value.isEmpty) {
                        //               return 'Field cannot be empty';
                        //             }
                        //             bool isKorean = RegExp(r"[\uac00-\ud7af]").hasMatch(value);
                        //             bool isJapanese = RegExp(r"[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9faf]").hasMatch(value);
                        //             if (isKorean && value.length > 15) {
                        //               return '한글은 15자 이하로 입력해주세요';
                        //             } else if (isJapanese && value.length > 20) {
                        //               return '日本語は20文字以内で入力してください';
                        //             } else if (!isKorean && !isJapanese && value.length > 20) {
                        //               return '영어는 20자 이하로 입력해주세요';
                        //             }
                        //             return null; // null means input is valid
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Year of birth',
                                          style: AppFont.s12.overrides(color: AppColors.Black),
                                        ),
                                        Container(
                                          height: 6, // Height of the dot
                                          width: 6, // Width of the dot
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.red, // Color of the dot
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      controller: biController,
                                      focusNode: biFocusNode,
                                      autofocus: false,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                          hintStyle: AppFont.s12,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          hintText: "yyyy"),
                                      keyboardType: TextInputType.number,
                                      style: AppFont.r16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 32, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gender',
                                style: AppFont.s12.overrides(color: AppColors.Black),
                              ),
                              Container(
                                height: 6, // Height of the dot
                                width: 6, // Width of the dot
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.red, // Color of the dot
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: LodingButtonWidget(
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = 'male';
                                    });
                                  },
                                  text: 'Man',
                                  options: LodingButtonOptions(
                                    height: 40,
                                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                    color: selectedGender == 'male' ? Colors.black : AppColors.primaryBackground,
                                    textStyle: AppFont.s12.overrides(color: selectedGender == 'male' ? Colors.white : AppColors.Gray300),
                                    elevation: 0,
                                    borderSide: BorderSide(
                                      color: AppColors.Gray300,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: LodingButtonWidget(
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = 'female';
                                    });
                                  },
                                  text: 'Woman',
                                  options: LodingButtonOptions(
                                    height: 40,
                                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                    color: selectedGender == 'female' ? Colors.black : AppColors.primaryBackground,
                                    textStyle: AppFont.s12.overrides(color: selectedGender == 'female' ? Colors.white : AppColors.Gray300),
                                    elevation: 0,
                                    borderSide: BorderSide(
                                      color: AppColors.Gray300,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: LodingButtonWidget(
                                  onPressed: () {
                                    setState(() {
                                      selectedGender = 'other';
                                    });
                                  },
                                  text: 'Others',
                                  options: LodingButtonOptions(
                                    height: 40,
                                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                    color: selectedGender == 'other' ? Colors.black : AppColors.primaryBackground,
                                    textStyle: AppFont.s12.overrides(color: selectedGender == 'other' ? Colors.white : AppColors.Gray300),
                                    elevation: 0,
                                    borderSide: BorderSide(
                                      color: AppColors.Gray300,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 8, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Height',
                                      style: AppFont.s12.overrides(color: AppColors.Black),
                                    ),
                                    Container(
                                      height: 6, // Height of the dot
                                      width: 6, // Width of the dot
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.red, // Color of the dot
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8), // 간격 추가
                              Container(
                                width: double.infinity,
                                child: ToggleButtons(
                                  isSelected: _isSelected,
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int i = 0; i < _isSelected.length; i++) {
                                        _isSelected[i] = i == index;
                                        _iscm = _isSelected[0];
                                        AppStateNotifier.instance.unitiscm(_iscm);
                                      }
                                    });
                                  },
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Text('Cm'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Text('Inch'),
                                    ),
                                  ],
                                  // 선택된 버튼의 스타일

                                  selectedColor: Colors.white,
                                  fillColor: Colors.black,
                                  borderRadius: BorderRadius.circular(24.0),
                                  // 버튼에 테두리 색 설정 (옵션)
                                  borderColor: Colors.black,
                                  selectedBorderColor: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              // 두 번째 Row: 입력 필드 및 단위 변경 버튼
                              Row(
                                children: [
                                  // Cm 입력 필드 (if _iscm)
                                  if (_iscm)
                                    Expanded(
                                      child: TextFormField(
                                        controller: heController,
                                        focusNode: heFocusNode,
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintStyle: AppFont.s12,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColors.Gray200,
                                              width: 1,
                                            ),
                                          ),
                                          suffix: Text(
                                            'Cm',
                                            style: AppFont.r16.overrides(color: AppColors.Gray200),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        style: AppFont.r16,
                                      ),
                                    )
                                  // Feet/Inch 입력 필드 (if !_iscm)
                                  else if (!_iscm)
                                    Expanded(
                                      child: Row(
                                        children: [
                                          // Feet 입력 필드
                                          Expanded(
                                            child: TextFormField(
                                              controller: heController,
                                              focusNode: heFocusNode,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintStyle: AppFont.s12,
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                errorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedErrorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                suffix: Text(
                                                  'Ft',
                                                  style: AppFont.r16.overrides(color: AppColors.Gray200),
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                              style: AppFont.r16,
                                            ),
                                          ),
                                          SizedBox(width: 8), // 간격 추가

                                          // Inch 입력 필드
                                          Expanded(
                                            child: TextFormField(
                                              controller: heController2,
                                              focusNode: heFocusNode2,
                                              autofocus: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintStyle: AppFont.s12,
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                errorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                focusedErrorBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.Gray200,
                                                    width: 1,
                                                  ),
                                                ),
                                                suffix: Text(
                                                  'In',
                                                  style: AppFont.r16.overrides(color: AppColors.Gray200),
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                              style: AppFont.r16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(width: 8), // 간격 추가

                                  // 단위 변경 버튼
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsetsDirectional.fromSTEB(0, 32, 8, 0),
                        //   child: TextFormField(
                        //       controller: emailController,
                        //       focusNode: emailFocusNode,
                        //       autofocus: false,
                        //       obscureText: false,
                        //       decoration: InputDecoration(
                        //         label: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'E-mail',
                        //               style: AppFont.s12.overrides(color: AppColors.Black),
                        //             ),
                        //             // Container(
                        //             //   height: 6, // Height of the dot
                        //             //   width: 6, // Width of the dot
                        //             //   decoration: BoxDecoration(
                        //             //     shape: BoxShape.circle,
                        //             //     color: AppColors.red, // Color of the dot
                        //             //   ),
                        //             // ),
                        //           ],
                        //         ),
                        //         labelStyle: AppFont.s12.overrides(color: AppColors.Black),
                        //         hintStyle: AppFont.s12,
                        //         enabledBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: AppColors.Gray200,
                        //             width: 1,
                        //           ),
                        //         ),
                        //         focusedBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: AppColors.Gray200,
                        //             width: 1,
                        //           ),
                        //         ),
                        //         errorBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: AppColors.Gray200,
                        //             width: 1,
                        //           ),
                        //         ),
                        //         focusedErrorBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: AppColors.Gray200,
                        //             width: 1,
                        //           ),
                        //         ),
                        //       ),
                        //       keyboardType: TextInputType.emailAddress,
                        //       style: AppFont.r16),
                        // ),
                        // Text(
                        //   'Please enter the correct e-mail including @\nYou need to write an e-mail to receive the experience report.',
                        //   style: AppFont.r16.overrides(fontSize: 12, color: AppColors.BlueGray),
                        // ),
                      ],
                    ),

                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(8, 10, 0, 0),
                    //   child: TextFormField(
                    //     controller: haController,
                    //     focusNode: haFocusNode,
                    //     autofocus: false,
                    //     obscureText: false,
                    //     decoration: InputDecoration(
                    //       label: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             SetLocalizations.of(context).getText(
                    //               'medical_history',
                    //             ),
                    //             style: AppFont.s12.overrides(color: AppColors.Black),
                    //           ),
                    //           // Container(
                    //           //   height: 6, // Height of the dot
                    //           //   width: 6, // Width of the dot
                    //           //   decoration: BoxDecoration(
                    //           //     shape: BoxShape.circle,
                    //           //     color: AppColors.red, // Color of the dot
                    //           //   ),
                    //           // ),
                    //         ],
                    //       ),
                    //       labelStyle: AppFont.s12.overrides(color: AppColors.Black),
                    //       hintText: SetLocalizations.of(context).getText(
                    //         'medical_history_detail',
                    //       ),
                    //       hintStyle: AppFont.s12.overrides(color: AppColors.Gray200),
                    //       enabledBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: AppColors.Gray200,
                    //           width: 1,
                    //         ),
                    //       ),
                    //       focusedBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: AppColors.Gray200,
                    //           width: 1,
                    //         ),
                    //       ),
                    //       errorBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: AppColors.Gray200,
                    //           width: 1,
                    //         ),
                    //       ),
                    //       focusedErrorBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: AppColors.Gray200,
                    //           width: 1,
                    //         ),
                    //       ),
                    //     ),
                    //     style: AppFont.r16,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    //   child: Container(
                    //       width: double.infinity,
                    //       height: 56.0,
                    //       child: LodingButtonWidget(
                    //           onPressed: () async {
                    //             _toggleNone();
                    //           },
                    //           icon: Theme(
                    //             data: ThemeData(
                    //               checkboxTheme: CheckboxThemeData(
                    //                 visualDensity: VisualDensity.compact,
                    //                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(12.0),
                    //                 ),
                    //               ),
                    //               unselectedWidgetColor: AppColors.Gray200,
                    //             ),
                    //             child: Checkbox(
                    //               value: isNone,
                    //               onChanged: null,
                    //               activeColor: AppColors.Black,
                    //               checkColor: AppColors.primaryBackground,
                    //             ),
                    //           ),
                    //           text: SetLocalizations.of(context).getText(
                    //             'no_medical_history' /* 완료 */,
                    //           ),
                    //           options: LodingButtonOptions(
                    //             height: 40.0,
                    //             padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    //             iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    //             textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Gray500),
                    //             elevation: 0,
                    //             color: AppColors.primaryBackground,
                    //             borderRadius: BorderRadius.circular(4.0),
                    //             borderSide: BorderSide(
                    //               color: AppColors.Gray500,
                    //               width: 1,
                    //             ),
                    //           ))),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    //   child: Container(
                    //       width: double.infinity,
                    //       height: 56.0,
                    //       child: LodingButtonWidget(
                    //         onPressed: () async {
                    //           if (areFieldsValidit) {
                    //             String data = biController.text;
                    //             //String finame = fiController.text;
                    //             //String name = namController.text;
                    //             double height = heController.text.isEmpty ? 0.0 : double.parse(heController.text);
                    //             //double weight = weController.text.isEmpty ? 0.0 : double.parse(weController.text);
                    //             //String Hospital = haController.text.isEmpty ? 'none' : haController.text;

                    //             await UserController.updatetester(data, finame, name, selectedGender, height, weight, Hospital).then((userData) {
                    //               context.goNamed('Tester_GetData2');
                    //             }).catchError((error) {
                    //               print('Error fetching user data: $error');
                    //             });
                    //           }
                    //         },
                    //         text: SetLocalizations.of(context).getText(
                    //           'next' /* 완료 */,
                    //         ),
                    //         options: LodingButtonOptions(
                    //           height: 40.0,
                    //           padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    //           iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    //           color: areFieldsValidit ? Colors.black : AppColors.Gray200, // Change color based on validation
                    //           textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                    //           elevation: 0,
                    //           borderRadius: BorderRadius.circular(8.0),
                    //         ),
                    //       )),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                          width: double.infinity,
                          height: 56.0,
                          child: LodingButtonWidget(
                            onPressed: () async {
                              if (areFieldsValid) {
                                AppStateNotifier.instance.unitiscm(_iscm);
                                bool userData = await UserController.getdatamode(
                                    biController.text,
                                    selectedGender,
                                    _iscm
                                        ? double.parse(heController.text)
                                        : (double.parse(heController.text) * 30.48) + (double.parse(heController2.text) * 2.54),
                                    emailController.text);
                                if (userData) {
                                  context.pushNamed('Teseter_Scan');
                                }
                                ;
                              }
                            },
                            text: SetLocalizations.of(context).getText(
                              'next' /* 완료 */,
                            ),
                            options: LodingButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: areFieldsValid ? Colors.black : AppColors.Gray200, // Change color based on validation
                              textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                              elevation: 0,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
