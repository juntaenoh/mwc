import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwc/index.dart';
import 'package:mwc/utils/Data_Notifire.dart';
import 'package:mwc/views/home/business/share_detale.dart';
import 'package:mwc/views/home/mypage/widgets/footlist.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showButtons = false;
  bool _showKeyboard = false;

  @override
  void initState() {
    super.initState();
    AppStateNotifier.instance.messagesNotifier.addListener(_updateChat);
    _updateChat();
  }

  @override
  void dispose() {
    AppStateNotifier.instance..messagesNotifier.removeListener(_updateChat);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendDataShareMessage() {
    print('_sendDataShareMessage');
    final message = 'Shared data';
    if (message.isNotEmpty) {
      AppStateNotifier.instance.sendMessage(message);
      _messageController.clear();
    }
  }

  void _navigateToDetailPage() {
    print('_navigateToDetailPage');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => sharereport()),
    );
  }

  void _updateChat() {
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      AppStateNotifier.instance.sendMessage(message);
      _messageController.clear();
    }
  }

  // 플러스 버튼 클릭 시 원형 버튼 표시
  void _toggleButtons() {
    setState(() {
      FocusScope.of(context).unfocus();
      _showButtons = !_showButtons;
      _showKeyboard = !_showKeyboard;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.Black,
      appBar: AppBar(
        backgroundColor: AppColors.Black,
        title: const Text(
          'Chat',
          style: AppFont.b24w,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryBackground),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              // 텍스트 입력 영역 밖을 누르면 키보드와 버튼 모두 숨기기
              setState(() {
                _showButtons = false;
                _showKeyboard = false;
                FocusScope.of(context).unfocus();
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: AppStateNotifier.instance.messagesNotifier.value.length,
                    itemBuilder: (context, index) {
                      final message = AppStateNotifier.instance.messagesNotifier.value[index];
                      final isOwnMessage = message['isOwn'] ?? false;
                      final timestamp = message['timestamp'];
                      final time = DateTime.fromMillisecondsSinceEpoch(timestamp);

                      return Align(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                          child: Container(
                            constraints: BoxConstraints(),
                            child: Row(
                              mainAxisAlignment: !isOwnMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (isOwnMessage)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 5),
                                    child: Text(
                                      '${time.hour}:${time.minute}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.Gray500,
                                      ),
                                    ),
                                  ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: !isOwnMessage ? AppColors.Gray700 : AppColors.primaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: !isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(11.0, 12, 11, 12),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 180, // 최대 너비를 300px로 제한
                                          ),
                                          child: message['message'] == 'Shared data'
                                              ? TextButton(
                                                  onPressed: _navigateToDetailPage, // 클릭 시 상세 페이지로 이동
                                                  child: Text(
                                                    message['message'],
                                                    style: AppFont.s12.overrides(
                                                      fontSize: 16,
                                                      color: !isOwnMessage ? AppColors.primaryBackground : AppColors.Black,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  message['message'],
                                                  softWrap: true, // 텍스트를 자동 줄바꿈 가능하도록 설정
                                                  style: AppFont.s12.overrides(
                                                    fontSize: 16,
                                                    color: !isOwnMessage ? AppColors.primaryBackground : AppColors.Black,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isOwnMessage)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 5),
                                    child: Text(
                                      '${time.hour}:${time.minute}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.Gray500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.Gray700,
                    ),
                    child: Row(
                      children: [
                        if (AppStateNotifier.instance.role != 'expert')
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/icon_plus_24px.svg',
                              colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                            ),
                            onPressed: _toggleButtons, // 플러스 버튼 클릭 시 호출
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your message',
                              hintStyle: TextStyle(color: AppColors.primaryBackground),
                            ),
                            style: const TextStyle(color: AppColors.primaryBackground),
                            minLines: 1,
                            maxLines: null, // 줄바꿈 허용
                            keyboardType: TextInputType.multiline,
                            onTap: () {
                              // 텍스트 필드를 탭했을 때 원형 버튼을 숨기고 키보드 활성화
                              setState(() {
                                _showButtons = false;
                                _showKeyboard = true;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/send.svg',
                            colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                          ),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showKeyboard || _showButtons)
                  SizedBox(
                    height: 280,
                  )
              ],
            ),
          ),
          if (_showKeyboard || _showButtons)
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildButtonRow(), // 플러스 버튼 클릭 시 원형 버튼 표시
            ),
        ],
      ),
    );
  }

  // 원형 버튼을 만드는 함수
  Widget _buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        height: 280,
        color: AppColors.Gray850,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // _buildCircleButton(
              //   icon: Icons.phone,
              //   label: 'Voice call',
              //   onPressed: () {},
              // ),
              // _buildCircleButton(
              //   icon: Icons.video_call,
              //   label: 'Video call',
              //   onPressed: () {},
              // ),
              // _buildCircleButton(
              //   icon: Icons.image,
              //   label: 'Sharing photos',
              //   onPressed: () {},
              // ),
              if (AppStateNotifier.instance.role != 'expert')
                _buildCircleButton(
                    icon: Icons.share,
                    label: 'Sharing data',
                    onPressed: () {
                      showModalBottomSheet(
                        barrierColor: Colors.transparent,
                        isScrollControlled: true,
                        backgroundColor: AppColors.Gray850,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child: FootList(
                                  onSharePressed: () {
                                    _sendDataShareMessage(); // "Shared data" 메시지 보내기
                                    Navigator.of(context).pop(); // 모달 닫기
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.Gray700,
            child: Icon(
              icon,
              color: AppColors.primaryBackground,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.primaryBackground),
        ),
      ],
    );
  }
}
