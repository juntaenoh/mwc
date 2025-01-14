import 'package:mwc/views/home/group/Yes_group/settings/delete_group.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwc/index.dart';
import 'package:provider/provider.dart';

class GroupSetting extends StatefulWidget {
  final String authority;
  final String groupname;
  const GroupSetting({Key? key, required this.authority, required this.groupname}) : super(key: key);

  @override
  _GroupSettingState createState() => _GroupSettingState();
}

class _GroupSettingState extends State<GroupSetting> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print(widget.authority);
    print(widget.groupname);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }
//TODOdi

  _showLeaveGroupDialog() {
    showCustomDialog(
      context: context,
      checkButtonColor: AppColors.red,
      backGroundtype: 'black',
      titleText: SetLocalizations.of(context).getText('rmfnqskrkrl'),
      descriptionText: SetLocalizations.of(context).getText('rmfnqs'),
      upperButtonText: SetLocalizations.of(context).getText('skrkrlqjxms'), //그룹 나가기
      upperButtonFunction: () async {
        await GroupApi.leaveGroup().then((value) async {
          showCustomDialog(
            context: context,
            backGroundtype: 'black',
            checkButtonColor: AppColors.DarkenGreen,
            titleText: SetLocalizations.of(context).getText('skrkrldhksfy'),
            descriptionText: SetLocalizations.of(context).getText('dhksfytjfaud'),
            upperButtonText: SetLocalizations.of(context).getText('ze1u6oze'), //그룹 나가기
            upperButtonFunction: () async {
              context.goNamed('home');
            },
          );
        });
      },
      lowerButtonText: SetLocalizations.of(context).getText('ehfkdrl'),
      /* 이전으로 돌아가기 */
      lowerButtonFunction: () {
        context.safePop();
      },
    );
  }
//TODOdi

  _showDeleteGroupDialog() {
    print("_showDeleteGroupDialog");
    showCustomDialog(
      context: context,
      backGroundtype: 'black',

      checkButtonColor: AppColors.red,
      titleText: SetLocalizations.of(context).getText('gktgkrf'),
      descriptionText: SetLocalizations.of(context).getText('rmfnqs'),
      upperButtonText: SetLocalizations.of(context).getText('rgklrkd'), //그룹 나가기
      upperButtonFunction: () async {
        await GroupApi.deleteGroup().then((value) async {
          showCustomDialog(
            context: context,
            backGroundtype: 'black',

            checkButtonColor: AppColors.DarkenGreen,
            titleText: SetLocalizations.of(context).getText('skrkrldhksfy'),
            descriptionText: SetLocalizations.of(context).getText('dhksfytjfaud'),
            upperButtonText: SetLocalizations.of(context).getText('ze1u6oze'), //그룹 나가기
            upperButtonFunction: () async {
              context.goNamed('home');
            },
          );
        });
      },
      lowerButtonText: SetLocalizations.of(context).getText('cnlth'),
      /* 이전으로 돌아가기 */
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> leaderMenu = {
      '멤버 관리': 'MemberManage',
      '그룹 참여 신청 관리': 'GroupJoinRequest',
      '그룹명 변경': 'ChangeGroupName',
      '초대 코드 관리': 'InvitationCodeManage',
      '그룹 삭제': 'DeleteGroup',
      '공개 정보 설정': 'PublicInfoSetting',
      '알림 설정': 'NotificationSetting',
      '그룹 히스토리': 'GroupHistory',
    };

    // 일반 사용자용 메뉴 리스트와 페이지 매핑
    final Map<String, String> userMenu = {
      '공개 정보 설정': 'PublicInfoSetting',
      '알림 설정': 'NotificationSetting',
      '그룹 히스토리': 'GroupHistory',
      '그룹 나가기': 'LeaveGroup',
      '리더 변경 요청': 'Changeleader',
    };
    final menuList = (widget.authority == 'GROUP_LEADER') ? leaderMenu : userMenu;

    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return Consumer<AppStateNotifier>(builder: (context, AppStateNotifier, child) {
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
              backgroundColor: Color(0x00CCFF8B),
              automaticallyImplyLeading: false,
              title: Text(
                  SetLocalizations.of(context).getText(
                    'rmfnt' /* 그룹   */,
                  ),
                  style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                String menuTitle = menuList.keys.elementAt(index);
                return ListTile(
                  title: Text(menuTitle, style: AppFont.s12.overrides(fontSize: 16, color: AppColors.Gray100)),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.Gray100,
                  ),
                  onTap: () async {
                    if (menuTitle == '그룹 나가기') {
                      _showLeaveGroupDialog();
                    } else if (menuTitle == '그룹 삭제') {
                      _showDeleteGroupDialog();
                    } else if (menuTitle == '초대 코드 관리') {
                      await GroupApi.getAllInvitationCodes();
                      print(AppStateNotifier.iscode);
                      if (AppStateNotifier.iscode) {
                        context.pushNamed('InvitationCodeManage');
                      } else
                        context.pushNamed('GroupCreatecode');
                    } else {
                      context.pushNamed(menuList[menuTitle]!);
                    }
                  },
                );
              },
            ),
          ));
    });
  }
}
