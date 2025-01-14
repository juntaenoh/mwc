import 'package:mwc/components/groupNamechanged.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';

class ChangeGroupNamePage extends StatefulWidget {
  const ChangeGroupNamePage({Key? key}) : super(key: key);

  @override
  _ChangeGroupNamePageState createState() => _ChangeGroupNamePageState();
}

class _ChangeGroupNamePageState extends State<ChangeGroupNamePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController myController = TextEditingController();
  FocusNode? textFieldFocusNode;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    myController.addListener(_onGroupNameChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _onGroupNameChanged() {
    setState(() {
      isButtonEnabled = myController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    myController.removeListener(_onGroupNameChanged);

    super.dispose();
  }

  void _handleFetchGroupInfo() async {
    String name = myController.text;
    try {
      await GroupApi.updateGroupname(name).then((value) => showAlignedDialog(
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
                    child: Changegroupname(
                      name: name,
                    ),
                  ),
                ),
              );
            },
          ));
    } catch (e) {
      if (e is Exception) {
        print('Exception occurred: $e');
      } else {
        print('Unknown error occurred: $e');
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: GestureDetector(
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
                      'rmfnqaudrud' /* 그룹   */,
                    ),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
                centerTitle: false,
                elevation: 0.0,
              ),
              body: SafeArea(
                top: true,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 40, 24, 0),
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
                            SetLocalizations.of(context).getText('gkfntdlTdma'),
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
                                    _handleFetchGroupInfo();
                                  }
                                : null,
                            text: SetLocalizations.of(context).getText('qusrudhgks'),
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
              )),
        ));
  }
}
