import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/components/1.1.1_Agreement_PopUp.dart';

import 'package:mwc/index.dart';

class TestTos extends StatefulWidget {
  const TestTos({Key? key}) : super(key: key);

  @override
  _TestTosState createState() => _TestTosState();
}

class _TestTosState extends State<TestTos> {
  final unfocusNode = FocusNode();

  bool selectAll = false;
  bool agree1 = false;
  bool agree2 = false;
  bool agree3 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    super.dispose();
  }

  void _onSelectAllChanged(bool? newValue) {
    setState(() {
      selectAll = newValue!;
      agree1 = newValue;
      agree2 = newValue;
      agree3 = newValue;
    });
  }

  void _onAgree1(bool? newValue) {
    setState(() {
      agree1 = newValue!;
      selectAll = agree1 && agree2;
    });
  }

  void _onAgree2(bool? newValue) {
    setState(() {
      agree2 = newValue!;
      selectAll = agree1 && agree2;
    });
  }

  // void _onAgree3(bool? newValue) {
  //   setState(() {
  //     agree3 = newValue!;
  //     selectAll = agree1 && agree2;
  //   });
  // }

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
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0x00CCFF8B),
          automaticallyImplyLeading: false,
          leading: AppIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.chevron_left,
              color: AppColors.Gray700,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text('Agree to Terms and Conditions', style: AppFont.s18.overrides(color: AppColors.Gray700)),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 77.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome to Fisica!', style: AppFont.b24),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                          child: Text('You need to login to get started', style: AppFont.r16),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: AppColors.Gray200),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Container(
                          height: 100.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Theme(
                                data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    unselectedWidgetColor: AppColors.Gray200),
                                child: Checkbox(
                                    value: selectAll,
                                    onChanged: _onSelectAllChanged,
                                    activeColor: AppColors.Black,
                                    checkColor: AppColors.primaryBackground),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                child: Text('Agree to all', style: AppFont.s18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100.0,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Theme(
                                    data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        unselectedWidgetColor: AppColors.Gray200),
                                    child: Checkbox(
                                      value: agree1,
                                      onChanged: _onAgree1,
                                      activeColor: AppColors.Black,
                                      checkColor: AppColors.primaryBackground,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Agree to Terms of Use',
                                      style: AppFont.r16.overrides(color: AppColors.Gray700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.Gray700,
                                size: 20.0,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () => unfocusNode.canRequestFocus
                                          ? FocusScope.of(context).requestFocus(unfocusNode)
                                          : FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding: MediaQuery.viewInsetsOf(context),
                                        child: Container(
                                            height: MediaQuery.sizeOf(context).height * 0.6,
                                            child: UptosWidget(
                                              index: 1,
                                              onAgree: (value) {
                                                setState(() {
                                                  //agree1 = value;
                                                  _onAgree1(value);
                                                });
                                              },
                                            )),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 40.0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 100.0,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
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
                                      value: agree2,
                                      onChanged: _onAgree2,
                                      activeColor: AppColors.Black,
                                      checkColor: AppColors.primaryBackground,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Consent to collection and\nuse of personal information',
                                      style: AppFont.r16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 20.0,
                              borderWidth: 1.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.Gray700,
                                size: 20.0,
                              ),
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () => unfocusNode.canRequestFocus
                                          ? FocusScope.of(context).requestFocus(unfocusNode)
                                          : FocusScope.of(context).unfocus(),
                                      child: Padding(
                                        padding: MediaQuery.viewInsetsOf(context),
                                        child: Container(
                                            height: MediaQuery.sizeOf(context).height * 0.6,
                                            child: UptosWidget(
                                              index: 2,
                                              onAgree: (value) {
                                                setState(() {
                                                  _onAgree2(value);
                                                });
                                              },
                                            )),
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   height: 40.0,
                    //   child: Padding(
                    //     padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.max,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Container(
                    //           height: 100.0,
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             children: [
                    //               Theme(
                    //                 data: ThemeData(
                    //                     checkboxTheme: CheckboxThemeData(
                    //                       visualDensity: VisualDensity.compact,
                    //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //                       shape: RoundedRectangleBorder(
                    //                         borderRadius: BorderRadius.circular(12.0),
                    //                       ),
                    //                     ),
                    //                     unselectedWidgetColor: AppColors.Gray200),
                    //                 child: Checkbox(
                    //                   value: agree3,
                    //                   onChanged: _onAgree3,
                    //                   activeColor: AppColors.Black,
                    //                   checkColor: AppColors.primaryBackground,
                    //                 ),
                    //               ),
                    //               Padding(
                    //                 padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                    //                 child: Text(
                    //                   SetLocalizations.of(context).getText(
                    //                     'dlsla',
                    //                   ),
                    //                   style: AppFont.r16.overrides(color: AppColors.Gray700),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         AppIconButton(
                    //           borderColor: Colors.transparent,
                    //           borderRadius: 20.0,
                    //           borderWidth: 1.0,
                    //           buttonSize: 40.0,
                    //           icon: Icon(
                    //             Icons.chevron_right_rounded,
                    //             color: AppColors.Gray700,
                    //             size: 20.0,
                    //           ),
                    //           onPressed: () async {
                    //             await showModalBottomSheet(
                    //               isScrollControlled: true,
                    //               backgroundColor: Colors.transparent,
                    //               enableDrag: false,
                    //               context: context,
                    //               builder: (context) {
                    //                 return GestureDetector(
                    //                   onTap: () => unfocusNode.canRequestFocus
                    //                       ? FocusScope.of(context).requestFocus(unfocusNode)
                    //                       : FocusScope.of(context).unfocus(),
                    //                   child: Padding(
                    //                     padding: MediaQuery.viewInsetsOf(context),
                    //                     child: Container(
                    //                         height: MediaQuery.sizeOf(context).height * 0.6,
                    //                         child: UptosWidget(
                    //                           index: 3,
                    //                           onAgree: (value) {
                    //                             setState(() {
                    //                               //agree1 = value;
                    //                               _onAgree3(value);
                    //                             });
                    //                           },
                    //                         )),
                    //                   ),
                    //                 );
                    //               },
                    //             ).then((value) => safeSetState(() {}));
                    //           },
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                if (!agree1)
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: () {
                        print('Button pressed ...');
                      },
                      text: 'Agree',
                      options: LodingButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: AppColors.Gray200,
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
                if (agree1)
                  Container(
                    width: double.infinity,
                    height: 56.0,
                    decoration: BoxDecoration(),
                    child: LodingButtonWidget(
                      onPressed: () async {
                        context.pushNamed('Tester_GetData1');
                      },
                      text: 'Agree',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
