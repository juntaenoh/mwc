import 'package:mwc/views/TestMode/Tester_Data_1.dart';
import 'package:mwc/views/TestMode/Tester_Menu.dart';
import 'package:mwc/views/TestMode/Tester_Scan.dart';
import 'package:mwc/views/TestMode/Tester_guide.dart';
import 'package:mwc/views/TestMode/test_tos_.dart';
import 'package:mwc/views/TestMode/Tester_vision.dart';
import 'package:mwc/views/TestMode/visionselect.dart';
import 'package:mwc/views/home/camera/video.dart';
import 'package:mwc/views/home/camera/vision.dart';
import 'package:mwc/views/home/group/No_group/CreateGroup/CreateGroup_CreateCode_view.dart';
import 'package:mwc/views/home/group/Yes_group/settings/Change_Leader.dart';
import 'package:mwc/views/home/mypage/Settings/Setting_lang.dart';
import 'package:mwc/views/home/mypage/Settings/deviceCalibration.dart';
import 'package:mwc/views/home/mypage/Settings/deviceManage_screen.dart';
import 'package:mwc/views/home/scan/Foot_detail.dart';
import 'package:mwc/views/landingScreen.dart';
import 'package:mwc/views/webrtc/audio_call_view.dart';
import 'package:mwc/views/webrtc/chat_view.dart';
import 'package:mwc/views/webrtc/video_call_view.dart';

import '/index.dart';
export 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

const kTransitionInfoKey = '__transition_info__';

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
        initialLocation: '/',
        debugLogDiagnostics: true,
        refreshListenable: appStateNotifier,
        redirect: (context, state) {
          return null;
        },
        routes: <RouteBase>[
          GoRoute(
              name: 'LandingScreen',
              path: '/',
              builder: (context, state) {
                return LandingScreen();
              },
              routes: [
                GoRoute(
                    name: 'Test_guide',
                    path: 'Test_guide',
                    builder: (context, state) {
                      return TesterGuide();
                    },
                    routes: [
                      GoRoute(
                          name: 'TestTos',
                          path: 'TestTos',
                          builder: (context, state) {
                            return TestTos();
                          },
                          routes: [
                            GoRoute(
                                name: 'Tester_GetData1',
                                path: 'Tester_GetData1',
                                builder: (context, state) {
                                  return TesterData1();
                                },
                                routes: [
                                  GoRoute(
                                      path: 'Teseter_Scan',
                                      name: 'Teseter_Scan',
                                      builder: (context, state) {
                                        return TesterScan();
                                      },
                                      routes: [
                                        GoRoute(
                                            path: 'visionselect',
                                            name: 'visionselect',
                                            builder: (context, state) {
                                              return visionselect();
                                            },
                                            routes: [
                                              GoRoute(
                                                  path: 'vison',
                                                  name: 'vison',
                                                  builder: (context, state) {
                                                    return testVision();
                                                  },
                                                  routes: [
                                                    GoRoute(
                                                        path: 'testvisionresult',
                                                        name: 'testvisionresult',
                                                        builder: (context, state) {
                                                          final mode = state.extra as String;
                                                          return FootResult(
                                                            mode: mode,
                                                          );
                                                        },
                                                        routes: [
                                                          GoRoute(
                                                            path: 'testvisionDetail',
                                                            name: 'testvisionDetail',
                                                            builder: (context, state) {
                                                              final url = state.extra as String;
                                                              return FootDetail(
                                                                url: url,
                                                              );
                                                            },
                                                          ),
                                                        ])
                                                  ]),
                                              GoRoute(
                                                  path: 'testFootresult',
                                                  name: 'testFootresult',
                                                  builder: (context, state) {
                                                    final mode = state.extra as String;

                                                    return FootResult(
                                                      mode: mode,
                                                    );
                                                  },
                                                  routes: [
                                                    GoRoute(
                                                      path: 'testFootDetail',
                                                      name: 'testFootDetail',
                                                      builder: (context, state) {
                                                        final url = state.extra as String;
                                                        return FootDetail(
                                                          url: url,
                                                        );
                                                      },
                                                    ),
                                                  ])
                                            ]),
                                      ]),
                                ])
                          ]),
                    ]),
                GoRoute(
                  name: 'home',
                  path: 'home',
                  builder: (context, state) {
                    return BotNav();
                  },
                  routes: [
                    GoRoute(
                      name: 'video-call',
                      path: 'video-call',
                      builder: (BuildContext context, GoRouterState state) {
                        return VideoCallView();
                      },
                    ),
                    GoRoute(
                      name: 'audio-call',
                      path: 'audio-call',
                      builder: (BuildContext context, GoRouterState state) {
                        return AudioCallView();
                      },
                    ),
                    GoRoute(
                      name: 'chat',
                      path: 'chat',
                      builder: (BuildContext context, GoRouterState state) {
                        return ChatView();
                      },
                    ),
                    GoRoute(
                        name: 'MySetting',
                        path: 'MySetting',
                        builder: (context, state) {
                          return MySetting();
                        },
                        routes: [
                          GoRoute(
                              path: 'DevicerManager',
                              name: 'DevicerManager',
                              builder: (context, state) {
                                return DevicerManagementPage();
                              },
                              routes: [
                                GoRoute(
                                  path: 'DeviceCalibration',
                                  name: 'DeviceCalibration',
                                  builder: (context, state) {
                                    return DeviceCalibration();
                                  },
                                )
                              ]),
                          GoRoute(
                            path: 'SettingLang',
                            name: 'SettingLang',
                            builder: (context, state) {
                              return SettingLang();
                            },
                          )
                        ]),
                    GoRoute(
                        name: 'Modiinfo',
                        path: 'Modiinfo',
                        builder: (context, state) {
                          return ModiUserInfoWidget();
                        },
                        routes: []),
                    GoRoute(
                        name: 'Myavata',
                        path: 'Myavata',
                        builder: (context, state) {
                          return Myavata();
                        },
                        routes: []),
                    GoRoute(
                        name: 'history',
                        path: 'history',
                        builder: (context, state) {
                          return HistoryWidget();
                        },
                        routes: [
                          GoRoute(
                            path: 'FootDetail',
                            name: 'FootDetail',
                            builder: (context, state) {
                              final url = state.extra as String;
                              return FootDetail(
                                url: url,
                              );
                            },
                          ),
                        ]),
                    GoRoute(
                        path: 'visionScan',
                        name: 'visionScan',
                        builder: (context, state) {
                          final mode = state.extra as String;
                          return VisionScan(
                            mode: mode,
                          );
                        },
                        routes: []),
                    GoRoute(
                        path: 'Footprint',
                        name: 'Footprint',
                        builder: (context, state) {
                          final mode = state.extra as String;
                          return FootPrint(
                            mode: mode,
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'Footresult',
                            name: 'Footresult',
                            builder: (context, state) {
                              final mode = state.extra as String;

                              return FootResult(
                                mode: mode,
                              );
                            },
                          )
                        ]),
                    GoRoute(
                      name: 'FindBlue',
                      path: 'FindBlue',
                      builder: (context, state) {
                        final mode = state.extra as String;

                        return FindBlue(
                          mode: mode,
                        );
                      },
                    ),
                    GoRoute(
                      name: 'AddSchedule',
                      path: 'AddSchedule',
                      builder: (context, state) {
                        return AddSchedulePage();
                      },
                    ),
                    GoRoute(
                        name: 'groupSetting',
                        path: 'groupSetting',
                        builder: (context, state) {
                          final Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                          final authority = item['authority'];
                          final groupname = item['groupname'];
                          return GroupSetting(authority: authority, groupname: groupname);
                        },
                        routes: [
                          GoRoute(
                              name: 'MemberManage',
                              path: 'MemberManage',
                              builder: (context, state) {
                                return MemberManagementPage();
                              },
                              routes: [
                                GoRoute(
                                  name: 'Changeleader',
                                  path: 'Changeleader',
                                  builder: (context, state) {
                                    return ChangeLeader();
                                  },
                                ),
                                GoRoute(
                                  name: 'removeMember',
                                  path: 'removeMember',
                                  builder: (context, state) {
                                    return RemoveMemberPage();
                                  },
                                ),
                                GoRoute(
                                  name: 'ChangeLeader',
                                  path: 'ChangeLeader',
                                  builder: (context, state) {
                                    return ChangeLeaderPage();
                                  },
                                ),
                                GoRoute(
                                  name: 'member_GroupJoinRequest',
                                  path: 'member_GroupJoinRequest',
                                  builder: (context, state) {
                                    return GroupJoinRequestsPage();
                                  },
                                ),
                              ]),
                          GoRoute(
                            name: 'GroupJoinRequest',
                            path: 'GroupJoinRequest',
                            builder: (context, state) {
                              return GroupJoinRequestsPage();
                            },
                          ),
                          GoRoute(
                            name: 'ChangeGroupName',
                            path: 'ChangeGroupName',
                            builder: (context, state) {
                              return ChangeGroupNamePage();
                            },
                          ),
                          GoRoute(
                            name: 'InvitationCodeManage',
                            path: 'InvitationCodeManage',
                            builder: (context, state) {
                              return InvitationCodeManagementPage();
                            },
                          ),
                          GoRoute(
                            name: 'DeleteGroup',
                            path: 'DeleteGroup',
                            builder: (context, state) {
                              return DeleteGroupPage();
                            },
                          ),
                          GoRoute(
                            name: 'PublicInfoSetting',
                            path: 'PublicInfoSetting',
                            builder: (context, state) {
                              return PublicInfoSettingsPage();
                            },
                          ),
                          GoRoute(
                            name: 'NotificationSetting',
                            path: 'NotificationSetting',
                            builder: (context, state) {
                              return NotificationSettingsPage();
                            },
                          ),
                          GoRoute(
                            name: 'GroupHistory',
                            path: 'GroupHistory',
                            builder: (context, state) {
                              return GroupHistoryPage();
                            },
                          ),
                        ]),
                    GoRoute(
                        name: 'Creategroup',
                        path: 'Creategroup',
                        builder: (context, state) {
                          return CreategroupWidget();
                        },
                        routes: [
                          GoRoute(
                            name: 'GroupCreatecode',
                            path: 'GroupCreatecode',
                            builder: (context, state) {
                              return GeneratCodeWidget();
                            },
                            routes: [
                              GoRoute(
                                name: 'GroupInvitation',
                                path: 'GroupInvitation',
                                builder: (context, state) {
                                  return GroupInvitationScreen();
                                },
                              )
                            ],
                          ),
                        ]),
                    GoRoute(
                        name: 'Joingroup',
                        path: 'Joingroup',
                        builder: (context, state) {
                          return JoingroupWidget();
                        },
                        routes: [
                          GoRoute(
                            path: 'GroupInfo',
                            name: 'GroupInfo',
                            builder: (context, state) {
                              final Map<String, dynamic> item = state.extra as Map<String, dynamic>;
                              final data = item['data'];
                              final code = item['code'];
                              return GroupInfoScreen(data: data, code: code);
                            },
                          )
                        ])
                  ],
                ),
              ]),
        ]);

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}
