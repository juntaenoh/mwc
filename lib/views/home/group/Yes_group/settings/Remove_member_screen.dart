import 'dart:convert';

import 'package:mwc/views/home/group/widgets/member_more.dart';
import 'package:mwc/views/home/group/widgets/removeMemberOnly_pop.dart';
import 'package:mwc/views/home/group/widgets/removeMember_changeLeader.dart';
import 'package:mwc/views/home/group/widgets/removeMembers_pop.dart';
import 'package:mwc/models/GroupData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class RemoveMemberPage extends StatefulWidget {
  const RemoveMemberPage({Key? key}) : super(key: key);

  @override
  _RemoveMemberPageState createState() => _RemoveMemberPageState();
}

class _RemoveMemberPageState extends State<RemoveMemberPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Member> selectedmember = [];
  List<Member> memberData = [];

  String group = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void _onMemberSelected(bool isSelected, Member member) {
    setState(() {
      if (isSelected) {
        selectedmember.add(member);
      } else {
        selectedmember.remove(member);
      }
    });
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

    return Consumer<AppStateNotifier>(builder: (context, appStateNotifier, child) {
      //memberData = appStateNotifier.groupData!.first.members.where((element) => element.authority != 'GROUP_LEADER').toList();
      memberData = appStateNotifier.groupData!.first.members;

      return GestureDetector(
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
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppColors.primaryBackground,
                    size: 24,
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: Container(height: MediaQuery.sizeOf(context).height * 0.4, child: MemberMore()),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                ),
              ],
              backgroundColor: Color(0x00CCFF8B),
              automaticallyImplyLeading: false,
              title: Text(SetLocalizations.of(context).getText('doaqjqkdcnf'), style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: memberData.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedmember.contains(memberData[index]);
                      return Container(
                        width: 232,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
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
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              memberData[index].firstName + memberData[index].lastName,
                                              style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground),
                                            ),
                                            Text(memberData[index].authority, style: AppFont.r16.overrides(fontSize: 12, color: AppColors.Gray300)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
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
                                              unselectedWidgetColor: AppColors.Gray700),
                                          child: Checkbox(
                                            value: isSelected,
                                            checkColor: AppColors.Black, // Color of the tick
                                            activeColor: AppColors.Gray100, // Background color
                                            onChanged: (bool? newValue) {
                                              _onMemberSelected(newValue!, memberData[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.Gray700,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    child: LodingButtonWidget(
                      onPressed: () async {
                        if (selectedmember.isNotEmpty) {
                          if (selectedmember.any((element) => element.authority == 'GROUP_LEADER')) {
                            showAlignedDialog(
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
                                      child: RemoveMembersleader(),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            showAlignedDialog(
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
                                      child: RemoveMembers(
                                        selectedmember: selectedmember,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          // for (var userId in selectedUserIds) {
                          //   //await GroupApi.removeMemberByGroupleader(userId);
                          // }
                        }
                      },
                      text: SetLocalizations.of(context).getText('qkdcnfkrl'),
                      options: LodingButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: selectedmember.isEmpty ? AppColors.Gray200 : AppColors.primaryBackground,
                        textStyle: AppFont.s18.overrides(fontSize: 16, color: selectedmember.isEmpty ? AppColors.primaryBackground : AppColors.Black),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }
}
