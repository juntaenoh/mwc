import 'package:mwc/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mwc/utils/Data_Notifire.dart';
import 'package:mwc/utils/service/webrtc/service/webrtc_controller.dart';
import 'package:mwc/views/webrtc/audio_call_view.dart';
import 'package:mwc/views/webrtc/chat_view.dart';
import 'package:mwc/views/webrtc/video_call_view.dart';
import 'package:provider/provider.dart';

class b2bhome extends StatefulWidget {
  const b2bhome({Key? key}) : super(key: key);

  @override
  State<b2bhome> createState() => _b2bhomeState();
}

class _b2bhomeState extends State<b2bhome> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AppStateNotifier appState;

  String? targetUserId;
  String targetRole = "Client";
  String targetStatus = "offline";
  bool showOptions = false;
  bool isTargetInChat = false;
  bool callRequestReceived = false; // 통화 요청 상태를 관리
  BuildContext? popupContext; // 팝업의 BuildContext를 저장

  void initState() {
    super.initState();
    appState = AppStateNotifier.instance;

    appState.userListNotifier.addListener(_updateUserStatus);
    appState.screenNotifier.addListener(_handleCallRequest);
    appState.joinChatRoom();

    _updateUserStatus(); // 상태 업데이트
    // _controller.initController().then((_) {
    //   _controller.initializeUserStatus(); // 상태 초기화
    //   _updateUserStatus(); // 상태 업데이트
    // });
  }

  void dispose() {
    appState.userListNotifier.removeListener(_updateUserStatus);
    appState.screenNotifier.removeListener(_handleCallRequest);
    //appState.dispose();
    popupContext = null;
    super.dispose();
  }

  void _handleCallRequest() {
    if (AppStateNotifier.instance.screenNotifier.value == ScreenState.receivedCalling) {
      setState(() {
        callRequestReceived = true;
        _showCallRequestPopup(); // 팝업 열기
      });
    }
    print("Current targetStatus: $targetStatus");

    if (AppStateNotifier.instance.screenNotifier.value == ScreenState.initDone) {
      setState(() {
        callRequestReceived = false;
        if (mounted && popupContext != null && Navigator.canPop(popupContext!)) {
          Navigator.of(popupContext!).pop();
        }
      });
    }
  }

  void _showCallRequestPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 팝업 외부를 눌러도 닫히지 않도록 설정
      barrierColor: Colors.black.withOpacity(0.5), // 배경 색 (반투명하게 설정)
      transitionDuration: const Duration(milliseconds: 300), // 팝업 애니메이션 시간
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Builder(
          builder: (BuildContext dialogContext) {
            popupContext = dialogContext; // 팝업의 context 저장
            return Scaffold(
              backgroundColor: Colors.transparent, // 팝업 배경 투명
              body: SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(color: AppColors.Black),
                  child: appState.audioOnly ? _buildAudioCallRequestWidget() : _buildVideoCallRequestWidget(),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      popupContext = null;
    });
  }

  void _updateUserStatus() {
    String oppositeRole = AppStateNotifier.instance.role == 'expert' ? 'client' : 'expert';
    bool isUserOnline = false;

    for (var user in AppStateNotifier.instance.userListNotifier.value) {
      debugPrint("[debug] user : $user");
      if (user['role'] == oppositeRole) {
        targetUserId = user['userId']; // 상대방의 userId를 저장
        targetRole = oppositeRole;
        isUserOnline = true;
        isTargetInChat = user['inChat'] ?? false; // inChat 상태 확인
        debugPrint("[debug] TargetUser : $targetUserId");
        break;
      }
      ;
    }
    AppStateNotifier.instance..to = targetUserId;
    setState(() {
      targetStatus = isUserOnline ? "online" : "offline";
      debugPrint("[debug] targetStatus : $targetStatus");
    });
    if (!isUserOnline) {
      appState.screenNotifier.value = ScreenState.initDone;
      _handleCallRequest;
    }
  }

  Widget _buildAudioCallRequestWidget() {
    return Stack(
      children: [
        Positioned(
            left: 10,
            right: 10,
            top: 144,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'John Doe',
                  style: AppFont.b24w,
                )
              ],
            )),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 40,
                width: 240,
                decoration: BoxDecoration(
                  color: AppColors.Black,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get a Call',
                      style: AppFont.s12.overrides(fontSize: 16, color: AppColors.DarkenGreen),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ))),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      appState.refuseAudioOffer();

                      if (popupContext != null) {
                        Navigator.of(popupContext!).pop(); // 팝업 닫기
                      }
                      setState(() {
                        callRequestReceived = false;
                        popupContext = null;
                      });
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/phone-missed.svg",
                      width: 24.0,
                      height: 24.0,
                      colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                ),
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: AppColors.AlertGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      appState.acceptCall('audio');
                      setState(() {
                        callRequestReceived = false;
                        popupContext = null;
                      });
                      _moveToAudioCallView(); // 오디오 통화 화면으로 이동

                      if (popupContext != null) {
                        Navigator.of(popupContext!).pop(); // 팝업 닫기
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/phone-call.svg",
                      width: 24.0,
                      height: 24.0,
                      colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // Widget _buildAudioCallRequestWidget() {
  //   return Container(
  //     color: Colors.yellow[100],
  //     padding: const EdgeInsets.all(10.0),
  //     margin: const EdgeInsets.only(bottom: 20.0),
  //     child: Column(
  //       children: [
  //         const Text(
  //           '음성 통화 요청이 왔습니다',
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //         const Text('수락하시겠습니까?'),
  //         const SizedBox(height: 10),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ElevatedButton.icon(
  //               onPressed: () {
  //                 appState.sendAnswer();
  //                 //_moveToAudioCallView(); // 오디오 통화 화면으로 이동
  //                 setState(() {
  //                   callRequestReceived = false;
  //                 });
  //                 if (popupContext != null) {
  //                   Navigator.of(popupContext!).pop(); // 팝업 닫기
  //                 }
  //               },
  //               icon: const Icon(Icons.check),
  //               label: const Text('수락'),
  //               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
  //             ),
  //             const SizedBox(width: 20),
  //             ElevatedButton.icon(
  //               onPressed: () {
  //                 appState.refuseAudioOffer();
  //                 setState(() {
  //                   callRequestReceived = false;
  //                 });
  //                 if (popupContext != null) {
  //                   Navigator.of(popupContext!).pop(); // 팝업 닫기
  //                 }
  //               },
  //               icon: const Icon(Icons.close),
  //               label: const Text('거절'),
  //               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildVideoCallRequestWidget() {
    return Stack(
      children: [
        Positioned(
            left: 10,
            right: 10,
            top: 0,
            bottom: 150,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.Gray700,
              ),
            )),
        Positioned(
            left: 10,
            right: 10,
            top: 144,
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'John Doe',
                  style: AppFont.b24w,
                )
              ],
            )),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: 40,
                width: 240,
                decoration: BoxDecoration(
                  color: AppColors.Black,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get a Call',
                      style: AppFont.s12.overrides(fontSize: 16, color: AppColors.DarkenGreen),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ))),
        Positioned(
          bottom: 250,
          left: 0,
          right: 0,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: null,
                    child: Container(
                      margin: const EdgeInsets.only(top: 70),
                      height: 32,
                      width: 162,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: AppColors.Gray700,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    )),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      appState.refuseVideoOffer();

                      if (popupContext != null) {
                        Navigator.of(popupContext!).pop(); // 팝업 닫기
                      }
                      setState(() {
                        callRequestReceived = false;
                        popupContext = null;
                      });
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/phone-missed.svg",
                      width: 24.0,
                      height: 24.0,
                      colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                ),
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: AppColors.AlertGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      appState.acceptCall('video');
                      setState(() {
                        callRequestReceived = false;
                        popupContext = null;
                      });
                      _moveToVideoView(); // 비디오 통화 화면으로 이동

                      if (popupContext != null) {
                        Navigator.of(popupContext!).pop(); // 팝업 닫기
                      }
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/phone-call.svg",
                      width: 24.0,
                      height: 24.0,
                      colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _moveToVideoView() {
    context.pushNamed('video-call').whenComplete(() {
      appState.screenNotifier.value = ScreenState.initDone;
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => VideoCallView(),
    //   ),
    // ).whenComplete(() {
    //   appState.screenNotifier.value = ScreenState.initDone;
    // });
  }

  void _moveToAudioCallView() {
    context.pushNamed('audio-call').whenComplete(() {
      appState.screenNotifier.value = ScreenState.initDone;
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => AudioCallView(),
    //   ),
    // ).whenComplete(() {
    //   AppStateNotifier.instance.screenNotifier.value = ScreenState.initDone;
    // });
  }

  void _enterChatRoom(BuildContext context) {
    if (targetUserId != null) {
      AppStateNotifier.instance.to = targetUserId!; // 상대방의 userId를 to에 설정
    }
    context.pushNamed('chat').whenComplete(() {
      appState.screenNotifier.value = ScreenState.initDone;
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => ChatView(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, AppStateNotifier, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.Black,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(98.0),
            child: AppBar(
              elevation: 0,
              titleSpacing: 10,
              backgroundColor: AppColors.Black,
              automaticallyImplyLeading: false,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                child: _buildappheader(context),
              ),
            ),
          ),
          body: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 152,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFCFDFF).withOpacity(0.20),
                            Color(0xFFFCFDFF).withOpacity(0.04),
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
                        padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Visit Today', style: AppFont.s12w),
                                    Text('387', style: AppFont.b24w),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('All memeber', style: AppFont.s12w),
                                        Text('1,124', style: AppFont.b24w),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('New member', style: AppFont.s12w),
                                        Text('+16', style: AppFont.b24w),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 152,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFCFDFF).withOpacity(0.20),
                                  Color(0xFFFCFDFF).withOpacity(0.04),
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
                              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('employee', style: AppFont.s12w),
                                        Text('24', style: AppFont.b24w),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('on holiday', style: AppFont.s12w),
                                        Text('2', style: AppFont.b24w),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            height: 152,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFCFDFF).withOpacity(0.20),
                                  Color(0xFFFCFDFF).withOpacity(0.04),
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
                              padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Sales Status', style: AppFont.s12w),
                                  Text('24%', style: AppFont.b24w),
                                  Text('target:20%', style: AppFont.s12w),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 23,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildappheader(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome!',
            style: AppFont.r16.overrides(color: AppColors.primaryBackground),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'The First Balance Gym',
                style: AppFont.b24.overrides(color: AppColors.primaryBackground),
              ),
              Container(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _enterChatRoom(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/message-circle.svg',
                          width: 24.0,
                          height: 24.0,
                          colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
