import 'package:mwc/utils/fisica_theme.dart';
import 'package:mwc/widgets/flutter_drop_down.dart';
import 'package:mwc/utils/form_field_controller.dart';
import 'package:mwc/utils/internationalization.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onStatusChanged;
  final Function(String) onSelected;
  final Function(String) onSubmitted;

  CustomInputField({
    Key? key,
    required this.controller,
    required this.onStatusChanged,
    required this.onSelected,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FormFieldController<String>? dropDownValueController2;
  String? selectedDropdownValue = '+82';

  String inputType = 'none';
  TextInputType keyboardType = TextInputType.text;

  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode noneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return SetLocalizations.of(context).getText(
        'loginHomeInputEmailHint', // 전화번호 또는 E-mail을 입력해 주세요
      );
    } else if (!value.contains('@')) {
      return SetLocalizations.of(context).getText(
        'loginHomeInputEmailError', // @를 포함한 정확한 이메일을 입력해 주세요
      );
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return SetLocalizations.of(context).getText(
        'loginHomeInputEmailHint', // 전화번호 또는 E-mail을 입력해 주세요
      );
    } else if (!value.startsWith('01')) {
      return SetLocalizations.of(context).getText(
        'loginHomeInputPhoneError', // '010을 포함하여 숫자만 입력해 주세요
      );
    }
    return null;
  }

  void _onTextChanged() {
    String input = widget.controller.text;
    String newInputType = 'none';

    if (input.length >= 2) {
      if (isPhoneNumber(input)) {
        newInputType = 'phone';
      } else {
        newInputType = 'email';
      }
    }

    if (newInputType != inputType) {
      setState(() {
        inputType = newInputType;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateKeyboard(inputType); // 키보드 유형 업데이트
      });
    }

    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
    widget.onStatusChanged(inputType); // 입력 타입이 변경될 때 즉시 상태 변경 콜백 호출
  }

  bool isPhoneNumber(String s) {
    // 숫자, 소괄호, 마침표, 하이픈 이외의 문자가 포함되어 있으면 false 반환
    return RegExp(r'^[0-9().\-]+$').hasMatch(s);
  }

  void _updateKeyboard(String inputType) {
    if (inputType == 'email') {
      // 이메일 입력 필드로 포커스 이동
      FocusScope.of(context).requestFocus(emailFocusNode);
    } else if (inputType == 'phone') {
      // 전화번호 입력 필드로 포커스 이동
      FocusScope.of(context).requestFocus(phoneFocusNode);
    } else {
      // 포커스를 아무 입력 필드에도 두지 않음
      FocusScope.of(context).requestFocus(noneFocusNode);
    }
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  bool isAlphabet(String s) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(s);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _buildInputField(),
    );
  }

  Widget _buildInputField() {
    switch (inputType) {
      case 'none':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SetLocalizations.of(context).getText('loginHomeInputEmailLabel'),
              style: AppFont.s12,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.controller,
              focusNode: noneFocusNode,
              onFieldSubmitted: (value) {
                widget.onSubmitted;
              },
              onChanged: (value) {
                // 입력 값이 변경될 때마다 상태를 갱신
                setState(() {
                  _onTextChanged(); // 즉각적으로 상태 반영
                });
              },
              decoration: InputDecoration(
                hintText: SetLocalizations.of(context).getText(
                  'loginHomeInputEmailHint',
                ),
                hintStyle: AppFont.r16.overrides(color: AppColors.Gray300),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                suffixIcon: widget.controller.text.isNotEmpty
                    ? InkWell(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: AppColors.Gray100,
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.all(14),
                          child: Icon(
                            Icons.clear,
                            color: AppColors.Gray500,
                            size: 10,
                          ),
                        ),
                        onTap: () {
                          widget.controller.clear();
                        },
                      )
                    : null,
              ),
              style: AppFont.r16.overrides(color: AppColors.Gray700),
              keyboardType: keyboardType,
            ),
          ],
        );
      case 'email':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SetLocalizations.of(context).getText('loginHomeInputEmailLabel'),
              style: AppFont.s12,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.controller,
              focusNode: emailFocusNode,
              autofocus: false,
              onFieldSubmitted: (value) {
                widget.onSubmitted(value);
              },
              onChanged: (value) {
                // 입력 값이 변경될 때마다 상태를 갱신
                setState(() {
                  _onTextChanged(); // 즉각적으로 상태 반영
                });
              },
              decoration: InputDecoration(
                labelStyle: AppFont.r16.overrides(color: AppColors.Gray500),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.Gray200,
                    width: 2.0,
                  ),
                ),
                suffixIcon: widget.controller.text.isNotEmpty
                    ? InkWell(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: AppColors.Gray100,
                            shape: BoxShape.circle,
                          ),
                          margin: EdgeInsets.all(14),
                          child: Icon(
                            Icons.clear,
                            color: AppColors.Gray500,
                            size: 10,
                          ),
                        ),
                        onTap: () {
                          widget.controller.clear();
                          _formKey.currentState!.validate();
                        },
                      )
                    : null,
                errorText: emailValidator(widget.controller.text),
              ),
              style: AppFont.r16.overrides(color: AppColors.Gray700),
              validator: emailValidator,
            ),
          ],
        );
      case 'phone':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SetLocalizations.of(context).getText('loginHomeSelectPhoneLabel'),
                    style: AppFont.s12,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlutterDropDown<String>(
                    controller: dropDownValueController2 ??= FormFieldController<String>("+82"),
                    hintText: '+82',
                    options: ['+1', '+91', '+82', '+81'],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDropdownValue = newValue ?? '+82';
                      });
                      widget.onSelected(selectedDropdownValue!);
                    },
                    height: 38.0,
                    textStyle: AppFont.r16.overrides(color: AppColors.Gray500),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.Gray500,
                      size: 20.0,
                    ),
                    elevation: 2.0,
                    borderColor: AppColors.Gray200,
                    borderWidth: 1.0,
                    borderRadius: 8.0,
                    borderStyle: 'bottom',
                    margin: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
                    hidesUnderline: true,
                    isSearchable: false,
                    isMultiSelect: false,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SetLocalizations.of(context).getText('loginHomeInputPhoneLabel'),
                    style: AppFont.s12,
                  ),
                  TextFormField(
                      controller: widget.controller,
                      focusNode: phoneFocusNode,
                      onFieldSubmitted: (value) {
                        widget.onSubmitted(value);
                      },
                      onChanged: (value) {
                        // 입력 값이 변경될 때마다 상태를 갱신
                        setState(() {
                          _onTextChanged(); // 즉각적으로 상태 반영
                        });
                      },
                      decoration: InputDecoration(
                        labelStyle: AppFont.r16,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.Gray200,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.Gray200,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.Gray200,
                            width: 1.0,
                          ),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.Gray200,
                            width: 1.0,
                          ),
                        ),
                        suffixIcon: widget.controller.text.isNotEmpty
                            ? InkWell(
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: AppColors.Gray100,
                                    shape: BoxShape.circle,
                                  ),
                                  margin: EdgeInsets.all(14),
                                  child: Icon(
                                    Icons.clear,
                                    color: AppColors.Gray500,
                                    size: 10,
                                  ),
                                ),
                                onTap: () {
                                  widget.controller.clear();
                                },
                              )
                            : null,
                        errorText: phoneValidator(widget.controller.text),
                      ),
                      style: AppFont.r16.overrides(color: AppColors.Gray700),
                      validator: phoneValidator),
                ],
              ),
            ),
          ],
        );
      default:
        return Container(); // 기본값
    }
  }
}
