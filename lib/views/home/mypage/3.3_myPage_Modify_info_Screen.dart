import 'package:mwc/models/UserData.dart';
import 'package:mwc/utils/DialogManager.dart';

import 'package:mwc/utils/form_field_controller.dart';
import 'package:mwc/views/home/mypage/mypage_components/Cancle_modi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';
import 'package:image_picker/image_picker.dart';

class ModiUserInfoWidget extends StatefulWidget {
  const ModiUserInfoWidget({Key? key}) : super(key: key);

  @override
  _ModiUserInfoWidgetState createState() => _ModiUserInfoWidgetState();
}

class _ModiUserInfoWidgetState extends State<ModiUserInfoWidget> {
  UserData? data;
  late Future<void> _userInfoFuture; // Variable to store the future
  var fiController = TextEditingController();
  var fiFocusNode = FocusNode();
  var namController = TextEditingController();
  var namFocusNode = FocusNode();
  var heController = TextEditingController();
  var heFocusNode = FocusNode();
  var weController = TextEditingController();
  var weFocusNode = FocusNode();
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> getData() async {
    data = AppStateNotifier.instance.userdata;
    print(data);
    setState(() {
      print('set');
      fiController = TextEditingController(text: data!.firstName);
      fiFocusNode = FocusNode();

      namController = TextEditingController(text: data!.lastName);
      namFocusNode = FocusNode();

      heController = TextEditingController(text: data!.height.toString());
      heFocusNode = FocusNode();

      weController = TextEditingController(text: data!.weight.toString());
      weFocusNode = FocusNode();

      selectedDate = DateTime.parse(data!.birthday ?? '2024-01-01 00:00:00.000');
      print(selectedDate);
      selectedGender = data!.gender ?? 'NONE';
      print(selectedGender);
      dropDownValue = data?.region ?? 'KR';
      print(dropDownValue);
    });
  }

  DateTime? selectedDate;
  String selectedGender = 'none';
  String dropDownValue = 'KR';
  FormFieldController<String>? dropDownValueController;
  late AppStateNotifier _appStateNotifier;
  bool isDelete = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _userInfoFuture = getData();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> finalbutton() async {
    if (areFieldsValid) {
      String data = selectedDate != null
          ? "${selectedDate!.year}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}"
          : "0000/00/00";
      String finame = fiController.text;
      String name = namController.text;
      double height = heController.text.isEmpty ? 0.0 : double.parse(heController.text);
      double weight = weController.text.isEmpty ? 0.0 : double.parse(weController.text);

      if ((_image != null) || isDelete) await UserController.uploadProfileImage(!isDelete, _image);

      await UserController.modiProfile(data, finame, name, selectedGender, height, weight, _image).then((userData) {
        _appStateNotifier = AppStateNotifier.instance;

        context.goNamed('home');
      }).catchError((error) {
        print('Error fetching user data: $error');
      });
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('사진 갤러리 열기'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                  isDelete = false;
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('사진 촬영하기'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                  isDelete = false;
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('사진 삭제하기'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _image = null;
                    isDelete = true;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker() {}

  bool get areFieldsValid {
    return fiController.text.isNotEmpty && namController.text.isNotEmpty;
  }

  @override
  void dispose() {
    dispose();

    super.dispose();
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0x00CCFF8B),
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Text(
                    SetLocalizations.of(context).getText(
                      'signupUserInfoButtonReturnLabel' /* Page Title */,
                    ),
                    style: AppFont.s18.overrides(color: AppColors.Black)),
              ),
            ],
          ),
          actions: [
            AppIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 60,
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () async {
                await DialogManager.showDialogByType(
                  context: context,
                  dialogType: 'modify',
                  getupperButtonFunction: () {
                    finalbutton();
                  },
                  getlowerButtonFunction: () {
                    context.goNamed('home');
                  },
                ).then((value) => setState(() {}));

                await showAlignedDialog(
                  context: context,
                  isGlobal: true,
                  avoidOverflow: false,
                  targetAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
                  followerAnchor: AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
                  builder: (dialogContext) {
                    return Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        // onTap: () => unfocusNode.canRequestFocus
                        //     ? FocusScope.of(context).requestFocus(unfocusNode)
                        //     : FocusScope.of(context).unfocus(),
                        child: Container(
                          height: 432,
                          width: 327,
                          child: CancleModi(finalbutton: finalbutton),
                        ),
                      ),
                    );
                  },
                ).then((value) => setState(() {}));
              },
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: _userInfoFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text("데이터 로딩 중 에러 발생"));
              } else {
                return SafeArea(
                  top: true,
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Center(
                                    child: GestureDetector(
                                  onTap: () => _showImagePickerOptions(context),
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.black,
                                    backgroundImage: !isDelete
                                        ? (_image != null
                                            ? FileImage(_image!) as ImageProvider
                                            : (data?.photoUrl != null
                                                ? NetworkImage(data!.photoUrl!) as ImageProvider
                                                : null)) // isDelete가 false일 때만 이미지 표시
                                        : null, // isDelete가 true일 경우 아무것도 표시하지 않음
                                    child: !isDelete && _image == null && data?.photoUrl == null
                                        ? Icon(Icons.person, color: Colors.white) // 이미지가 없을 때 기본 아이콘 표시
                                        : null, // isDelete가 true일 경우 아무것도 표시하지 않음
                                  ),
                                )),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 8, 0),
                                        child: TextFormField(
                                          controller: fiController,
                                          focusNode: fiFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            label: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  SetLocalizations.of(context).getText(
                                                    'signupUserInfoInputLastNameLabel' /*성 */,
                                                  ),
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
                                            labelStyle: AppFont.s12.overrides(color: AppColors.Black),
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
                                          ),
                                          style: AppFont.s12,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Field cannot be empty';
                                            }
                                            bool isKorean = RegExp(r"[\uac00-\ud7af]").hasMatch(value);
                                            bool isJapanese = RegExp(r"[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9faf]").hasMatch(value);
                                            if (isKorean && value.length > 2) {
                                              return '한글은 2자 이하로 입력해주세요';
                                            } else if (isJapanese && value.length > 20) {
                                              return '日本語は20文字以内で入力してください';
                                            } else if (!isKorean && !isJapanese && value.length > 12) {
                                              return '영어는 12자 이하로 입력해주세요';
                                            }
                                            return null; // null means input is valid
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(8, 20, 0, 0),
                                        child: TextFormField(
                                          controller: namController,
                                          focusNode: namFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            label: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  SetLocalizations.of(context).getText(
                                                    'signupUserInfoInputFirstNameLabel' /* Label here... */,
                                                  ),
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
                                          ),
                                          style: AppFont.s12,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Field cannot be empty';
                                            }
                                            bool isKorean = RegExp(r"[\uac00-\ud7af]").hasMatch(value);
                                            bool isJapanese = RegExp(r"[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9faf]").hasMatch(value);
                                            if (isKorean && value.length > 15) {
                                              return '한글은 15자 이하로 입력해주세요';
                                            } else if (isJapanese && value.length > 20) {
                                              return '日本語は20文字以内で入力してください';
                                            } else if (!isKorean && !isJapanese && value.length > 20) {
                                              return '영어는 20자 이하로 입력해주세요';
                                            }
                                            return null; // null means input is valid
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              SetLocalizations.of(context).getText('signupUserInfoInputBirthLabel'),
                                              style: AppFont.s12.overrides(color: AppColors.Black),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                              child: InkWell(
                                                onTap: _showDatePicker,
                                                child: Container(
                                                    width: double.infinity,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: AppColors.Gray200,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      selectedDate != null
                                                          ? "${selectedDate!.year}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}"
                                                          : "00/00/00",
                                                      style: TextStyle(fontSize: 16),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        SetLocalizations.of(context).getText('signupUserInfoButtonGenderLabel'),
                                        style: AppFont.s12.overrides(color: AppColors.Black),
                                      )
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
                                              print('MALE');
                                              selectedGender = 'MALE';
                                            });
                                          },
                                          text: SetLocalizations.of(context).getText(
                                            'signupUserInfoButtonGenderMaleLabel' /* 남성 */,
                                          ),
                                          options: LodingButtonOptions(
                                            height: 40,
                                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                            color: selectedGender == 'MALE' ? Colors.black : AppColors.primaryBackground,
                                            textStyle: AppFont.s12.overrides(color: selectedGender == 'MALE' ? Colors.white : AppColors.Gray300),
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
                                              print('female');
                                              selectedGender = 'FEMALE';
                                            });
                                          },
                                          text: SetLocalizations.of(context).getText(
                                            'signupUserInfoButtonGenderFemaleLabel' /* 여성 */,
                                          ),
                                          options: LodingButtonOptions(
                                            height: 40,
                                            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                            iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                            color: selectedGender == 'FEMALE' ? Colors.black : AppColors.primaryBackground,
                                            textStyle: AppFont.s12.overrides(color: selectedGender == 'FEMALE' ? Colors.white : AppColors.Gray300),
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
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 32, 8, 0),
                                        child: TextFormField(
                                            controller: heController,
                                            focusNode: heFocusNode,
                                            autofocus: false,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                                labelText: SetLocalizations.of(context).getText(
                                                  'signupUserInfoInputHeightLabel' /* Label here... */,
                                                ),
                                                labelStyle: AppFont.s12.overrides(color: AppColors.Black),
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
                                                )),
                                            style: AppFont.r16),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(8, 32, 0, 0),
                                        child: TextFormField(
                                          controller: weController,
                                          focusNode: weFocusNode,
                                          autofocus: false,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                              labelText: SetLocalizations.of(context).getText(
                                                'signupUserInfoInputWeightLabel' /* Label here... */,
                                              ),
                                              labelStyle: AppFont.s12.overrides(color: AppColors.Black),
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
                                                'Kg',
                                                style: AppFont.r16.overrides(color: AppColors.Gray200),
                                              )),
                                          style: AppFont.r16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Container(
                                  width: double.infinity,
                                  height: 56.0,
                                  child: LodingButtonWidget(
                                    onPressed: () async {
                                      finalbutton();
                                    },
                                    text: SetLocalizations.of(context).getText(
                                      'signupUserInfoButtonCompleteLabel' /* 완료 */,
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
                );
              }
            }),
      ),
    );
  }
}
