import 'dart:convert';

import 'package:mwc/models/GroupInvitation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';

class GroupJoinHistory extends StatefulWidget {
  const GroupJoinHistory({Key? key}) : super(key: key);

  @override
  _GroupJoinHistoryState createState() => _GroupJoinHistoryState();
}

class _GroupJoinHistoryState extends State<GroupJoinHistory> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Invitation> groupInvitation = [];
  var parsedJson;
  @override
  void initState() {
    super.initState();
    initGroupData();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> initGroupData() async {
    GroupApi.getGroupInvitations().then((value) => setState(() {
          parsedJson = value;
          groupInvitation = AppStateNotifier.instance.groupInvitation!;
          print(groupInvitation);
        }));
  }

  Text statetext(String state) {
    if (state == 'PENDING') {
      return Text(
        SetLocalizations.of(context).getText('tmddlseorl' /*승인대기중*/),
        style: AppFont.s12.overrides(color: AppColors.DarkenGreen),
      );
    } else if (state == 'ACCEPTED') {
      return Text(
        SetLocalizations.of(context).getText('tmddlsdh' /*승인 완료*/),
        style: AppFont.s12.overrides(color: AppColors.Gray300),
      );
    } else if (state == 'CANCELLED') {
      return Text(
        SetLocalizations.of(context).getText('rjwjd' /*승인 거절*/),
        style: AppFont.s12.overrides(color: AppColors.Gray300),
      );
    } else
      return Text('data');
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

  @override
  void dispose() {
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
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: AppColors.Black,
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
                backgroundColor: Color(0x00CCFF8B),
                automaticallyImplyLeading: false,
                title: Text(
                    SetLocalizations.of(context).getText(
                      'rmfnqdk' /* 그룹 참여신청관리  */,
                    ),
                    style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
                centerTitle: false,
                elevation: 0.0,
              ),
              body: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: groupInvitation.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
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
                                          child: Text(
                                            groupInvitation[index].requestUserFirstName,
                                            style: AppFont.r16.overrides(color: AppColors.primaryBackground),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        statetext(groupInvitation[index].status),
                                        Text(
                                          //timeElapsedSince(groupInvitation[index].status),
                                          timeElapsedSince('2024-01-27 21:21:51'),

                                          style: AppFont.r16.overrides(fontSize: 10, color: AppColors.Gray500),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(color: AppColors.Gray700),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ))),
    );
  }
}
