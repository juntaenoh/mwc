import 'package:mwc/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:mwc/index.dart';
import 'package:video_player/video_player.dart';

class VideoUpload extends StatefulWidget {
  const VideoUpload({Key? key}) : super(key: key);

  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  final ImagePicker _picker = ImagePicker();
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;
  String? _fileSizeString;

  static const int maxFileSize = 200 * 1024 * 1024; // 200MB를 바이트 단위로 변환

  Future<void> _captureVideo() async {
    try {
      final pickedFile =
          await _picker.pickVideo(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear, maxDuration: const Duration(minutes: 5));

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
          const SnackBar(content: Text('Nothing is selected')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _uploadVideo() async {
    print('_uploadVideo');

    if (_videoFile == null) return;

    // 파일 크기 검사
    int fileSize = await _videoFile!.length();
    if (fileSize > maxFileSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('영상 크기가 200MB를 초과합니다. 다른 파일을 선택해주세요. 현재 크기: $_fileSizeString')),
      );
      return;
    }

    String newPath = path.setExtension(_videoFile!.path, '.mp4');
    File mp4File = _videoFile!.renameSync(newPath);

    String? uid = AppStateNotifier.instance.testuid;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://carencoinc.com/it/service/test/users/$uid/pose-estimation'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'files',
      mp4File.path,
    ));

    try {
      loggerNoStack.t({
        'Name': '_uploadVideo',
        'url': request,
      });
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Upload successful');
        AppStateNotifier.instance.vid2Up();
        //TODOdi
        showCustomDialog(
          context: context,
          backGroundtype: 'black',
          checkButtonColor: AppColors.DarkenGreen,
          titleText: SetLocalizations.of(context).getText('ok_Vision'),
          descriptionText: SetLocalizations.of(context).getText('ok_Vision_Script'),
          upperButtonText: SetLocalizations.of(context).getText('findPasswordButtonConfirmLabel'),
          upperButtonFunction: () async {
            AppStateNotifier.instance.vid2Up();
            context.goNamed('Tester_menu');
          },
        );
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response reason phrase: ${response.reasonPhrase}');
        print('Response headers: ${response.headers}');

        // 응답 본문(body)을 출력합니다.
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
      }
    } catch (e) {
      print('Upload failed with error: $e');
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
                width: 200,
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
        width: 150,
        height: 86.0,
        child: LodingButtonWidget(
          onPressed: _captureVideo,
          text: label,
          options: LodingButtonOptions(
            height: 40.0,
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: AppColors.Gray700,
            textStyle: AppFont.s18.overrides(
              fontSize: 16,
              color: _videoFile == null ? AppColors.primaryBackground : AppColors.Gray500,
            ),
            elevation: 0,
            borderSide: BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ));
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
        title: Text(SetLocalizations.of(context).getText('ehddutkd'), style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildCaptureButton(SetLocalizations.of(context).getText('dudtkdtjsxor')),
            SizedBox(height: 20),
            // if (_fileSizeString != null)
            //   Text(
            //     '파일 크기: $_fileSizeString',
            //     style: TextStyle(color: Colors.white),
            //   ),
            SizedBox(height: 20),
            _videoFile != null ? _buildVideoPreview() : Container(),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 56.0,
              child: LodingButtonWidget(
                onPressed: _videoFile != null ? _uploadVideo : null,
                text: SetLocalizations.of(context).getText('dudtkdjdqhfem'),
                options: LodingButtonOptions(
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: (_videoFile != null) ? AppColors.primaryBackground : AppColors.Gray700,
                  textStyle: AppFont.s18.overrides(
                    fontSize: 16,
                    color: (_videoFile != null) ? AppColors.Black : AppColors.Gray500,
                  ),
                  elevation: 0,
                  borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
