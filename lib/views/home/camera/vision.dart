import 'package:mwc/index.dart';
import 'package:mwc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ContentTypeChecker {
  // 서버에서 지원하는 Content-Type 목록
  static final List<String> supportedContentTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
  ];

  // 파일의 MIME 타입을 확인하고, 서버에서 지원하는지 검사하는 함수
  static bool isSupportedContentType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    print(mimeType);
    return mimeType != null && supportedContentTypes.contains(mimeType.toLowerCase());
  }
}

class VisionScan extends StatefulWidget {
  final String mode;
  const VisionScan({Key? key, required this.mode}) : super(key: key);

  @override
  _VisionScanState createState() => _VisionScanState();
}

class _VisionScanState extends State<VisionScan> {
  final ImagePicker _picker = ImagePicker();
  File? _frontImage;
  File? _backImage;
  File? _leftImage;
  File? _rightImage;

  Future<File> _compressImage(File file) async {
    final img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image != null) {
      final img.Image resizedImage = img.copyResize(image, width: 800);
      final Directory tempDir = await getTemporaryDirectory();

      // 원본 파일 이름을 가져오고 확장자를 .jpg로 변경
      final String fileName = path.basenameWithoutExtension(file.path);
      final String newFilePath = path.join(tempDir.path, '$fileName.jpg');

      // JPEG 파일로 저장
      final File compressedFile = File(newFilePath)..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

      print('Original file size: ${file.lengthSync()} bytes');
      print('Compressed file size: ${compressedFile.lengthSync()} bytes');

      return compressedFile;
    } else {
      return file;
    }
  }

  Future<void> _captureImage(String side) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final File tempFile = File(pickedFile.path);
        final File compressedFile = await _compressImage(tempFile);
        //final File compressedFile = tempFile;

        setState(() {
          if (side == 'front') {
            _frontImage = compressedFile;
          } else if (side == 'back') {
            _backImage = compressedFile;
          } else if (side == 'left') {
            _leftImage = compressedFile;
          } else if (side == 'right') {
            _rightImage = compressedFile;
          }
        });
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'camera_access_denied') {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('갤러리 접근 권한 필요'),
        content: Text('이미지 업로드를 위해 갤러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openAppSettings();
            },
            child: Text('설정 열기'),
          ),
        ],
      ),
    );
  }

  void _openAppSettings() async {
    if (Platform.isIOS) {
      final Uri url = Uri.parse('app-settings:');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('설정을 열 수 없습니다.');
      }
    } else if (Platform.isAndroid) {
      final Uri url = Uri.parse('package:${Platform.isAndroid}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('설정을 열 수 없습니다.');
      }
    }
  }

  void _removeImage(String side) {
    setState(() {
      if (side == 'front') {
        _frontImage = null;
      } else if (side == 'back') {
        _backImage = null;
      } else if (side == 'left') {
        _leftImage = null;
      } else if (side == 'right') {
        _rightImage = null;
      }
    });
  }

  void checkFileHeader(String filePath) {
    try {
      if (ContentTypeChecker.isSupportedContentType(filePath)) {
        print('Supported Content-Type');
      } else {
        print('Unsupported Content-Type');
      }
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  MediaType _getMediaType(String mimeType, File file) {
    if (mimeType == 'application/octet-stream') {
      final fileExtension = file.path.split('.').last.toLowerCase();
      if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
        return MediaType('image', 'jpeg');
      } else if (fileExtension == 'png') {
        return MediaType('image', 'png');
      } else {
        throw UnsupportedError('Unsupported file extension: $fileExtension');
      }
    } else {
      return MediaType.parse(mimeType);
    }
  }

  Future<void> _uploadImages() async {
    String linkurl = mainurl;
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$linkurl/users/$uid/pose-estimation'),
    );

    checkFileHeader(_frontImage!.path);
    // MIME 타입 확인 및 설정
    String? frontMimeType = lookupMimeType(_frontImage!.path) ?? 'application/octet-stream';
    String? backMimeType = lookupMimeType(_backImage!.path) ?? 'application/octet-stream';

    // MIME 타입이 application/octet-stream이라면 수동으로 설정
    MediaType frontMediaType;
    MediaType backMediaType;

    frontMediaType = _getMediaType(frontMimeType, _frontImage!);
    backMediaType = _getMediaType(backMimeType, _backImage!);
    request.files.add(await http.MultipartFile.fromPath(
      'file1', _frontImage!.path, contentType: frontMediaType,
      //contentType: MediaType('image', 'jpeg'),
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'file2', _backImage!.path, contentType: backMediaType,
      //contentType: MediaType('image', 'jpeg'),
    ));
    print(_frontImage!.path);
    print(_backImage!.path);
    request.headers.addAll(headers);
    print(request);
    print(request.headers);

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        print('Upload successful');
        print(await response.stream.bytesToString());
//TODOdi
        showCustomDialog(
          context: context,
          backGroundtype: 'black',
          checkButtonColor: AppColors.primary,
          titleText: SetLocalizations.of(context).getText('tkwlsgkdk'),
          descriptionText: SetLocalizations.of(context).getText('rlekfu',
              values: {'name': "${AppStateNotifier.instance.userdata!.firstName} ${AppStateNotifier.instance.userdata!.lastName}"}),
          upperButtonText: SetLocalizations.of(context).getText('popupErrorLoginButtonConfirmLabel'),
          upperButtonFunction: () async {
            context.pushReplacementNamed('home');
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

  Future<void> _uploadtestImages() async {
    print('_uploadtestImages');
    String? uid = AppStateNotifier.instance.testuid;
    String? frontMimeType = lookupMimeType(_frontImage!.path) ?? 'application/octet-stream';
    String? backMimeType = lookupMimeType(_backImage!.path) ?? 'application/octet-stream';
    String? rMimeType = lookupMimeType(_frontImage!.path) ?? 'application/octet-stream';
    String? lMimeType = lookupMimeType(_backImage!.path) ?? 'application/octet-stream';

    // MIME 타입이 application/octet-stream이라면 수동으로 설정
    MediaType frontMediaType;
    MediaType backMediaType;
    MediaType rMediaType;
    MediaType lMediaType;
    frontMediaType = _getMediaType(frontMimeType, _frontImage!);
    backMediaType = _getMediaType(backMimeType, _backImage!);
    rMediaType = _getMediaType(rMimeType, _rightImage!);
    lMediaType = _getMediaType(lMimeType, _leftImage!);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://carencoinc.com/it/service/test/users/$uid/pose-estimation'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'files',
      _frontImage!.path,
      contentType: frontMediaType,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'files',
      _backImage!.path,
      contentType: backMediaType,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'files',
      _leftImage!.path,
      contentType: lMediaType,
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'files',
      _rightImage!.path,
      contentType: rMediaType,
    ));

    try {
      loggerNoStack.t({
        'Name': '_uploadtestImages',
        'url': request,
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Upload successful');
        print(await response.stream.bytesToString());
        AppStateNotifier.instance.cam2Up();
        context.goNamed('Tester_menu');
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

  Widget _buildImagePreview(File? image, String side) {
    return Stack(
      children: [
        Image.file(image!),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () => _removeImage(side),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureButton(String label, String side, File? image) {
    return Expanded(
      child: Container(
          width: 150,
          height: 86.0,
          child: LodingButtonWidget(
            onPressed: () => _captureImage(side),
            text: label,
            options: LodingButtonOptions(
              height: 40.0,
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: AppColors.Gray700,
              textStyle: AppFont.s18.overrides(
                fontSize: 16,
                color: image == null ? AppColors.primaryBackground : AppColors.Gray500,
              ),
              elevation: 0,
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Black,
      appBar: AppBar(
        leading: AppIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.chevron_left,
            color: AppColors.primaryBackground,
            size: 30,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        backgroundColor: AppColors.Black,
        title: Text(
          SetLocalizations.of(context).getText('uploadimage'),
          style: AppFont.s18.overrides(color: AppColors.primaryBackground),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCaptureButton(SetLocalizations.of(context).getText('reportPlantarPressureDetailPainButtonFrontLabel'), 'front', _frontImage),
                SizedBox(width: 20),
                _buildCaptureButton(SetLocalizations.of(context).getText('reportPlantarPressureDetailPainButtonBackLabel'), 'back', _backImage),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCaptureButton(SetLocalizations.of(context).getText('reportPlantarPressureDetailPainButtonLSideLabel'), 'left', _leftImage),
                SizedBox(width: 20),
                _buildCaptureButton(SetLocalizations.of(context).getText('reportPlantarPressureDetailPainButtonRSideLabel'), 'right', _rightImage),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(SetLocalizations.of(context).getText('checkimage'), style: TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  _frontImage != null ? _buildImagePreview(_frontImage, 'front') : Container(),
                  _backImage != null ? _buildImagePreview(_backImage, 'back') : Container(),
                  _leftImage != null ? _buildImagePreview(_leftImage, 'left') : Container(),
                  _rightImage != null ? _buildImagePreview(_rightImage, 'right') : Container(),
                ],
              ),
            ),
            Container(
                width: double.infinity,
                height: 56.0,
                child: LodingButtonWidget(
                  onPressed: (_frontImage != null && _backImage != null && _leftImage != null && _rightImage != null)
                      ? (widget.mode == 'main')
                          ? _uploadImages
                          : _uploadtestImages
                      : null,
                  text: SetLocalizations.of(context).getText('uploadimage'),
                  options: LodingButtonOptions(
                    height: 40.0,
                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: (_frontImage != null && _backImage != null && _leftImage != null && _rightImage != null)
                        ? AppColors.primaryBackground
                        : AppColors.Gray700,
                    textStyle: AppFont.s18.overrides(
                      fontSize: 16,
                      color: (_frontImage != null && _backImage != null && _leftImage != null && _rightImage != null)
                          ? AppColors.Black
                          : AppColors.Gray500,
                    ),
                    elevation: 0,
                    borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
