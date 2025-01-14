// Export pages

export 'components/Success_Join.dart';
export 'components/cancel_invitation.dart';
export 'components/invitation_codeError.dart';
export 'dart:async';
export 'dart:io';
export 'package:aligned_dialog/aligned_dialog.dart';

export 'package:flutter_blue_plus/flutter_blue_plus.dart';
export 'package:flutter_localizations/flutter_localizations.dart';
export 'package:flutter_svg/svg.dart';
export 'package:flutter_web_plugins/url_strategy.dart';
export 'package:model_viewer_plus/model_viewer_plus.dart';
export 'utils/service/User_Controller.dart';
export 'utils/service/group_api.dart';
export 'utils/fisica_theme.dart';
export 'utils/flutter_util.dart';
export 'utils/internationalization.dart';
export 'utils/Data_Notifire.dart';
export 'widgets/showCustomDialog.dart';

//home page
export 'views/home/home_page/home_page_view.dart' show HomePageWidget;
export 'views/home/home_page/avata_widget.dart' show Avata;
//mypage
export 'views/home/mypage/3.1_myPage_Landing_Screen.dart' show MyPageLanding;
export 'views/home/mypage/3.4.2_myPage_foot_Screen.dart' show Footreport;
export 'views/home/mypage/3.2_myPage_Avata_Screen.dart' show Myavata;
export 'views/home/mypage/3.4_myPage_histroy_Screen.dart' show HistoryWidget;
export 'views/home/mypage/3.3_myPage_Modify_info_Screen.dart' show ModiUserInfoWidget;
export 'views/home/mypage/3.5_myPage_Setting_Screen.dart' show MySetting;

export 'views/home/group/No_group/CreateGroup/CreateGroup_CreateCode_view.dart' show CreateCodeWidget;
export 'views/home/group/No_group/No_group_Screen.dart' show NogroupScreen;
export 'views/home/group/Yes_group/Yes_group_Screen.dart' show YesgroupScreen;
export 'views/home/group/No_group/CreateGroup/CreateGroup_NameInput_view.dart' show CreategroupWidget;
export 'views/home/group/group.dart' show GroupWidget;
export 'views/home/group/No_group/JoinGroup/group_info_screen.dart' show GroupInfoScreen;
export 'views/home/group/No_group/CreateGroup/CreateGroup_share_view.dart' show GroupInvitationScreen;
export 'views/home/group/group_setting.dart' show GroupSetting;
export 'views/home/group/No_group/JoinGroup/join_group.dart' show JoingroupWidget;
export 'views/home/group/Wait_group_Screen.dart' show WaitgroupScreen;

export 'views/home/group/Yes_group/settings/ChangeGroupName_screen.dart' show ChangeGroupNamePage;
export 'views/home/group/Yes_group/settings/DeleteGroup_screen.dart' show DeleteGroupPage;
export 'views/home/group/Yes_group/settings/GroupHistory_screen.dart' show GroupHistoryPage;
export 'views/home/group/Yes_group/settings/GroupJoinRequests_screen.dart' show GroupJoinRequestsPage;
export 'views/home/group/Yes_group/settings/Setting_CodeManage.dart' show InvitationCodeManagementPage;
export 'views/home/group/Yes_group/settings/InvitationHistory_screen.dart' show GroupJoinHistory;
export 'views/home/group/Yes_group/settings/MemberManage_screen.dart' show MemberManagementPage;
export 'views/home/group/Yes_group/settings/NotificationSetting_screen.dart' show NotificationSettingsPage;
export 'views/home/group/Yes_group/settings/PublicInfoSettings_screen.dart' show PublicInfoSettingsPage;
export 'views/home/group/Yes_group/settings/Remove_member_screen.dart' show RemoveMemberPage;
export 'views/home/group/Yes_group/settings/changeLeader_screen.dart' show ChangeLeaderPage;

export 'views/home/plan/createSchedule.dart';
export 'views/home/plan/plan.dart' show planWidget;

export 'views/home/scan/Find_blue.dart';
export 'views/home/scan/FootPrintScreen.dart';
export 'views/home/scan/Foot_result.dart';

export 'widgets/App_icon_button.dart';
export 'widgets/BotNav_widget.dart';
export 'widgets/Loding_button_widget.dart';
export 'widgets/custom_input_field_widget.dart';
export 'generated/l10n.dart';

//String mainurl = 'http://3.37.197.238:8080';
String mainurl = 'https://carencoinc.com/kr/service';
//String mainurl = 'https://carencoinc.com/it/service';

//http://203.232.210.68:8080
String version = 'v1.1';
