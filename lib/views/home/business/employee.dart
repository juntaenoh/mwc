import 'package:mwc/index.dart';
import 'package:flutter/material.dart';
import 'package:mwc/utils/service/webrtc/service/webrtc_controller.dart';
import 'package:mwc/views/webrtc/audio_call_view.dart';
import 'package:mwc/views/webrtc/chat_view.dart';
import 'package:mwc/views/webrtc/video_call_view.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class employeeview extends StatefulWidget {
  final Map employees;
  const employeeview({Key? key, required this.employees}) : super(key: key);

  @override
  State<employeeview> createState() => _employeeState();
}

class _employeeState extends State<employeeview> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  Map? employee;
  String? targetUserId;
  String targetRole = "expert";
  String targetStatus = "offline";
  bool showOptions = false;
  bool isTargetInChat = false;
  bool callRequestReceived = false; // 통화 요청 상태를 관리
  late AppStateNotifier appState;

  @override
  void initState() {
    super.initState();
    appState = AppStateNotifier.instance;

    appState.userListNotifier.addListener(_updateUserStatus);
    appState.screenNotifier.addListener(_handleCallRequest); // 통화 요청 처리
    appState.joinChatRoom();

    _updateUserStatus(); // 상태 업데이트
    // _controller.initController().then((_) {
    //   _controller.initializeUserStatus(); // 상태 초기화
    //   _updateUserStatus(); // 상태 업데이트
    // });
    getCompanies();
  }

  void dispose() {
    appState.userListNotifier.removeListener(_updateUserStatus);
    appState.screenNotifier.removeListener(_handleCallRequest);
    super.dispose();
  }

  void _handleCallRequest() {
    if (AppStateNotifier.instance.screenNotifier.value == ScreenState.initDone) {
      setState(() {
        callRequestReceived = false;
      });
    }
  }

  void _updateUserStatus() {
    String oppositeRole = AppStateNotifier.instance.role == 'expert' ? 'client' : 'expert';
    bool isUserOnline = false;

    for (var user in AppStateNotifier.instance.userListNotifier.value) {
      if (user['role'] == oppositeRole) {
        targetUserId = user['userId']; // 상대방의 userId를 저장
        targetRole = oppositeRole;
        isUserOnline = true;
        isTargetInChat = user['inChat'] ?? false; // inChat 상태 확인
        break;
      }
    }
    debugPrint("[debug] TargetUser : $targetUserId");
    AppStateNotifier.instance.to = targetUserId;

    setState(() {
      targetStatus = isUserOnline ? "online" : "offline";
    });
  }

  Future<void> getCompanies() async {
    setState(() {
      isLoading = true;
    });

    String comid = widget.employees['employeeId'];
    final url = Uri.parse('http://${AppStateNotifier.instance.testurl}/demo/v1/btob/employees/$comid');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map jsonResponse = jsonDecode(response.body);
      setState(() {
        employee = jsonResponse;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load company details');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // 로딩 상태 표시
      );
    }

    // company 데이터가 null인 경우
    if (employee == null) {
      return Scaffold(
        body: Center(child: Text('No company data available')), // 데이터가 없을 때
      );
    }
    return Consumer<AppStateNotifier>(
      builder: (context, AppStateNotifier, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.Black,
          appBar: AppBar(
            title: Row(
              children: [
                Text('Trainer Profile', style: AppFont.s12.overrides(color: AppColors.primaryBackground, fontSize: 18)),
              ],
            ),
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: AppColors.primaryBackground),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(),
                SizedBox(height: 16),
                _buildCallActions(),
                SizedBox(height: 60),
                _buildPersonalHistory(employee!['careerList']),
                SizedBox(height: 24),
                _buildPhotosSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(radius: 40, backgroundImage: NetworkImage(employee!['mainPhotoUrl']) // 여기에 실제 프로필 이미지 URL
            ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee!['employeeName'], style: AppFont.b24w),
              Text('${employee!['employeePosition']} | ${employee!['employeeInfo']}',
                  style: AppFont.r16.overrides(fontSize: 12, color: AppColors.Gray300)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCallActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOptionButton(
            icon: 'assets/icons/phone-call.svg',
            onPressed: () {
              if (targetUserId != null) {
                AppStateNotifier.instance.to = targetUserId!;
                AppStateNotifier.instance.sendCall("audio");
                _moveToAudioCallView();
              }
            },
            text: 'Voice call'),
        _buildOptionButton(
            icon: 'assets/icons/video.svg',
            onPressed: () {
              if (targetUserId != null) {
                AppStateNotifier.instance.to = targetUserId!;
                AppStateNotifier.instance.sendCall("video");

                _moveToVideoView();
              }
            },
            text: 'Video call'),
        _buildOptionButton(
            icon: 'assets/icons/message-circle.svg',
            onPressed: () {
              _enterChatRoom(context);
            },
            text: 'Chatting'),
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

  Widget _buildOptionButton({required String icon, required VoidCallback onPressed, required String text}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 32,
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: AppColors.Gray850),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 20, colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn)),
            SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: AppFont.s12w.overrides(color: AppColors.primaryBackground),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalHistory(List<dynamic> careerList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Personal history', style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.Gray700,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: careerList.map<Widget>((career) {
              return Text(
                '• ${career['careerDetail']}',
                style: TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photos', style: AppFont.s18.overrides(fontSize: 16, color: AppColors.primaryBackground)),
        SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 사진을 3개씩 보여주는 그리드
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: 3, // 사진 갯수
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey,
              child: Image.network(
                employee!['photoUrl${index + 1}'], // 이미지 URL
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildappheader(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Trainer',
            style: AppFont.s18.overrides(color: AppColors.primaryBackground),
          ),
          Icon(Icons.close)
        ],
      ),
    );
  }
}
