import 'package:mwc/index.dart';
import 'package:mwc/main.dart';
import 'package:mwc/models/Code.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/models/GroupData.dart';
import 'package:mwc/models/GroupHistory.dart';
import 'package:mwc/models/GroupInvitation.dart';
import 'package:mwc/models/Schedule.dart';
import 'package:mwc/models/UserData.dart';
import 'package:mwc/models/WeightData.dart';
import 'package:mwc/models/testuser.dart';
import 'package:mwc/utils/service/Foot_Controller.dart';
import 'package:flutter/material.dart';
import 'package:mwc/utils/service/webrtc/service/webrtc_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mwc/utils/service/webrtc/model/drawing_point.dart';
import 'package:mwc/utils/service/webrtc/model/icecandidate_model.dart';
import 'package:mwc/utils/service/webrtc/model/webrtc_model.dart';
import 'package:mwc/utils/service/webrtc/service/webrtc_socket.dart';

import 'package:vibration/vibration.dart';

class AppStateNotifier extends WebRTCSocket with ChangeNotifier {
  AppStateNotifier._();
  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();
  bool showSplashImage = true;
  String? _token;
  String? _firebasetoken;
  String? _retoken;
  DateTime? _expiresIn;
  String? _testuid;
  String? _type;
  bool _testdivice2 = false;
  bool _cam = false;
  bool _vid = false;
  bool _datalod = true;
  String _testurl = '15.165.125.100:8085';
  String _server = '';

  UserData? _userdata;
  TestUser? _TestUser;

  List<FootData>? _footdata;
  List<WeightData>? _WeightData;
  List<GroupHistory>? _groupHistory;
  List<Invitation>? _GroupInvitation;
  GroupTicket? _GroupTicket;

  String _device = '';
  Map<String, dynamic>? _Scandata;
  Map<String, dynamic>? _Visiondata;

  List<GroupData>? _groupData;
  String? _myAuthority;
  String? _mymemberId;
  List<ScheduleData>? _scheduleData;
  List<DateTime>? _targetdata;
  String? _verificationId;

  String _test = 'Default';

  //-------------//
  String get test => _test;
  String? get apiToken => _token;
  String? get firebaseToken => _firebasetoken;
  String? get reToken => _retoken;
  DateTime? get expiresIn => _expiresIn;
  String? get testuid => _testuid;
  String? get type => _type;
  bool get datalod => _datalod;
  bool get test2 => _testdivice2;
  bool get cam => _cam;
  bool get vid => _vid;
  bool get testerall => (_testdivice2 && _cam && _vid);
  String get testurl => _testurl;
  String get server => _server;

  UserData? get userdata => _userdata;
  TestUser? get testUser => _TestUser;

  List<FootData>? get footdata => _footdata;
  bool get isfootempty => _footdata == null || _footdata!.isEmpty;
  bool get isweightData => _WeightData == null || _WeightData!.isEmpty;

  List<WeightData>? get weightData => _WeightData;
  List<GroupData>? get groupData => _groupData;
  String? get myAuthority => _myAuthority;
  String? get mymemberId => _mymemberId;

  String? get device => _device;
  bool get isdevice => _device != '';

  List<GroupHistory>? get groupHistroy => _groupHistory;
  List<Invitation>? get groupInvitation => _GroupInvitation;
  List<ScheduleData>? get scheduleData => _scheduleData;
  List<DateTime>? get targetdata => _targetdata;
  GroupTicket? get groupTicket => _GroupTicket;

  Map<String, dynamic>? get scandata => _Scandata;
  Map<String, dynamic>? get visiondata => _Visiondata;

  bool get loggedIn => _token != null;
  bool get isGroup => _groupData != null;
  bool get iswait => _GroupInvitation != null;
  bool get iscode => _GroupTicket != null;
  String get Groupstate => _GroupInvitation!.first.status;

  List<Member>? get member => _groupData?.first.members;

  static get http => null;
  bool isLoading = false;

  bool _isSignUp = false;
  bool _isLogin = false;
  bool _isclient = false;
  bool _iscm = false;
  bool _iskg = false;

  bool get isSignUp => _isSignUp;
  bool get isLogin => _isLogin;
  bool get isClient => _isclient;
  bool get iscm => _iscm;
  bool get iskg => _iskg;
  String? get verificationId => _verificationId;

  Future<void> testdivice2Up() async {
    _testdivice2 = true;
    notifyListeners();
  }

  Future<void> cam2Up() async {
    _cam = true;
    notifyListeners();
  }

  Future<void> vid2Up() async {
    _vid = true;
    notifyListeners();
  }

  Future<void> resetTestState() async {
    _vid = false;
    _cam = false;
    _testdivice2 = false;
    notifyListeners();
  }

  void updateSignUpState(bool isSignUp) {
    _isSignUp = isSignUp;
    notifyListeners();
  }

  void updatetesturl(String data) {
    _testurl = data;
    notifyListeners();
  }

  void unitiscm(bool data) {
    print('unitiscm = $data');
    _iscm = data;
    notifyListeners();
  }

  void unitiskg(bool data) {
    print('unitiskg = $data');
    _iskg = data;
    notifyListeners();
  }

  void updatserverurl(String data) {
    _server = data;
    notifyListeners();
  }

  void updateloginState(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners();
  }

  void updateClientState(bool isClient) {
    _isclient = isClient;
    notifyListeners();
  }

  Future<void> UpverificationId(String id) async {
    _verificationId = id;
    notifyListeners;
  }

  //-------------------Shared Preferences Helper------------------//

  String groupStatus = '';
  void printprov(String text) {
    print('\x1B[33m$text\x1B[0m');
  }

  Future<void> sortfootdata(String type) async {
    if (type == 'new') {
      _footdata!.sort((a, b) => b.measuredTime.compareTo(a.measuredTime));
    } else if (type == 'old') {
      _footdata!.sort((a, b) => a.measuredTime.compareTo(b.measuredTime));
    }
  }

  Future<void> sortweightdata(String type) async {
    if (type == 'new') {
      _WeightData!.sort((a, b) => b.measuredTime.compareTo(a.measuredTime));
    } else if (type == 'old') {
      _WeightData!.sort((a, b) => a.measuredTime.compareTo(b.measuredTime));
    }
  }

  Future<void> uptest() async {
    _test = 'up';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_test', 'up2');
    notifyListeners();
  }

  Future<void> downtest() async {
    _test = 'down';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('_test', 'down1');
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? expiresInStr = prefs.getString('expiresIn');
    print("expiresInStr = " + expiresInStr.toString());
    if (expiresInStr != null) {
      DateTime expiresIn = DateTime.parse(expiresInStr);
      if (DateTime.now().isAfter(expiresIn)) {
        await UserController.RefreshNewToken(_retoken!);
        return _token;
      } else {
        print('not refresh');
        return _token;
      }
    } else {
      await UserController.RefreshNewToken(_retoken!);
      return _token;
    }
  }

  //-------------------Shared Preferences Helper------------------//
  String truncateString(String input) {
    if (input.length > 10) {
      return '${input.substring(0, 10)}...';
    } else {
      return input;
    }
  }

  Future<bool> loadSaveUserData() async {
    print('------------------------------------------load Saved User Data-----------------------------');
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? retoken = prefs.getString('refreshToken');
    String? expiresInStr = prefs.getString('expiresIn');
    DateTime? expiresIn;
    if (expiresInStr != null) {
      expiresIn = DateTime.parse(expiresInStr);
    }
    if (token == null || token.isEmpty) {
      print('Token is empty.');
      return false; // 토큰이 비어있으므로 false 반환
    }

    String? userdata = prefs.getString('userdata');
    _token = token; // 비어 있지 않을 경우에만
    _retoken = retoken;
    _expiresIn = expiresIn;

    if (userdata != null) {
      _userdata = UserData.fromJsonString(userdata);
      String? device = prefs.getString('device');
      if (device != null && device.isNotEmpty) {
        _device = device;
      }

      loggerNoStack.d({
        'retoken': truncateString(retoken!),
        'token': truncateString(token),
        'expiresInStr': expiresInStr,
      });
      loggerNoStack.d(_userdata);
      notifyListeners();
      return true; // 데이터 로드 성공
    } else {
      return false; // 유저 데이터가 없으므로 false 반환
    }
  }

  Future<void> apicall() async {
    _datalod = true;
    DateTime now = DateTime.now();
    String toDate = DateFormat('yyyy/MM/dd').format(now);
    String toDate2 = DateFormat('yyyy-MM-dd').format(now);
    DateTime monthsBefore = DateTime(now.year, now.month - 3, now.day);
    String fromDate = DateFormat('yyyy/MM/dd').format(monthsBefore);
    String fromDate2 = DateFormat('yyyy-MM-dd').format(monthsBefore);
    //토큰 유효시간 검사
    String? calltoken = await getAccessToken();
    printprov('-------------------------------------get all api--------------------------------------');
    printprov('------------------------------------유저 프로파일 api--------------------------------------');
    await UserController.getprofile(calltoken!);
    printprov('-------------------------------------족저압 히스토리 api--------------------------------------');
    await FootprintApi.getfoothistory('${fromDate}', '${toDate}');
    printprov('-------------------------------------체중 히스토리 api--------------------------------------');
    await FootprintApi.getweighthistory('${fromDate}', '${toDate}');
    printprov('-------------------------------------그룹 유무 api--------------------------------------');
    await GroupApi.findGroup();
    printprov('-------------------------------------그룹 대기 api--------------------------------------');
    await GroupApi.getGroupInvitationByUser();
    printprov('-------------------------------------그룹 히스토리 api--------------------------------------');
    await GroupApi.GroupHistoryData();
    printprov('-------------------------------------일정 api--------------------------------------');
    //await ScheduleService.getScheduleData('${fromDate2}', '${toDate2}');
    printprov('-------------------------------------end api--------------------------------------');
    _datalod = false;
    notifyListeners();
  }

  Future<void> historyapi() async {
    DateTime now = DateTime.now();
    String toDate = DateFormat('yyyy/MM/dd').format(now);

    DateTime monthsBefore = DateTime(now.year, now.month - 3, now.day);
    String fromDate = DateFormat('yyyy/MM/dd').format(monthsBefore);
    printprov('-------------------------------------get historyapi api--------------------------------------');
    printprov('-------------------------------------족저압 히스토리 api--------------------------------------');
    await FootprintApi.getfoothistory('${fromDate}', '${toDate}');
    printprov('-------------------------------------체중 히스토리 api--------------------------------------');
    await FootprintApi.getweighthistory('${fromDate}', '${toDate}');
  }

  Future<void> UpToken(String token, bool update) async {
    DateTime expiryTime = DateTime.now().add(Duration(minutes: 15));
    try {
      loggerNoStack.t({
        'Name': 'UpToken',
        'token': token,
        'expiryTime': expiryTime,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('expiresIn', expiryTime.toIso8601String());
      if (update) {
        _token = token;
        _expiresIn = expiresIn;
        await AppStateNotifier.instance.apicall();
        notifyListeners();
      }
    } on Exception catch (e) {
      loggerNoStack.e(e);
    }
    ;
  }

  Future<void> Uptestuid(String uid) async {
    try {
      loggerNoStack.t({
        'Name': 'Uptestuid',
        'uid': uid,
      });
      _testuid = uid;
    } on Exception catch (e) {
      loggerNoStack.e(e);
    }
    ;
  }

  Future<void> Uptype(String type) async {
    _type = type;
    ;
  }

  Future<void> UpfirebaseToken(String token) async {
    loggerNoStack.t({
      'Name': 'UpfirebaseToken',
      'token': token,
    });
    _firebasetoken = token;
    ;
  }

  Future<void> removefirebaseToken() async {
    _firebasetoken = null;
    ;
  }

  Future<void> UprefreshToken(String token) async {
    try {
      loggerNoStack.t({
        'Name': 'UprefreshToken',
        'token': token,
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('refreshToken', token);
      _retoken = token;
    } on Exception catch (e) {
      loggerNoStack.e(e);
    }
    ;
  }

  Future<void> UpToken2(String token, bool update) async {
    print('uptoken2');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken2() async {
    final prefs = await SharedPreferences.getInstance();
    String? test = prefs.getString('token');
    return test;
  }

  Future<void> UpUserInfo(UserData data) async {
    loggerNoStack.i('Provider----------------------UpUserInfo');
    _userdata = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userdata', data.toJsonString());
    notifyListeners();
  }

  Future<void> UptestUserInfo(TestUser data) async {
    loggerNoStack.i('Provider----------------------UpUserInfo');
    _TestUser = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('TestUser', data.toJsonString());
    notifyListeners();
  }

  Future<void> Upfoothistory(List<FootData> data) async {
    loggerNoStack.i('Provider----------------------Upfoothistory');
    _footdata = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('footdata', jsonEncode(data));
    notifyListeners();
  }

  Future<void> delfoothistory() async {
    loggerNoStack.i('Provider----------------------delfoothistory');
    final prefs = await SharedPreferences.getInstance();
    _footdata = null;
    await prefs.remove('footdata');
    notifyListeners();
  }

  Future<void> UpWeightHistory(List<WeightData> data) async {
    loggerNoStack.i('Provider----------------------Upfoothistory');

    _WeightData = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weightdata', jsonEncode(data));
    notifyListeners();
  }

  Future<void> UpScanData(Map<String, dynamic> data) async {
    _Scandata = data;
    loggerNoStack.i('Provider----------------------UpScanData');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scandata', jsonEncode(data));
    notifyListeners();
  }

  Future<void> UpVisionData(Map<String, dynamic> data) async {
    _Visiondata = data;
    loggerNoStack.i('Provider----------------------UpVisionData');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('VisionData', jsonEncode(data));
    notifyListeners();
  }

  Future<void> UpGroupData(List<GroupData> data) async {
    String? uid = AppStateNotifier.instance.userdata?.uid;
    print('data = $data');

    _groupData = data;
    loggerNoStack.i('Provider----------------------UpGroupData');
    final prefs = await SharedPreferences.getInstance();
    _myAuthority = _groupData!.first.members.firstWhere((element) => element.uid == uid).authority;
    _mymemberId = _groupData!.first.members.firstWhere((element) => element.uid == uid).memberId;
    await prefs.setString('groupdata', jsonEncode(data));

    notifyListeners();
  }

  Future<void> UpGroupInvited(List<Invitation> data) async {
    _GroupInvitation = data;
    loggerNoStack.i('Provider----------------------UpGroupInvited');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('GroupInvitation', jsonEncode(data));
    notifyListeners();
  }

  Future<void> UpGroupTicket(GroupTicket data) async {
    loggerNoStack.i('Provider----------------------GroupTicket');
    _GroupTicket = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('GroupTicket', data.toJsonString());
    notifyListeners();
  }

  Future<void> UpGroupHistory(List<GroupHistory> data) async {
    _groupHistory = data;
    loggerNoStack.i('Provider----------------------UpGroupHistory');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupHistory', jsonEncode(data));
    notifyListeners();
  }

  Future<void> UpSchadule(List<ScheduleData> data) async {
    _scheduleData = data;
    loggerNoStack.i('Provider----------------------UpSchadule');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ScheduleData', jsonEncode(data));

    _targetdata = data.map((item) => item.targetDate).toList();

    notifyListeners();
  }

  Future<void> Updevice(String data) async {
    _device = data;
    loggerNoStack.i('Provider----------------------Updevice');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device', data);
    notifyListeners();
  }

  Future<void> resetgroup() async {
    print('resetgroup');
    final prefs = await SharedPreferences.getInstance();

    _GroupInvitation = null;
    await prefs.remove('GroupInvitation');
    await prefs.remove('groupdata');
    _groupData = null;

    notifyListeners();
  }

  Future<void> resetcode() async {
    print('resetcode');
    final prefs = await SharedPreferences.getInstance();

    _GroupTicket = null;
    await prefs.remove('GroupTicket');
    notifyListeners();
  }

  Future<void> removedevice() async {
    print('removedevice');
    final prefs = await SharedPreferences.getInstance();
    _device = '';
    await prefs.remove('device');
    notifyListeners();
  }

  Future<void> logout() async {
    print('logout');
    final prefs = await SharedPreferences.getInstance();
    _token = null;
    _testuid = null;
    _TestUser = null;
    _expiresIn = null;
    AppStateNotifier.instance.resetRole();

    _firebasetoken = null;
    await prefs.remove('refreshToken');

    _retoken = null;
    _type = null;
    await prefs.remove('token');
    _userdata = null;
    await prefs.remove('userdata');

    _footdata = null;
    await prefs.remove('footdata');
    _WeightData = null;
    await prefs.remove('weightdata');
    _groupHistory = null;
    await prefs.remove('groupHistory');
    _Scandata = null;
    await prefs.remove('scandata');
    _Visiondata = null;
    await prefs.remove('VisionData');
    _groupData = null;
    await prefs.remove('groupdata');
    _myAuthority = null;
    await prefs.remove('myAuthority');
    _device = '';
    await prefs.remove('device');
    _GroupInvitation = null;

    await prefs.remove('GroupInvitation');
    if (_token == null &&
        _userdata == null &&
        _footdata == null &&
        _WeightData == null &&
        _groupHistory == null &&
        _Scandata == null &&
        _groupData == null) {
      debugPrint('Logout and data reset successful.');
    } else {
      debugPrint('Data reset failed. Some fields are not null.');
    }
    notifyListeners();
  }

  Future<void> deletegroup() async {
    print('deletegroup');
    _groupHistory = null;
    _groupData = null;
    notifyListeners();
  }

  Future<void> GetAllData() async {}

  void update(String? newToken) {
    print('notifyListeners');
    if (_token != newToken) {
      _token = newToken;
      print('update $_token');
      notifyListeners();
    }
  }

  void delete() {
    print('delete');
    _token = null;
    notifyListeners();
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }

  /////////////////////////////// ===== [variables] ===== ///////////////////////////////

  /// 상대방
  String? to;

  /// 역할
  String? role;

  /// 본인
  String? _from;

  /// [drawing] 그림, 색상
  DrawingGroup? currentGroup;
  Color? currentColor;

  /// 연결대상, 본인
  RTCPeerConnection? _peer;

  /// 본인 비디오 렌더러
  RTCVideoRenderer? localRenderer = RTCVideoRenderer();

  /// 상대방 비디오 렌더러
  RTCVideoRenderer? remoteRenderer = RTCVideoRenderer();

  /// 유저 리스트 관리
  ValueNotifier<List<Map<String, dynamic>>> userListNotifier = ValueNotifier<List<Map<String, dynamic>>>([]);

  /// 이미지 관리
  ValueNotifier<int> imageNumberNotifier = ValueNotifier<int>(0);
  ValueNotifier<bool> isDrawNotifier = ValueNotifier<bool>(false);

  /// 본인 비디오 렌더 관리
  ValueNotifier<bool> localVideoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> localAudioNotifier = ValueNotifier<bool>(false);

  /// 상대방 비디오 렌더 관리
  ValueNotifier<bool> remoteVideoNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> remoteConnectNotifier = ValueNotifier<bool>(false);

  /// Drawing 관리
  ValueNotifier<List<DrawingGroup>> drawingGroupsNotifier = ValueNotifier<List<DrawingGroup>>([]);

  /// 메시지 관리
  ValueNotifier<List<Map<String, dynamic>>> messagesNotifier = ValueNotifier<List<Map<String, dynamic>>>([]);

  /// [_receiveOffer] 발생시, [sendAnswer] 부분 데이터 처리
  RTCSessionDescription? _answer;

  /// [WebRTCListView] 부분 state 처리
  ValueNotifier<ScreenState> screenNotifier = ValueNotifier<ScreenState>(ScreenState.loading);

  /// [WebRTCView] context. Navigator.pop 용도
  // BuildContext? webRTCVideoViewContext;
  VoidCallback? onCloseVideoCall;
  VoidCallback? onCloseAudioCall;

  /// offer/answer 과정 완료 후 send
  final List<IceCandidateModel> _candidateList = [];

  /// 본인 비디오
  MediaStream? _localStream;
  MediaStream? get localStream => _localStream;

  /// iceCandidate 연결 여부
  bool _isConnected = false;
  bool _isVideoOn = true; // 비디오 상태 관리
  bool _isAudioOn = true;
  bool get isVideoOn => _isVideoOn;
  bool get isAudioOn => _isAudioOn;
  bool audioOnly = false;
  bool _isClosing = false;
  bool _isSocketInitialized = false;
  bool _isCallRefused = false;
  bool get isCallRefused => _isCallRefused;

  /////////////////////////////// ===== [variables] ===== ///////////////////////////////
  ///                                                                                 ///
  ///////////////////////////////// ===== [embed] ===== /////////////////////////////////

  /// [_initSocket], [_initPeer] 소켓, 피어, 렌더러 초기화
  Future<void> initController() async {
    if (_isSocketInitialized) return;
    await _initSocket();
    await _initPeer();

    await localRenderer!.initialize();
    await remoteRenderer!.initialize();
    _isVideoOn = true;
    _isAudioOn = true;
    screenNotifier.value = ScreenState.initDone;

    imageNumberNotifier.addListener(_onImageNumberChanged);
    _isSocketInitialized = true;
  }

  void dispose() {
    currentGroup = null;

    userListNotifier.dispose();
    localVideoNotifier.dispose();
    remoteVideoNotifier.dispose();
    remoteConnectNotifier.dispose();
    screenNotifier.dispose();
    drawingGroupsNotifier.dispose();
    messagesNotifier.dispose();

    localRenderer?.dispose();
    remoteRenderer?.dispose();

    _localStream?.dispose();
    _peer?.dispose();
    imageNumberNotifier.removeListener(_onImageNumberChanged);
    super.disconnectSocket();
  }

  /// [socket] 초기화
  Future<void> _initSocket() async {
    _from = await super.connectSocket();

    if (_from != null) {
      super.socketOn('updateUserlist', _updateUserList);
      super.socketOn('connect_error', (data) {
        debugPrint('[debug][socket] error : $data');
      });
      super.socketOn('connect_timeout', (data) {
        debugPrint('[debug][socket] error : $data');
      });
      super.socketOn('offer', _receiveOffer);
      super.socketOn('answer', _receiveAnswer);
      super.socketOn('refuseV', _refusedVideoCallConnection);
      super.socketOn('refuseA', _refusedAudioCallConnection);
      super.socketOn('remoteIceCandidate', _remotePeerIceCandidate);
      super.socketOn('disconnectVideoPeer', (_) {
        closeVideoCall(emitEvent: false);
      });
      super.socketOn('disconnectAudioPeer', (_) {
        closeAudioCall(emitEvent: false);
      });
      super.socketOn('drawing', _receiveDrawing);
      super.socketOn('drawingEnd', _receiveDrawingEnd);

      super.socketOn('chatHistory', _receiveChatHistory);
      super.socketOn('message', _receiveMessage);

      super.socketOn('clearDrawing', _receiveClearDrawing);
      super.socketOn('setDrawingColor', _receiveSetDrawingColor);
      super.socketOn('drawingUndo', _receiveDrawingUndo);

      super.socketOn('cancelOfferV', _receiveCancelCallV);
      super.socketOn('cancelOfferA', _receiveCancelCallA);
      super.socketOn('imageLoad', _receiveImageLoad);
      super.socketOn('isDrawLoad', _receiveimageisDrawLoad);

      super.socketOn('calling', (call) {
        _receiveCall(call);
      });
      super.socketOn('acceptCall', (call) {
        _receiveAcceptCall(call);
      });
      super.socketOn('refuseCall', (call) {
        _receiveRefuseCall(call);
      });
      super.socketOn('cancelCall', (call) {
        _receiveCancelCall(call);
      });
      super.socketOn('closeCall', (call) {
        closeCall(call, emitEvent: false);
      });

      super.socketEmit('requestUserlist', null);
    }
  }

  /// [initiate]
  void initializeUserStatus() {
    String oppositeRole = role == 'expert' ? 'client' : 'expert';
    bool isUserOnline = false;

    for (var user in userListNotifier.value) {
      if (user['role'] == oppositeRole) {
        isUserOnline = true;
        break;
      }
    }

    if (isUserOnline) {
      // 상대방이 온라인 상태임을 처리
    } else {
      // 상대방이 오프라인 상태임을 처리
    }
  }

  /// [_peer] 초기화
  Future<void> _initPeer() async {
    _peer = await createPeerConnection({
      'iceServers': [
        {'urls': "stun:webrtc.carencoinc.com"},
        {
          'urls': [
            "turn:webrtc.carencoinc.com:80?transport=udp",
            "turn:webrtc.carencoinc.com:3478?transport=udp",
            "turn:webrtc.carencoinc.com:80?transport=tcp",
            "turn:webrtc.carencoinc.com:3478?transport=tcp",
            "turns:webrtc.carencoinc.com:443?transport=tcp",
            "turns:webrtc.carencoinc.com:5349?transport=tcp"
          ],
          'username': "user1",
          'credential': "pass1"
        }
      ]
    });

    // 이벤트 핸들러를 연결 직후에 설정하여 누락 방지
    _peer!.onIceCandidate = _iceCandidateEvent;
    _peer!.onConnectionState = _peerStateChange;
    _peer!.onTrack = _remoteStream;

    // 각 이벤트의 설정 상태를 확인하는 디버그 로그
    debugPrint("[debug]onIceCandidate handler set: ${_peer!.onIceCandidate != null}");
    debugPrint("[debug]onTrack handler set: ${_peer!.onTrack != null}");
    debugPrint("[debug]onConnectionState handler set: ${_peer!.onConnectionState != null}");
  }

  Future<void> _resetElements() async {
    try {
      // 미디어 스트림 종료
      await turnOffMedia();

      // ICE 후보 리스트 초기화
      _candidateList.clear();

      // 피어 연결 종료
      await _peer?.close();
      _peer = null;

      // 피어 연결 재초기화
      await _initPeer();

      // 렌더러의 srcObject를 null로 설정하여 스트림 해제
      localRenderer?.srcObject = null;
      remoteRenderer?.srcObject = null;

      // 상태 초기화
      localVideoNotifier.value = false;
      remoteVideoNotifier.value = false;
      remoteConnectNotifier.value = false;
      imageNumberNotifier.value = 0;

      drawingGroupsNotifier.value = [];
      currentGroup = null;

      _isConnected = false;

      await _localStream?.dispose();
      _localStream = null;

      _isVideoOn = true;
      _isAudioOn = true;

      _isCallRefused = false;
    } catch (e) {
      debugPrint("[debug]Error in _resetElements: $e");
    }
  }

  /// [본인] 미디어 off
  Future<void> turnOffMedia() async {
    if (localRenderer!.srcObject != null) {
      localRenderer!.srcObject = null;
      localVideoNotifier.value = false;
      localAudioNotifier.value = false;

      for (MediaStreamTrack track in _localStream!.getTracks()) {
        track.enabled = false;
        await track.stop();
      }

      await _localStream?.dispose();
      _localStream = null;
      _isVideoOn = false;
      _isAudioOn = false;
    }
  }

  /// [본인] 미디어 on
  Future<void> turnOnMedia() async {
    final constraints = {
      'audio': true,
      'video': !audioOnly
          ? {
              'mandatory': {
                'minWidth': '720',
                'minHeight': '1280',
                'maxWidth': '720',
                'maxHeight': '1280',
                'minFrameRate': '24',
                'maxFrameRate': '24',
              },
              'facingMode': 'user',
              'optional': [],
            }
          : false,
    };
    _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    for (var track in _localStream!.getTracks()) {
      RTCRtpSender sender = await _peer!.addTrack(track, _localStream!);
      if (track.kind == 'video') {
        await _setInitialBitrate(sender);
      }
    }
    localRenderer!.srcObject = _localStream;
    localVideoNotifier.value = !audioOnly;
    _isVideoOn = true;
    _isAudioOn = true;
  }

  /// 미디어 Initiate
  Future<void> _startMedia({required bool isAudioOnly}) async {
    final constraints = {
      'audio': true,
      'video': !audioOnly
          ? {
              'mandatory': {
                'minWidth': '1280',
                'minHeight': '720',
                'maxWidth': '1280',
                'maxHeight': '720',
                'minFrameRate': '24',
                'maxFrameRate': '24',
              },
              'facingMode': 'user',
              'optional': [],
            }
          : false,
    };

    // 미디어 스트림 초기화
    _localStream = await navigator.mediaDevices.getUserMedia(constraints);
    debugPrint('[debug] Audio tracks: ${_localStream!.getAudioTracks()}'); // 추가
    // 트랙을 피어 연결에 추가하고 비트레이트 설정
    for (var track in _localStream!.getTracks()) {
      RTCRtpSender sender = await _peer!.addTrack(track, _localStream!);
      if (track.kind == 'video') {
        await _setInitialBitrate(sender);
      }
    }

    if (!isAudioOnly) {
      localRenderer!.srcObject = _localStream;
      localVideoNotifier.value = !isAudioOnly;
    }
  }

  /// peer state 확인용
  void _peerStateChange(RTCPeerConnectionState state) {
    debugPrint("[debug][webRTC] ICE Connection State: $state");
    if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected && !_isConnected) {
      _isConnected = true;
      debugPrint("[debug][webRTC] Connection established.");
    } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
      debugPrint("[debug][webRTC] Connection failed, attempting to restart ICE.");
      _peer?.restartIce();
    }
  }

  /// [본인, 상대방] ice candidate 연결 처리
  void _remotePeerIceCandidate(data) async {
    try {
      debugPrint("[debug][webRTC] Received ICE candidate data.");
      IceCandidateModel model = IceCandidateModel.fromJson(data);

      RTCIceCandidate candidate = RTCIceCandidate(model.candidate, model.sdpMid, model.sdpMLineIndex);
      await _peer!.addCandidate(candidate);

      // debugPrint("[webRTC] Successfully added ICE candidate: ${candidate.toMap()}");
    } catch (e) {
      debugPrint('[debug][webRTC] Error adding ICE candidate: $e');
    }
  }

  /// 상대방 미디어 처리
  void _remoteStream(RTCTrackEvent e) {
    debugPrint('[debug][webRTC] gotRemoteStream data : ${e.track}, ${e.streams}');

    if (e.streams.isNotEmpty) {
      MediaStream stream = e.streams.first;
      remoteRenderer!.srcObject = stream;
      remoteVideoNotifier.value = !audioOnly;
      debugPrint('[debug][webRTC] Remote stream added to renderer.');
    } else {
      debugPrint('[debug][webRTC] No remote stream available.');
    }
  }

  /// [본인, 상대방] ice candidate 연결 요청
  void _iceCandidateEvent(RTCIceCandidate e) {
    IceCandidateModel model = IceCandidateModel(
      candidate: e.candidate,
      sdpMid: e.sdpMid,
      sdpMLineIndex: e.sdpMLineIndex,
      to: to,
    );
    // print("ICE Candidate: ${e.toMap()}");
    if (model.candidate == null || model.to == null) {
      return;
    }

    debugPrint('[debug][webRTC] send iceCandidate');
    // debugPrint('[webRTC] send iceCandidate : ${model.toJson()}');
    super.socketEmit('iceCandidate', model.toJson());

    // int index = _candidateList
    //     .indexWhere((element) => element.candidate == model.candidate);

    // if (index < 0) {
    //   _candidateList.add(model);
    // }
  }

  /// [본인] 상대방 answer 받음
  void _receiveAnswer(data) async {
    WebRTCModel model = WebRTCModel.fromJson(data);

    remoteConnectNotifier.value = true;
    debugPrint('[webRTC] receive answer : ${model.answerType}');

    await _peer!.setRemoteDescription(RTCSessionDescription(
        model.answerSDP!.replaceFirst('useinbandfec=1', 'useinbandfec=1; stereo=1; maxaveragebitrate=510000'), model.answerType));

    for (IceCandidateModel candidateModel in _candidateList) {
      if (!_isConnected) {
        debugPrint('[webRTC] send iceCandidate : ${candidateModel.toJson()}');
        super.socketEmit('iceCandidate', candidateModel.toJson());
        break;
      }
    }
  }

  /// [상대방] offer 받음
  void _receiveOffer(data) async {
    WebRTCModel model = WebRTCModel.fromJson(data);

    audioOnly = model.audioOnly!;

    debugPrint('[debug][webRTC] receive offer : ${model.to} from ${model.from}');

    await _peer!.setRemoteDescription(RTCSessionDescription(model.offerSDP, model.offerType));
    await _startMedia(isAudioOnly: audioOnly);
    _answer = await _peer!.createAnswer({
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': !audioOnly,
      }
    });
    await _peer!.setLocalDescription(_answer!);
    to = model.from;
    sendAnswer();
  }

  /// [본인] offer 보냄
  void _emitOffer(RTCSessionDescription offer, bool isAudioOnly) {
    final model = WebRTCModel(
      from: _from,
      to: to,
      offerSDP: offer.sdp,
      offerType: offer.type,
      audioOnly: isAudioOnly,
    );
    socketEmit('offer', model.toJson());
  }

  /// [본인] answer 보냄
  void _emitAnswer(RTCSessionDescription answer, bool isAudioOnly) {
    final model = WebRTCModel(
      from: _from,
      to: to,
      answerSDP: answer.sdp,
      answerType: answer.type,
      audioOnly: isAudioOnly,
    );
    socketEmit('answer', model.toJson());
  }

  /// [image] Notifier 변경 시 group 초기화
  void _onImageNumberChanged() {
    currentGroup = null;
  }

  ///////////////////////////////// ===== [embed] ===== /////////////////////////////////
  ///                                                                                 ///
  ///////////////////////////////// ===== [back] =====  /////////////////////////////////

  /// [main] ///

  /// 역할 설정
  void setRole(String newRole) {
    role = newRole;
    if (_from != null) {
      super.socketEmit('setRole', {'role': role});
    }
  }

  void resetRole() {
    if (_from != null) {
      super.socketEmit('resetRole', {});
    }
  }

  /// 유저 리스트 업데이트
  void _updateUserList(data) {
    debugPrint('[socket] userList update $data');
    Map<String, dynamic> map = Map.castFrom(data);

    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(map['userList']);
    debugPrint('[socket] list : $list');
    list.removeWhere((element) => element['userId'] == super.user);

    userListNotifier.value = list;
  }

  /// [AudioCall] ///

  /// [본인] 통화 거절 받음
  void _refusedAudioCallConnection(_) async {
    await closeAudioCall(emitEvent: false);
    _isCallRefused = true;
  }

  /// [상대] 통화 취소 받음
  void _receiveCancelCallA(_) {
    refuseAudioOffer();
  }

  /// [VideoCall] ///

  /// [본인] 통화 거절 받음
  void _refusedVideoCallConnection(_) async {
    await closeVideoCall(emitEvent: false);
    _isCallRefused = true;
  }

  /// [상대] 통화 취소 받음
  void _receiveCancelCallV(_) {
    refuseVideoOffer();
  }

  /// [drawing]데이터 받음
  void _receiveDrawing(data) {
    Map<String, dynamic>? pointData = data['point'];
    Offset? receivedPoint;
    if (pointData != null) {
      receivedPoint = Offset(
        (pointData['x'] as num).toDouble(),
        (pointData['y'] as num).toDouble(),
      );
    } else {
      receivedPoint = null;
    }

    if (currentColor == null) return;

    final currentImageNumber = imageNumberNotifier.value;

    if (currentGroup == null || currentGroup!.imageNumber != currentImageNumber) {
      currentGroup = DrawingGroup(
        color: currentColor!,
        points: [],
        imageNumber: currentImageNumber,
      );
      drawingGroupsNotifier.value = List.from(drawingGroupsNotifier.value)..add(currentGroup!);
    }

    if (receivedPoint != null) {
      currentGroup!.points.add(DrawingPoint(receivedPoint));
      drawingGroupsNotifier.value = List.from(drawingGroupsNotifier.value);
    }
  }

  /// [drwaing]리셋
  void _resetDrawingState() {
    final currentImageNumber = imageNumberNotifier.value;
    drawingGroupsNotifier.value = drawingGroupsNotifier.value.where((group) => group.imageNumber != currentImageNumber).toList();
    currentGroup = null;
  }

  /// [drawing]되돌리기 시그널 전송
  Future<void> sendDrawingUndo() async {
    if (to != null) {
      super.socketEmit('drawingUndo', {
        'to': to,
      });
    }
  }

  /// [drawing]되돌리기 시그널 받음
  void _receiveDrawingUndo(_) {
    final currentImageNumber = imageNumberNotifier.value;
    final groupsForCurrentImage = drawingGroupsNotifier.value.where((group) => group.imageNumber == currentImageNumber).toList();

    if (groupsForCurrentImage.isNotEmpty) {
      drawingGroupsNotifier.value = List.from(drawingGroupsNotifier.value)..remove(groupsForCurrentImage.last);
    }
  }

  /// [drawing]색상 시그널 받음
  void _receiveSetDrawingColor(data) {
    Color color = Color(int.parse(data['color'], radix: 16)); // 색상 정보 파싱
    currentColor = color;
  }

  /// [drawing]리셋 시그널 받음
  void _receiveClearDrawing(_) {
    _resetDrawingState();
  }

  /// [drawing]종료 시그널 받음
  void _receiveDrawingEnd(_) {
    // 작업을 끝내고 현재 작업 중인 그룹을 null로 설정
    currentGroup = null;

    // 그룹 리스트를 업데이트 (현재 추가된 내용을 반영)
    drawingGroupsNotifier.value = List.from(drawingGroupsNotifier.value);
  }

  /// [image] 이미지 로드 시그널 보냄
  Future<void> sendImageLoad(int imageNumber) async {
    if (to != null) {
      super.socketEmit('imageLoad', {
        'to': to,
        'image': imageNumber,
      });
    }
    debugPrint("[debug] image send number : ${imageNumber}");
    imageNumberNotifier.value = imageNumber;
  }

  /// [image] 이미지 로드 시그널 받음
  void _receiveImageLoad(data) {
    int imageNumber = data['image'];
    debugPrint("[debug] image number : ${imageNumber}");
    if (imageNumber == 1 || imageNumber == 2 || imageNumber == 3 || imageNumber == 4) {
      imageNumberNotifier.value = imageNumber;
    }
  }

  /// [image] 이미지 상태 시그널 보냄
  Future<void> sendstateLoad(int isDraw) async {
    if (to != null) {
      super.socketEmit('isDrawLoad', {
        'to': to,
        'isDraw': isDraw,
      });
    }
    debugPrint("[debug] image send state : ${isDraw}");

    isDrawNotifier.value = isDraw == 1;
  }

  /// [image] 이미지 로드 시그널 받음
  void _receiveimageisDrawLoad(data) {
    int isDraw = data['isDraw'];
    debugPrint("[debug] image number : ${isDraw}");
    isDrawNotifier.value = isDraw == 1;
  }

  /// [chatting] ///

  void _receiveChatHistory(data) {
    List<dynamic> chatLogs = data;
    messagesNotifier.value = chatLogs.map((log) {
      return {
        'message': log['message'],
        'isOwn': log['from'] == role,
        'timestamp': log['timestamp'],
      };
    }).toList();
    // 시간 순으로 정렬
    messagesNotifier.value.sort((a, b) => a['timestamp'] - b['timestamp']);
  }

  /// [message]데이터 수신
  void _receiveMessage(data) {
    String message = data['message'];
    String from = data['from'];
    int timestamp = data['timestamp'];

    messagesNotifier.value = List.from(messagesNotifier.value)
      ..add({
        'message': message,
        'isOwn': from == role,
        'timestamp': timestamp,
      });
  }

  ///////////////////////////////// ===== [back]  ===== /////////////////////////////////
  ///                                                                                 ///
  ///////////////////////////////// ===== [front] ===== /////////////////////////////////

  /// [main] ///

  /// [localStream]의 null 여부를 반환합니다.
  bool checkStream() {
    return localStream != null;
  }

  /// [AudioCall_VideoCall] 공통 ///

  /// 통화 받음
  void sendAnswer() {
    debugPrint('[debug][webRTC] send answer to $to');
    remoteConnectNotifier.value = true;
    _emitAnswer(_answer!, audioOnly);
    _answer = null;

    Vibration.hasVibrator().then((value) {
      if (value ?? false) {
        Vibration.cancel();
      }
    });
  }

  /// [AudioCall] ///

  /// 통화 요청 보냄
  Future<void> sendAudioCallOffer() async {
    if (to == null) return;
    audioOnly = true;
    await _initPeer();
    await _startMedia(isAudioOnly: true);
    final offer = await _peer!.createOffer({'OfferToReceiveAudio': true, 'OfferToReceiveVideo': false});
    await _peer!.setLocalDescription(offer);
    _emitOffer(offer, true);
  }

  /// 통화 취소 보냄(통화 수락 전 통화종료 시)
  Future<void> cancelOfferA() async {
    socketEmit('cancelOfferA', {'to': to});
  }

  /// 통화 거절 보냄
  Future<void> refuseAudioOffer() async {
    socketEmit('refuseA', {'to': to});

    await _resetElements();
    screenNotifier.value = ScreenState.initDone;
  }

  /// 음성 통화 종료
  Future<void> closeAudioCall({bool emitEvent = true}) async {
    if (_isClosing) {
      debugPrint("[debug] closeAudioCall is already in progress.");
      return;
    }
    _isClosing = true;

    debugPrint("[debug] close call received or emit.");

    if (onCloseAudioCall != null) {
      onCloseAudioCall!();
    }

    if (emitEvent && to != null) {
      super.socketEmit('disconnectAudioPeer', {'to': to});
    }

    await _resetElements();
    debugPrint("[debug] context is closed.");

    _isClosing = false;
  }

  /// 음소거 버튼(on/off)
  void toggleMuteA() {
    _isAudioOn = !_isAudioOn;
    for (var track in _localStream!.getTracks()) {
      track.enabled = _isAudioOn;
    }
    localAudioNotifier.value = _isAudioOn;
  }

  /// [VideoCall] ///

  /// 통화 요청 보냄
  Future<void> sendVideoCallOffer() async {
    if (to == null) {
      debugPrint("[debug] to is $to...");
      return;
    }
    audioOnly = false;
    await _initPeer(); // 피어 초기화
    await _startMedia(isAudioOnly: false); // 미디어 초기화 및 시작

    final offer = await _peer!.createOffer({'OfferToReceiveAudio': true, 'OfferToReceiveVideo': true});
    await _peer!.setLocalDescription(offer);
    debugPrint("[debug][webRTC] Sending offer: ${offer.sdp}");
    _emitOffer(offer, false);
  }

  /// 통화 취소 보냄(통화 수락 전 통화종료 시)
  Future<void> cancelOfferV() async {
    debugPrint("[debug] cancelOfferV");
    socketEmit('cancelOfferV', {'to': to});
  }

  /// 통화 거절 보냄
  Future<void> refuseVideoOffer() async {
    socketEmit('refuseV', {'to': to});
    await _resetElements();

    screenNotifier.value = ScreenState.initDone;
  }

  Future<void> closeVideoCall({bool emitEvent = true}) async {
    if (_isClosing) {
      debugPrint("[debug] closeVideoCall is already in progress.");
      return;
    }
    _isClosing = true;

    debugPrint("[debug] close call received or emit.");

    if (onCloseVideoCall != null) {
      onCloseVideoCall!();
    }

    if (emitEvent && to != null) {
      super.socketEmit('disconnectVideoPeer', {'to': to});
    }

    await _resetElements();
    debugPrint("[debug] context is closed.");

    _isClosing = false;
  }

  /// 내 비디오 버튼(on/off)
  void toggleVideo() {
    if (_localStream != null) {
      _isVideoOn = !_isVideoOn;
      for (var track in _localStream!.getVideoTracks()) {
        track.enabled = _isVideoOn;
      }
      localVideoNotifier.value = _isVideoOn;
    }
  }

  /// 음소거 버튼(on/off)
  void toggleMuteV() {
    _isAudioOn = !_isAudioOn;
    for (var track in _localStream!.getAudioTracks()) {
      track.enabled = _isAudioOn;
    }
    localAudioNotifier.value = _isAudioOn;
    // debugPrint("[debug] width : ${localRenderer!.videoWidth} & height : ${localRenderer!.videoHeight}");
  }

  /// [drawing]데이터 전송
  Future<void> sendDrawing(Offset normalizedPoint) async {
    if (to != null && currentColor != null) {
      final currentImageNumber = imageNumberNotifier.value;
      // 로컬 드로잉 업데이트
      if (currentGroup == null || currentGroup!.imageNumber != currentImageNumber) {
        currentGroup = DrawingGroup(color: currentColor!, points: [], imageNumber: currentImageNumber);
        drawingGroupsNotifier.value = List.from(drawingGroupsNotifier.value)..add(currentGroup!);
      }
      currentGroup!.points.add(DrawingPoint(normalizedPoint));
      drawingGroupsNotifier.value = List.from(drawingGroupsNotifier.value);

      // 상대방에게 드로잉 데이터 전송
      super.socketEmit('drawing', {
        'to': to,
        'point': {'x': normalizedPoint.dx, 'y': normalizedPoint.dy},
      });
    }
  }

  /// [drawing]색상 시그널 전송
  Future<void> setDrawingColor(Color color) async {
    currentColor = color;
    if (to != null) {
      super.socketEmit('setDrawingColor', {
        'to': to,
        'color': color.value.toRadixString(16),
      });
    }
  }

  /// [drawing]리셋 시그널 전송
  Future<void> sendClearDrawing() async {
    if (to != null) {
      super.socketEmit('clearDrawing', {'to': to});
    }
    _resetDrawingState();
  }

  /// [drawing]되돌리기 버튼
  Future<void> undoLastDrawing() async {
    final currentImageNumber = imageNumberNotifier.value;
    final groupsForCurrentImage = drawingGroupsNotifier.value.where((group) => group.imageNumber == currentImageNumber).toList();

    if (groupsForCurrentImage.isNotEmpty) {
      drawingGroupsNotifier.value = List.from(drawingGroupsNotifier.value)..remove(groupsForCurrentImage.last);
      await sendDrawingUndo();
    }
  }

  /// [drawing]종료 시그널 전송
  Future<void> sendDrawingEnd() async {
    if (to != null) {
      super.socketEmit('drawingEnd', {
        'to': to,
      });
    }
    currentGroup = null;
  }

  /// [chatting] ///

  /// [message] 데이터 전송
  Future<void> sendMessage(String message) async {
    if (to != null) {
      super.socketEmit('message', {
        'to': to,
        'message': message,
        'role': role, // 역할을 uid로 사용
      });
    }
  }

  ///////////////////////////////// ===== [front] ===== /////////////////////////////////
  ///                                                                                 ///
  ///////////////////////////////// ===== [temp] ===== //////////////////////////////////
  //////////////////////////////////// ===== [front] ===== /////////////////////////////////
  ///                                                                                 ///
  ///////////////////////////////// ===== [temp] ===== //////////////////////////////////
  void joinChatRoom() {
    if (role != null) {
      String uid = role!;
      super.socketEmit('joinChatRoom', {'role': uid});

      // 채팅 기록 요청
      super.socketEmit('requestChatHistory', {
        'to': to,
      });
    } else {
      debugPrint('[debug]Role is not set. Cannot join chat room.');
    }
  }

  // 통화
  Future<void> sendCall(String call) async {
    debugPrint("[debug] send $call call to $to");
    audioOnly = false;
    await _initPeer(); // 피어 초기화
    await _startMedia(isAudioOnly: false); // 미디어 초기화 및 시작
    super.socketEmit('sendCall', {'to': to, 'call': call});
  }

  // 수락
  Future<void> acceptCall(String call) async {
    debugPrint("[debug] send accept $call call to $to");
    super.socketEmit('acceptCall', {'to': to, "call": call});
  }

  // 거절
  Future<void> refuseCall(String call) async {
    super.socketEmit('refuseCall', {'to': to, 'call': call});
    debugPrint("[debug] emitted refuse call.. to $to..");
    await _resetElements();
    screenNotifier.value = ScreenState.initDone;
  }

  // 취소
  Future<void> cancelCall(String call) async {
    debugPrint("[debug] emitted cancel call..");
    super.socketEmit('cancelCall', {'to': to, "call": call});
  }

  // 종료
  Future<void> closeCall(String call, {bool emitEvent = true}) async {
    if (_isClosing) {
      debugPrint("[debug] closeAudioCall is already in progress.");
      return;
    }
    _isClosing = true;

    debugPrint("[debug] close call received or emit.");

    if (onCloseAudioCall != null) {
      onCloseAudioCall!();
    }
    if (onCloseVideoCall != null) {
      onCloseVideoCall!();
    }

    if (emitEvent && to != null) {
      socketEmit('closeCall', {'to': to, "call": call});
    }

    await _resetElements();
    debugPrint("[debug] context is closed.");

    _isClosing = false;
  }

  // 시그널 받음
  // 통화
  void _receiveCall(String call) async {
    debugPrint("[debug] $call call from $to");
    audioOnly = call == 'audio';

    // debugPrint("[debug][temp] audio ? $audioOnly");

    screenNotifier.value = ScreenState.receivedCalling;

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1500);
    }
  }

  // 수락
  void _receiveAcceptCall(String call) {
    debugPrint("[debug] received accept call : $call");
    if (call != "video" && call != "audio") {
      debugPrint("[debug] call option is $call, is not video or audio..");
      return;
    }
    call == "audio" ? sendAudioCallOffer() : sendVideoCallOffer();
  }

  // 거절
  void _receiveRefuseCall(String call) async {
    debugPrint("[debug] received refuse call..");
    if (call != "video" && call != "audio") {
      debugPrint("[debug] call option is $call, is not video or audio..");
      return;
    }

    if (onCloseVideoCall != null) {
      debugPrint("[debug] video view callback..");
      onCloseVideoCall!();
    }

    if (onCloseAudioCall != null) {
      debugPrint("[debug] video view callback..");
      onCloseAudioCall!();
    }
  }

  // 취소
  void _receiveCancelCall(String call) {
    if (call != "video" && call != "audio") {
      debugPrint("[debug] call option is $call, is not video or audio..");
      return;
    }
    debugPrint("[debug] received cancel call..");
    refuseCall(call);
  }

  // 비트레이트 설정
  Future<void> _setInitialBitrate(RTCRtpSender sender) async {
    // 현재 파라미터 가져오기
    RTCRtpParameters? parameters = sender.parameters;

    if (parameters.encodings != null && parameters.encodings!.isNotEmpty) {
      parameters.encodings![0].maxBitrate = 2000000; // 2Mbps
      parameters.encodings![0].minBitrate = 1500000; // 1.5Mbps
      parameters.encodings![0].maxFramerate = 24;

      // 파라미터 적용
      bool result = await sender.setParameters(parameters);
      if (result) {
        debugPrint('[debug] Initial bitrate set to 2 Mbps');
      } else {
        debugPrint('[debug] Failed to set initial bitrate');
      }
    } else {
      debugPrint('[debug] RTCRtpParameters or encodings is null or empty');
    }
  }

  void disposeController() {}
}
