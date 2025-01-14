import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:provider/provider.dart';
import 'package:mwc/index.dart';

class UnityWidgetWrapper extends StatefulWidget {
  final double height;
  final int type;
  const UnityWidgetWrapper({Key? key, required this.height, required this.type}) : super(key: key);

  @override
  _UnityWidgetWrapperState createState() => _UnityWidgetWrapperState();
}

class _UnityWidgetWrapperState extends State<UnityWidgetWrapper> {
  UnityWidgetController? _unityWidgetController;
  double _currentValue = 1;
  Offset _startPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;
  double _rotationValue = 0.0;
  bool _isExpanded = false; // 슬라이더와 텍스트가 보이는 상태 여부

  @override
  void initState() {
    super.initState();
    print('UnityWidgetWrapper');
  }

  void onUnityCreated(controller) async {
    print("=================onUnityCreated");
    _unityWidgetController = controller;

    //await Future.delayed(Duration(seconds: 5));

    if (_unityWidgetController != null) {
      int currentClassType = widget.type;
      print(currentClassType);

      await sendObjectType(currentClassType);
      await sendTransparency(1.0);
    } else {
      print("Unity controller is null after initialization delay.");
    }
  }

  void onUnityMessage(message) {
    print('Received message from Unity: $message');
    if (message.toString() == 'UnityInitialized') {}
  }

  Future<void> sendObjectType(int type) async {
    if (_unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'GameObject',
        'OnMessage',
        '{"action": "type", "intValue": $type}',
      );
      print('ObjectManager' + 'OnMessage' + '{"action": "type", "intValue": $type}');
    } else {
      print("sendObjectType: Unity controller is null, message not sent.");
    }
  }

  Future<void> sendTransparency(double alpha) async {
    setState(() {
      _currentValue = alpha;
    });
    print("Transparency value: $alpha");
    if (_unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'GameObject',
        'OnMessage',
        '{"action": "setTransparency", "floatvalue": $alpha}',
      );
    } else {
      print("sendTransparency: Unity controller is null, message not sent.");
    }
  }

  void setRotationValue(double angle) {
    if (_unityWidgetController != null) {
      _unityWidgetController!.postMessage(
        'GameObject',
        'OnMessage',
        '{"action": "angle", "floatvalue": $angle}',
      );
    } else {
      print("setRotationValue: Unity controller is null, message not sent.");
    }
  }

  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      print('Received scene loaded from unity: ${sceneInfo.name}');
      print('Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
    }
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    _unityWidgetController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appStateNotifier, child) {
        bool hasFootdata = true;
        return Container(
          width: MediaQuery.of(context).size.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              if (hasFootdata) ...[
                UnityWidget(
                  onUnityCreated: onUnityCreated,
                  onUnityMessage: onUnityMessage,
                  onUnitySceneLoaded: onUnitySceneLoaded,
                  fullscreen: false,
                  runImmediately: false,
                  unloadOnDispose: true,
                ),
                GestureDetector(
                  onHorizontalDragStart: (details) {
                    _startPosition = details.localPosition;
                  },
                  onHorizontalDragUpdate: (details) {
                    // 드래그한 만큼의 이동을 계산합니다.
                    double deltaX = details.delta.dx;

                    // 현재 회전 값에 이동 값을 누적합니다.
                    setState(() {
                      _rotationValue = (_rotationValue - deltaX) % 360;
                      if (_rotationValue < 0) {
                        _rotationValue += 360;
                      }
                    });

                    setRotationValue(_rotationValue);
                  },
                  onHorizontalDragEnd: (details) {
                    // 드래그가 끝났을 때의 위치로 업데이트합니다.
                    _startPosition = Offset.zero; // 초기화
                  },
                  child: UnityWidget(
                    onUnityCreated: onUnityCreated,
                    onUnityMessage: onUnityMessage,
                    onUnitySceneLoaded: onUnitySceneLoaded,
                    fullscreen: false,
                    runImmediately: false,
                    unloadOnDispose: true,
                  ),
                ),
                Positioned(
                  right: 24,
                  bottom: 160,
                  child: Container(
                    width: 50,
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
                        borderRadius: BorderRadius.circular(24),
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
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          children: [
                            // 애니메이션을 적용할 영역
                            AnimatedSize(
                              duration: Duration(milliseconds: 300), // 크기 변경 애니메이션 지속 시간
                              curve: Curves.easeInOut, // 애니메이션 곡선
                              child: _isExpanded
                                  ? Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          '${(_currentValue * 100).toStringAsFixed(0)}%',
                                          style: AppFont.s12w, // 텍스트 스타일
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          height: 150,
                                          width: 30,
                                          child: RotatedBox(
                                            quarterTurns: -1,
                                            child: SliderTheme(
                                              data: SliderTheme.of(context).copyWith(
                                                thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 10.0, // 슬라이더 핸들 크기
                                                ),
                                                activeTrackColor: Colors.grey, // 활성 선 색상
                                                inactiveTrackColor: Colors.grey, // 비활성 선 색상
                                                overlayColor: Colors.transparent, // 터치 영역 색상
                                                trackHeight: 1.0, // 슬라이더 선 두께
                                                thumbColor: AppColors.primary, // 핸들 색상
                                              ),
                                              child: Slider(
                                                value: _currentValue,
                                                min: 0,
                                                max: 1,
                                                divisions: null,
                                                onChanged: (double value) {
                                                  sendTransparency(value);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(), // 슬라이더와 텍스트가 사라졌을 때
                            ),

                            // SvgPicture를 버튼으로 사용하여 애니메이션 트리거
                            IconButton(
                              iconSize: 24.0,
                              icon: SvgPicture.asset(
                                'assets/icons/transparency.svg',
                                height: 24,
                                width: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isExpanded = !_isExpanded; // 슬라이더 및 텍스트 토글
                                });
                              },
                            ),
                          ],
                        )),
                  ),
                ),
              ],
              if (!hasFootdata) ...[
                Positioned(
                  child: Container(
                    height: widget.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/footsheet.png',
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Container(
                      height: 460,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/images/noavt.png',
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
