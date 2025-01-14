import 'package:flutter/material.dart';
import 'package:mwc/index.dart';
import 'package:mwc/utils/Data_Notifire.dart';
import 'package:mwc/utils/service/webrtc/service/webrtc_controller.dart';

class AudioCallView extends StatefulWidget {
  // const AudioCallView({Key? key, required this.controller}) : super(key: key);
  const AudioCallView({Key? key}) : super(key: key);

  @override
  State<AudioCallView> createState() => _AudioCallViewState();
}

class _AudioCallViewState extends State<AudioCallView> {
  // bool isMuted = false;

  @override
  void initState() {
    super.initState();
    AppStateNotifier.instance.userListNotifier.addListener(_updateUserStatus);

    AppStateNotifier.instance.onCloseAudioCall = () {
      context.safePop();
    };
  }

  @override
  void dispose() {
    AppStateNotifier.instance.userListNotifier.removeListener(_updateUserStatus);

    AppStateNotifier.instance..onCloseAudioCall = null;
    super.dispose();
  }

  Future<void> _updateUserStatus() async {
    String oppositeRole = AppStateNotifier.instance.role == 'expert' ? 'client' : 'expert';
    bool isUserOnline = false;
    for (var user in AppStateNotifier.instance.userListNotifier.value) {
      if (user['role'] == oppositeRole) {
        isUserOnline = true;
        break;
      }
    }
    debugPrint("[debug] video isUserOnline : $isUserOnline");

    if (!isUserOnline) {
      await AppStateNotifier.instance.cancelOfferA();
      context.safePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String role = AppStateNotifier.instance.role == 'expert' ? 'John Doe' : 'Liam';
    String url = AppStateNotifier.instance.role == 'expert' ? 'assets/images/profile.jpg' : 'assets/images/train.png';
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(url),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                role,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 50),
              _controlButtons(), // 컨트롤 버튼 위젯 호출
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
            setState(() {
              if (AppStateNotifier.instance.localStream != null) {
                AppStateNotifier.instance.toggleMuteA();
              }
            });
          },
          child: CircleAvatar(
            backgroundColor: AppStateNotifier.instance.isAudioOn ? Colors.green : Colors.red,
            foregroundColor: Colors.white,
            child: Icon(
              AppStateNotifier.instance.isAudioOn ? Icons.mic : Icons.mic_off,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            if (!AppStateNotifier.instance.remoteConnectNotifier.value) {
              await AppStateNotifier.instance.cancelOfferA();
            } else {
              await AppStateNotifier.instance.closeAudioCall();
            }
          },
          child: const CircleAvatar(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: Icon(Icons.call_end),
          ),
        ),
      ],
    );
  }
}
