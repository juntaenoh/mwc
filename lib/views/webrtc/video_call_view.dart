import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mwc/index.dart';
import 'package:mwc/utils/Data_Notifire.dart';
import 'package:mwc/utils/service/webrtc/model/drawing_point.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:mwc/views/home/mypage/widgets/footlist.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({Key? key}) : super(key: key);

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  final ValueNotifier<bool> _btnNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _colorPickerNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<Color?> _selectedColorNotifier = ValueNotifier<Color?>(null);
  int imageIndex = 1;

  Size? _imageSize;
  final GlobalKey _imageKey = GlobalKey();
  List<DrawingPoint> points = [];
  bool _isImageLoaded = false;

  ui.Image? _cachedImage;
  String? _cachedImagePath;
  bool _isshare = false;
  String targetStatus = "offline";

  @override
  void initState() {
    super.initState();
    AppStateNotifier.instance.userListNotifier.addListener(_updateUserStatus);

    AppStateNotifier.instance.drawingGroupsNotifier.addListener(_updateDrawing);

    AppStateNotifier.instance.imageNumberNotifier.addListener(_resetImageState);
    AppStateNotifier.instance.isDrawNotifier.addListener(_resetImageState);

    AppStateNotifier.instance.onCloseVideoCall = () {
      context.safePop();
    };
  }

  @override
  void dispose() {
    AppStateNotifier.instance.userListNotifier.removeListener(_updateUserStatus);

    AppStateNotifier.instance.drawingGroupsNotifier.removeListener(_updateDrawing);
    AppStateNotifier.instance.imageNumberNotifier.removeListener(_resetImageState);
    AppStateNotifier.instance.isDrawNotifier.removeListener(_resetImageState);

    _btnNotifier.dispose();
    _colorPickerNotifier.dispose();
    _selectedColorNotifier.dispose();

    AppStateNotifier.instance.onCloseVideoCall = null;
    _isImageLoaded = false;
    _imageSize = null;
    _cachedImage = null;
    _cachedImagePath = null;

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
    setState(() {
      targetStatus = isUserOnline ? "online" : "offline";
    });
    if (!isUserOnline) {
      await AppStateNotifier.instance.cancelOfferV();
      context.safePop();
    }
  }

  void _updateDrawing() {
    setState(() {
      points = AppStateNotifier.instance.drawingGroupsNotifier.value.expand((group) => group.points).toList();
    });
  }

  void _resetImageState() {
    setState(() {
      _isImageLoaded = false;
      _imageSize = null;
      _cachedImage = null;
      _cachedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.Black,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _sharedImageCanvas(),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey, // 회색 박스
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          imageIndex = (imageIndex + 1) % 4;
                        });
                        AppStateNotifier.instance.sendImageLoad(imageIndex + 1);
                      },
                      icon: Icon(
                        Icons.arrow_drop_up_outlined,
                        color: Colors.white, // 아이콘을 흰색으로 설정
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 80,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey, // 회색 박스
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          imageIndex = (imageIndex == 0) ? 3 : imageIndex - 1;
                        });
                        AppStateNotifier.instance.sendImageLoad(imageIndex + 1);
                      },
                      icon: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: Colors.white, // 아이콘을 흰색으로 설정
                      ),
                    ),
                  ),
                ),
                remoteRenderer(AppStateNotifier.instance.isDrawNotifier),
                // Align(
                //     alignment: Alignment.topCenter,
                //     child: Container(
                //         height: 35,
                //         width: 240,
                //         decoration: BoxDecoration(
                //           color: AppColors.Black,
                //           borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                //         ),
                //         child: Center(
                //           child: Padding(
                //             padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Text(
                //                   'name',
                //                   style: AppFont.s12.overrides(fontSize: 16, color: AppColors.primaryBackground),
                //                 ),
                //                 Text(
                //                   'sharing',
                //                   style: AppFont.s12.overrides(fontSize: 16, color: AppColors.DarkenGreen),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ))),
                GestureDetector(
                  onPanUpdate: AppStateNotifier.instance.role == 'expert'
                      ? (details) async {
                          if (AppStateNotifier.instance.currentColor != null && _imageSize != null) {
                            final RenderBox? box = context.findRenderObject() as RenderBox?;
                            if (box != null) {
                              final localPosition = box.globalToLocal(details.globalPosition);

                              final double screenWidth = box.size.width; // 화면 너비
                              final double screenHeight = box.size.height; // 화면 높이
                              final double imageAspectRatio = 9 / 16;

                              // 이미지가 화면 너비에 맞춰 확장되었으므로, 이미지 비율을 유지하여 높이 계산
                              double imageWidth = screenWidth; // 화면 너비로 이미지 너비 고정
                              double imageHeight = imageWidth / imageAspectRatio; // 이미지 비율에 맞춰 높이 계산

                              // 세로가 작은 이미지를 처리하기 위해 높이가 화면을 넘지 않도록 조정
                              if (imageHeight > screenHeight - 180) {
                                // 하단 180px 간격 유지
                                imageHeight = screenHeight - 180;
                              }

                              // 상하 여백 계산 (이미지가 작으면 남는 공간을 중앙에 배치)
                              final double topOffset = (screenHeight - imageHeight - 180) / 2;

                              // 터치 좌표를 이미지 좌표로 변환 (화면 비율을 고려)
                              final double dx = localPosition.dx / imageWidth;
                              final double dy = (localPosition.dy - topOffset) / imageHeight;

                              // 이미지 영역 내에 있는지 확인 후 그림을 그리기
                              if (dx >= 0 && dx <= 1 && dy >= 0 && dy <= 1) {
                                final normalizedPoint = Offset(dx, dy);
                                await AppStateNotifier.instance.sendDrawing(normalizedPoint);
                              }
                            }
                          }
                        }
                      : null,
                  onPanEnd: AppStateNotifier.instance.role == 'expert'
                      ? (details) async {
                          if (AppStateNotifier.instance.currentColor != null) {
                            await AppStateNotifier.instance.sendDrawingEnd();
                          }
                        }
                      : null,
                ),

                localRenderer(AppStateNotifier.instance.isDrawNotifier),
                _controlButtons(),
                _colorPickerWidget(),
              ],
            )),
      ),
    );
  }

  Widget remoteRenderer(ValueNotifier<bool> listener) {
    return ValueListenableBuilder<bool>(
      valueListenable: listener,
      builder: (_, value, __) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: value ? 24 : 10,
              right: value ? null : 10,
              top: value ? 40 : 0,
              bottom: value ? null : 150,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: value ? 80 : MediaQuery.of(context).size.width,
                height: value ? 132 : MediaQuery.of(context).size.height - 150,
                child: _videoWidget(AppStateNotifier.instance.remoteVideoNotifier, AppStateNotifier.instance.remoteRenderer!, 'remote'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget localRenderer(ValueNotifier<bool> listener) {
    return ValueListenableBuilder<bool>(
      valueListenable: listener,
      builder: (_, value, __) {
        return Stack(
          children: [
            Positioned(
              right: 24,
              bottom: 160,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: value ? 80 : 100,
                height: value ? 132 : 168,
                child: _videoWidget(AppStateNotifier.instance.localVideoNotifier, AppStateNotifier.instance.localRenderer!, 'local'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _videoWidget(ValueNotifier<bool> listener, RTCVideoRenderer renderer, String type) {
    String role = AppStateNotifier.instance.role == 'expert' ? 'John Doe' : 'Liam';
    String url = AppStateNotifier.instance.role == 'expert' ? 'assets/images/profile.jpg' : 'assets/images/train.png';
    return ValueListenableBuilder<bool>(
      valueListenable: listener,
      builder: (_, value, __) {
        return value
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: RTCVideoView(
                  renderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              )
            : type == 'local'
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.Gray700,
                    ),
                  )
                : Center(
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
                      ],
                    ),
                  );
      },
    );
  }

  Widget _controlButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (AppStateNotifier.instance.localStream != null) {
                    AppStateNotifier.instance.toggleMuteV();
                  }
                });
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFCFDFF).withOpacity(0.20),
                      Color(0xFFFCFDFF).withOpacity(0.04),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: SvgPicture.asset(
                  AppStateNotifier.instance.isAudioOn ? 'assets/icons/mic.svg' : 'assets/icons/mic-off.svg',
                  width: 24.0,
                  height: 24.0,
                  colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                )),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (AppStateNotifier.instance.checkStream()) {
                  setState(() {
                    AppStateNotifier.instance.toggleVideo();
                  });
                }
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFCFDFF).withOpacity(0.20),
                      Color(0xFFFCFDFF).withOpacity(0.04),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: SvgPicture.asset(
                  AppStateNotifier.instance.isVideoOn ? 'assets/icons/video.svg' : 'assets/icons/video-off.svg',
                  width: 24.0,
                  height: 24.0,
                  colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                )),
              ),
            ),
            AppStateNotifier.instance.role == 'expert'
                ? GestureDetector(
                    onTap: () {
                      _colorPickerNotifier.value = !_colorPickerNotifier.value;
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFCFDFF).withOpacity(0.20),
                            Color(0xFFFCFDFF).withOpacity(0.04),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: SvgPicture.asset(
                        'assets/icons/edit-2.svg',
                        width: 24.0,
                        height: 24.0,
                        colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                      )),
                    ),
                  )
                : !_isshare
                    ? GestureDetector(
                        onTap: () {
                          _showImageSelectionOptions();
                        },
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFCFDFF).withOpacity(0.20),
                                Color(0xFFFCFDFF).withOpacity(0.04),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/icons/share.svg',
                            width: 24.0,
                            height: 24.0,
                            colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                          )),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          showCustomDialog(
                              backGroundtype: 'white',
                              context: context,
                              checkButtonColor: AppColors.Black,
                              titleText: 'Stop sharing data',
                              descriptionText: '2023.9. 30 Will we stop sharing data for measurement reports?\nNew data can be shared.',
                              upperButtonText: 'Stop sharing',
                              upperButtonFunction: () {
                                setState(() {
                                  _isshare = false;
                                });
                                AppStateNotifier.instance.sendstateLoad(0);
                                context.safePop();
                              },
                              lowerButtonText: 'Cancel',
                              lowerButtonFunction: () {
                                context.safePop();
                              });
                        },
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                            'assets/icons/share.svg',
                            width: 24.0,
                            height: 24.0,
                            colorFilter: ColorFilter.mode(AppColors.Black, BlendMode.srcIn),
                          )),
                        ),
                      ),
            GestureDetector(
              onTap: () async {
                if (!AppStateNotifier.instance.remoteConnectNotifier.value) {
                  await AppStateNotifier.instance.cancelOfferV();
                } else {
                  await AppStateNotifier.instance.closeVideoCall();
                }
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: SvgPicture.asset(
                  'assets/icons/phone-missed.svg',
                  width: 24.0,
                  height: 24.0,
                  colorFilter: ColorFilter.mode(AppColors.primaryBackground, BlendMode.srcIn),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 선택 시 이미지 로드 및 서버로 신호 전송
  void _showImageSelectionOptions() {
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
                  setState(() {
                    _isshare = !_isshare;
                  });
                  AppStateNotifier.instance.sendImageLoad(1);
                  AppStateNotifier.instance.sendstateLoad(1);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Container(
    //       decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(12)), color: AppColors.primaryBackground),
    //       padding: const EdgeInsets.all(20.0),
    //       height: 150,
    //       child: Column(
    //         children: [
    //           Text('Choose an image to share', style: AppFont.s12w),
    //           const SizedBox(height: 10),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               GestureDetector(
    //                 onTap: () {
    //                   _isImageLoaded = false;
    //                   AppStateNotifier.instance.sendImageLoad(1); // 서버로 신호 전송
    //                   AppStateNotifier.instance.sendstateLoad(1);
    //                   _updateDrawing();

    //                   Navigator.pop(context);
    //                 },
    //                 child: Container(
    //                   width: 100,
    //                   height: 54,
    //                   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: AppColors.Black),
    //                   child: Center(
    //                       child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       'Foot Print',
    //                       style: AppFont.s12w.overrides(color: AppColors.primaryBackground),
    //                     ),
    //                   )),
    //                 ),
    //               ),
    //               GestureDetector(
    //                 onTap: () {
    //                   _isImageLoaded = false;
    //                   AppStateNotifier.instance.sendImageLoad(2); // 서버로 신호 전송
    //                   AppStateNotifier.instance.sendstateLoad(1);

    //                   _updateDrawing();

    //                   Navigator.pop(context);
    //                 },
    //                 child: Container(
    //                   width: 100,
    //                   height: 54,
    //                   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: AppColors.Black),
    //                   child: Center(
    //                       child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       'Body print',
    //                       style: AppFont.s12w.overrides(color: AppColors.primaryBackground),
    //                     ),
    //                   )),
    //                 ),
    //               ),
    //               GestureDetector(
    //                 onTap: () {
    //                   AppStateNotifier.instance.sendstateLoad(0);
    //                   Navigator.pop(context);
    //                 },
    //                 child: Container(
    //                   width: 100,
    //                   height: 54,
    //                   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: AppColors.red),
    //                   child: Center(
    //                       child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       'stop share',
    //                       style: AppFont.s12w.overrides(color: AppColors.primaryBackground),
    //                     ),
    //                   )),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  void _updateImageRect(double imageWidth, double imageHeight) {
    if (imageHeight == 359.0) {
      imageHeight = 532.0;
    }

    setState(() {
      _imageSize = Size(imageWidth, imageHeight);
    });
  }

  Widget _buildImageCanvas(ui.Image image, String imagePath) {
    final double imageAspectRatio = 9 / 16;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final double maxHeight = constraints.maxHeight;

          // 화면 너비 그대로 사용
          double imageWidth = maxWidth;
          double imageHeight = imageWidth / imageAspectRatio;

          // 이미지 높이가 화면을 넘지 않게 하고, 하단 180px 간격 유지
          if (imageHeight > maxHeight - 180) {
            imageHeight = maxHeight - 180;
          }

          // 이미지가 로드된 후 이미지 크기 설정
          if (!_isImageLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateImageRect(imageWidth, imageHeight);
            });
            _isImageLoaded = true;
          }

          return Stack(
            children: [
              // 이미지 배치, 화면 너비는 그대로 사용하고, 높이만 비율에 맞게 설정
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 180, // 하단 간격 180px 유지
                child: Container(
                  child: Image(
                    key: _imageKey,
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain, // 비율에 맞춰 높이 조정
                    width: imageWidth, // 너비는 화면 너비 그대로
                    height: imageHeight,
                  ),
                ),
              ),
              if (_imageSize != null)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 180, // 하단 간격 180px 유지
                  child: Container(
                    child: CustomPaint(
                      size: Size(imageWidth, imageHeight), // 이미지 사이즈에 맞게 그리기
                      painter: LinePainter(
                        AppStateNotifier.instance.drawingGroupsNotifier.value,
                        Size(imageWidth, imageHeight),
                        AppStateNotifier.instance.imageNumberNotifier.value,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = Uint8List.view(data.buffer);
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(bytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Widget _sharedImageCanvas() {
    return ValueListenableBuilder<int>(
      valueListenable: AppStateNotifier.instance.imageNumberNotifier,
      builder: (context, imageNumber, child) {
        String? imagePath;
        if (imageNumber == 1) {
          imagePath = 'assets/images/ex.png';
        } else if (imageNumber == 2) {
          imagePath = 'assets/bodygrapic/back/male/front.png';
        } else if (imageNumber == 3) {
          imagePath = 'assets/bodygrapic/back/male/back.png';
        } else if (imageNumber == 4) {
          imagePath = 'assets/bodygrapic/back/male/side.png';
        }

        if (imagePath == null) {
          return const SizedBox();
        }

        final String nonNullImagePath = imagePath;

        // 캐시된 이미지가 있는지 확인
        if (_cachedImage != null && _cachedImagePath == nonNullImagePath) {
          // 캐시된 이미지 사용
          return _buildImageCanvas(_cachedImage!, nonNullImagePath);
        }

        // 이미지 로드
        return FutureBuilder<ui.Image>(
          future: _loadImage(nonNullImagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final ui.Image image = snapshot.data!;
              // 이미지 캐시
              _cachedImage = image;
              _cachedImagePath = nonNullImagePath;

              return _buildImageCanvas(image, nonNullImagePath);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  Widget _colorPickerWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: _colorPickerNotifier,
      builder: (_, visible, __) => visible
          ? Positioned(
              bottom: 110,
              left: 40,
              right: 40,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColors.Gray700,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _undoButton(),
                      _colorButton(Colors.red),
                      _colorButton(Colors.white),
                      _colorButton(Colors.black),
                      _colorButton(const Color(0xFFB4BED9)),
                      _resetButton(),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _undoButton() {
    return GestureDetector(
      onTap: () async {
        await AppStateNotifier.instance.undoLastDrawing();
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: AppColors.Gray300, shape: BoxShape.circle),
        child: Center(
            child: SvgPicture.asset(
          'assets/icons/corner-up-left.svg',
          width: 20.0,
          height: 20.0,
          colorFilter: ColorFilter.mode(AppColors.Black, BlendMode.srcIn),
        )),
      ),
    );
  }

  Widget _resetButton() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          points.clear();
        });
        AppStateNotifier.instance.sendClearDrawing();
      },
      child: Container(
        width: 72,
        height: 28,
        decoration: BoxDecoration(color: AppColors.primaryBackground, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          'Clear All',
          style: AppFont.s12.overrides(color: AppColors.Black),
        )),
      ),
    );
  }

  Widget _colorButton(Color color) {
    return ValueListenableBuilder<Color?>(
      valueListenable: _selectedColorNotifier,
      builder: (_, selectedColor, __) {
        return InkWell(
          onTap: () {
            _selectedColorNotifier.value = color;
            AppStateNotifier.instance.setDrawingColor(color); // 서버에 색상 전송
          },
          child: CircleAvatar(
              backgroundColor: color,
              radius: 14,
              child: selectedColor == color
                  ? selectedColor == Colors.white
                      ? Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        )
                  : null),
        );
      },
    );
  }
}

class LinePainter extends CustomPainter {
  final List<DrawingGroup> groups;
  final Size imageSize;
  final int currentImageNumber;

  LinePainter(this.groups, this.imageSize, this.currentImageNumber);

  @override
  void paint(Canvas canvas, Size size) {
    final relevantGroups = groups.where((group) => group.imageNumber == currentImageNumber);

    for (var group in relevantGroups) {
      final paint = Paint()
        ..color = group.color
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < group.points.length - 1; i++) {
        final p1 = group.points[i].point;
        final p2 = group.points[i + 1].point;

        if (p1 != null && p2 != null) {
          final point1 = Offset(
            p1.dx * imageSize.width,
            p1.dy * imageSize.height,
          );
          final point2 = Offset(
            p2.dx * imageSize.width,
            p2.dy * imageSize.height,
          );
          canvas.drawLine(point1, point2, paint);
        } else if (p1 != null && p2 == null) {
          final point = Offset(
            p1.dx * imageSize.width,
            p1.dy * imageSize.height,
          );
          canvas.drawPoints(ui.PointMode.points, [point], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
