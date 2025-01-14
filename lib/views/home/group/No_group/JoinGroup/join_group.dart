import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mwc/index.dart';

class JoingroupWidget extends StatefulWidget {
  const JoingroupWidget({Key? key}) : super(key: key);

  @override
  _JoingroupWidgetState createState() => _JoingroupWidgetState();
}

class _JoingroupWidgetState extends State<JoingroupWidget> {
  final TextEditingController myController = TextEditingController();
  FocusNode? textFieldFocusNode;
  bool isButtonEnabled = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    myController.addListener(_isValidLong);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _isValidLong() {
    if (myController.text.length >= 4) {
      setState(() {
        isButtonEnabled = true;
      });
    } else if (myController.text.length < 4) {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  Future<bool> _handleFetchGroupInfo() async {
    String invitationCode = myController.text;
    try {
      FocusScope.of(context).unfocus();
      final groupData = await GroupApi.getGroupByInvitationCode(invitationCode);

      print(groupData.runtimeType);

      context.pushNamed(
        'GroupInfo',
        extra: {'data': groupData, 'code': invitationCode},
      );
      return true;
    } catch (e) {
      if (e is Exception) {
        print('Exception occurred: $e');
      } else {
        print('Unknown error occurred: $e');
      }
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
              child: Container(
                height: 432,
                width: 327,
                child: CodeError(),
              ),
            ),
          );
        },
      );
      return false;
    }
  }

  @override
  void dispose() {
    myController.removeListener(_isValidLong);
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
        backgroundColor: AppColors.Black,
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
              color: AppColors.primaryBackground,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            SetLocalizations.of(context).getText(
              'rmfnqckadu' /* Page Title */,
            ),
            style: AppFont.s18,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 40, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      SetLocalizations.of(context).getText(
                        'cheozhemdlqfur' /* 초대코드 입력 */,
                      ),
                      style: AppFont.r16.overrides(color: AppColors.primaryBackground),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
                      child: TextFormField(
                        controller: myController,
                        focusNode: textFieldFocusNode,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                            labelStyle: AppFont.r16,
                            hintStyle: AppFont.r16,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.Gray850,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.Gray850,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.Gray200,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.Gray200,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: AppColors.Gray850),
                        style: AppFont.r16.overrides(color: AppColors.primaryBackground),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: isButtonEnabled
                          ? () async {
                              FocusScope.of(context).unfocus();
                              await _handleFetchGroupInfo();
                            }
                          : null,
                      text: SetLocalizations.of(context).getText(
                        'rmfqnckqrl' /* 그룹찾기 */,
                      ),
                      options: LodingButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: isButtonEnabled ? AppColors.primaryBackground : AppColors.Gray200,
                        textStyle: AppFont.s18.overrides(fontSize: 16, color: isButtonEnabled ? AppColors.Black : AppColors.primaryBackground),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: AppColors.Black,
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
        ),
      ),
    );
  }
}
