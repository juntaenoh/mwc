import 'package:mwc/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:mwc/index.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';

class testVision extends StatefulWidget {
  const testVision({Key? key}) : super(key: key);

  @override
  State<testVision> createState() => _testVisionState();
}

class _testVisionState extends State<testVision> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;
  String? _fileSizeString;

  static const int maxFileSize = 1000 * 1024 * 1024; // 1000MB를 바이트 단위로 변환

  Future<void> _captureVideo() async {
    try {
      final pickedFile =
          await _picker.pickVideo(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, maxDuration: const Duration(minutes: 60));

      if (pickedFile != null) {
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = path.join(tempDir.path, 'temp_video.mp4');
        final File tempFile = File(filePath);
        await tempFile.writeAsBytes(await pickedFile.readAsBytes());

        setState(() {
          _videoFile = tempFile;
          _initializeVideoPlayer();
        });

        // 파일 크기 계산 및 표시
        int fileSize = await tempFile.length();
        _fileSizeString = (fileSize / (1024 * 1024)).toStringAsFixed(2) + ' MB';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected ')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void showCustomSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      backgroundColor: AppColors.primary,

      content: Text(
        text,
        style: AppFont.s12.overrides(
          color: AppColors.Black,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 3), // Set the duration to 3 seconds
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _uploadVideo() async {
    print('_uploadVideo');

    if (_videoFile == null) return;

    // 파일 크기 검사
    int fileSize = await _videoFile!.length();
    if (fileSize > maxFileSize) {
      showCustomSnackBar(context, 'The file size exceeds the limit. Please upload a file smaller than 1000MB.');

      return;
    }

    String newPath = path.setExtension(_videoFile!.path, '.mp4');
    File mp4File = _videoFile!.renameSync(newPath);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    String savedVideoPath = path.join(appDocDir.path, 'uploaded_video.mp4');

    final File savedVideoFile = await mp4File.copy(savedVideoPath);
    print('mp4 파일이 로컬에 저장되었습니다: ${savedVideoFile.path}');
    //final result = await Share.shareXFiles([XFile(savedVideoPath)]);

    // if (result.status == ShareResultStatus.success) {
    //   print('Thank you for sharing the picture!');
    // }

    String? uid = AppStateNotifier.instance.testuid;
    var request = http.MultipartRequest('POST', Uri.parse('http://${AppStateNotifier.instance.testurl}/demo/v1/users/$uid/pose'));

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      mp4File.path,
    ));

    try {
      loggerNoStack.t({
        'Name': '_uploadVideo',
        'url': request,
        'video': mp4File.path,
      });
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Upload successful');
        // 응답 본문을 읽어서 JSON 데이터로 변환
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonData = jsonDecode(responseBody);

        // Map에 필요한 값 저장
        Map<String, dynamic> dataMap = {
          'recordId': jsonData['recordId'],
          'measuredDate': jsonData['measuredDate'],
          'measuredTime': jsonData['measuredTime'],
          'angleFace': jsonData['angleFace'],
          'anglePelvis': jsonData['anglePelvis'],
          'angleShoulder': jsonData['angleShoulder'],
          'classType': jsonData['classType'],
          'accuracy': jsonData['accuracy'],
          'imageUrl': jsonData['imageUrl'],
        };

        // Map으로 저장된 데이터를 출력하거나 다른 작업에 사용
        print('Data Map: $dataMap');

        // 추가 작업 (예: 이미지 다운로드)
        if (dataMap['imageUrl'] != null) {
          print('Image URL: ${dataMap['imageUrl']}');
          // 필요 시 이미지 처리 추가 가능
        }

        // 로그 출력 및 추가 작업
        loggerNoStack.i(responseBody);
        AppStateNotifier.instance.UpVisionData(dataMap);

        showCustomDialog(
          context: context,
          backGroundtype: 'black',
          checkButtonColor: AppColors.DarkenGreen,
          titleText: SetLocalizations.of(context).getText('ok_Vision'),
          descriptionText: SetLocalizations.of(context).getText('ok_Vision_Script'),
          upperButtonText: SetLocalizations.of(context).getText('findPasswordButtonConfirmLabel'),
          upperButtonFunction: () async {
            context.pushNamed('testvisionresult', extra: 'tester');
          },
        );
      } else if (response.statusCode == 400) {
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        showCustomSnackBar(context, 'Pose angles are missing. \nPlease upload again!');
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response reason phrase: ${response.reasonPhrase}');
        print('Response headers: ${response.headers}');

        // 응답 본문(body)을 출력합니다.
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        showCustomSnackBar(context, 'Network error has occurred. \nPlease upload again!');
      }
    } catch (e) {
      print('Upload failed with error: $e');
      showCustomSnackBar(context, 'Network error has occurred. \nPlease upload again!');
    }
  }

  void _initializeVideoPlayer() {
    if (_videoFile != null) {
      _videoPlayerController = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  void _removeVideo() {
    setState(() {
      _videoFile = null;
      _fileSizeString = null; // 파일 크기 초기화
    });
  }

  Widget _buildVideoPreview() {
    return _videoPlayerController != null && _videoPlayerController!.value.isInitialized
        ? Stack(
            children: [
              Container(
                height: 300,
                child: AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController!),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: _removeVideo,
                ),
              ),
            ],
          )
        : Container(
            width: double.infinity,
            height: 200,
            color: Colors.black,
            child: Center(
              child: Text(
                'No video recorded',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  Widget _buildCaptureButton(String label) {
    return Container(
      width: double.infinity,
      height: 56.0,
      child: LodingButtonWidget(
        onPressed: _captureVideo,
        text: 'Shoot video',
        options: LodingButtonOptions(
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: AppColors.primaryBackground,
          textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
          elevation: 0,
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Text(SetLocalizations.of(context).getText('ehddutkd'), style: AppFont.s18.overrides(color: AppColors.primaryBackground)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 20),
            if (_videoFile == null) ...[
              Container(
                height: 108,
                width: double.infinity,
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
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Image.asset('assets/images/stv.png'),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Before shooting,\nplease understand!',
                          style: AppFont.b24w,
                        )
                      ],
                    )),
              ),
              SizedBox(height: 20),
              Text(
                '* Please proceed with the video shooting \n  within 5 seconds.\n* It must be photographed from the head to\n  the knee of the subject to be photographed\n  so that it can be accurately measured.',
                style: AppFont.r16.overrides(color: AppColors.Gray300, fontSize: 14),
              ),
              SizedBox(height: 40),
              _buildCaptureButton(SetLocalizations.of(context).getText('dudtkdtjsxor')),
            ],
            if (_videoFile != null) ...[
              Text(
                'file size: $_fileSizeString',
                style: TextStyle(color: Colors.white),
              ),
              _buildVideoPreview(),
              Container(
                width: double.infinity,
                height: 56.0,
                child: LodingButtonWidget(
                  onPressed: _uploadVideo,
                  text: SetLocalizations.of(context).getText('dudtkdjdqhfem'),
                  options: LodingButtonOptions(
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: AppColors.primaryBackground,
                    textStyle: AppFont.s18.overrides(fontSize: 16, color: AppColors.Black),
                    elevation: 0,
                    borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
