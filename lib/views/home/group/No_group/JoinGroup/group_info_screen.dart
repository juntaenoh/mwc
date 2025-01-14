import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:mwc/index.dart';

class GroupInfoScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String code;

  const GroupInfoScreen({Key? key, required this.data, required this.code}) : super(key: key);

  @override
  _GroupInfoScreenState createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Map<String, dynamic> groupData;

  @override
  void initState() {
    print(widget.data.runtimeType);
    groupData = widget.data;
    print(groupData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String groupLeaderName = groupData['members'][0]['firstName'] + groupData['members'][0]['lastName'];
    // int numberOfGroupMembers = groupData['data']['numberOfGroupMembers'];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.Black,
        appBar: AppBar(
          backgroundColor: Color(0x00CCFF8B),
          automaticallyImplyLeading: false,
          title: Text(
            SetLocalizations.of(context).getText(
              'ckadutlscj' /* Page Title */,
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
            padding: EdgeInsetsDirectional.fromSTEB(24, 40, 24, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                      child: Text(
                        groupLeaderName +
                            SetLocalizations.of(context).getText(
                              'tlvskdy' /* Page Title */,
                            ),
                        style: AppFont.b24.overrides(color: AppColors.primaryBackground),
                      ),
                    ),
                    Container(
                      width: 327,
                      height: 160,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFCFDFF).withOpacity(0.20), // 시작 색상
                            Color(0xFFFCFDFF).withOpacity(0.04), // 끝 색상
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.50, color: Color(0x33FBFCFF)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0xB2121212),
                            blurRadius: 8,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                groupData['groupName'],
                                style: AppFont.s18.overrides(color: AppColors.primaryBackground),
                              ),
                            ),
                            Text(
                              groupLeaderName + SetLocalizations.of(context).getText('dmlrdhonfnq'),
                              style: AppFont.r16.overrides(fontSize: 12, color: AppColors.primaryBackground),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Container(
                        width: double.infinity,
                        height: 56.0,
                        child: LodingButtonWidget(
                          onPressed: () {
                            context.pop();
                          },
                          text: SetLocalizations.of(context).getText(
                            'wodlqdur',
                          ),
                          options: LodingButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: Colors.transparent,
                            textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: AppColors.primaryBackground,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Container(
                        width: double.infinity,
                        height: 56.0,
                        child: LodingButtonWidget(
                          onPressed: () async {
                            GroupApi.createInvitation(widget.code).then((value) => value
                                ? showAlignedDialog(
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
                                            height: 366,
                                            width: 327,
                                            child: SuccessJoin(
                                              name: groupLeaderName,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : showAlignedDialog(
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
                                            height: 366,
                                            width: 327,
                                            child: CodeError(),
                                          ),
                                        ),
                                      );
                                    },
                                  ));
                          },
                          text: SetLocalizations.of(context).getText(
                            'tlscud',
                          ),
                          options: LodingButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: AppColors.primaryBackground,
                            textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                            elevation: 0,
                            borderSide: BorderSide(
                              color: AppColors.primaryBackground,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
