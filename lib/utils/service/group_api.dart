import 'dart:convert';
import 'package:mwc/main.dart';
import 'package:mwc/models/Code.dart';

import 'package:mwc/models/GroupData.dart';
import 'package:mwc/models/GroupHistory.dart';

import 'package:mwc/index.dart';
import 'package:mwc/models/GroupInvitation.dart';

import 'package:http/http.dart' as http;

class GroupCheckList {
  final String id;
  final String groupId;
  final String userUid;
  final bool humanHeight;
  final bool humanWeight;
  final bool humanFootprint;
  final bool schedule;

  GroupCheckList({
    required this.id,
    required this.groupId,
    required this.userUid,
    required this.humanHeight,
    required this.humanWeight,
    required this.humanFootprint,
    required this.schedule,
  });

  factory GroupCheckList.fromJson(Map<String, dynamic> json) {
    return GroupCheckList(
      id: json['id'] ?? '',
      groupId: json['groupId'] ?? '',
      userUid: json['userUid'] ?? '',
      humanHeight: json['humanHeight'] ?? false,
      humanWeight: json['humanWeight'] ?? false,
      humanFootprint: json['humanFootprint'] ?? false,
      schedule: json['schedule'] ?? false,
    );
  }
  static List<GroupCheckList> parseGroupCheckList(String responseBody) {
    final parsedJson = json.decode(utf8.decode(responseBody.runes.toList()));
    final groupCheckListJson = parsedJson['data']['groupCheckLists'] as List;
    return groupCheckListJson.map<GroupCheckList>((json) => GroupCheckList.fromJson(json)).toList();
  }
}

//-----------------------------------------GroupApi-----------------------------------------//
class GroupApi {
  static String linkurl = mainurl;

  //그룹 찾기
  static Future<void> findGroup() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    final url = Uri.parse('$linkurl/users/$uid/groups');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    loggerNoStack.t({'Name': 'findGroup', 'url': url});
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      print(jsonBody);
      loggerNoStack.i(jsonBody);

      if (jsonBody['data'] != null && jsonBody['data'].isNotEmpty) {
        List<GroupData> data = (jsonBody['data'] as List).map((m) => GroupData.fromJson(m)).toList();
        AppStateNotifier.instance.UpGroupData(data);
        await GroupApi.getGroupInvitationByUser();
        await GroupApi.GroupHistoryData();
      } else {
        loggerNoStack.w('No group');
        AppStateNotifier.instance.resetgroup();
      }
    } else {
      loggerNoStack.e(response.body);
      AppStateNotifier.instance.resetgroup();
    }
  }

  // 그룹 대기 확인
  static Future<void> getGroupInvitationByUser() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;

    final url = Uri.parse('$linkurl/users/$uid/invitations');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    loggerNoStack.t({'Name': 'getGroupInvitationByUser', 'url': url});

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.i(jsonBody);
      if (jsonBody['data'] != null && jsonBody['data'].isNotEmpty) {
        List<Invitation> data = (jsonBody['data'] as List).map((m) => Invitation.fromJson(m)).toList();

        AppStateNotifier.instance.UpGroupInvited(data);
      } else {
        loggerNoStack.w('No invited');
      }
    } else {
      loggerNoStack.e(response.body);
    }
  }

  static Future<void> GroupHistoryData() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData?.first.groupId;

    final url = Uri.parse('$linkurl/users/$uid/history/$groupId');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(url, headers: headers);
    loggerNoStack.t({'Name': 'GroupHistoryData', 'url': url});

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.i(jsonBody);
      List<GroupHistory> data = (jsonBody as List).map((m) => GroupHistory.fromJson(m)).toList();

      await AppStateNotifier.instance.UpGroupHistory(data);
    } else {
      loggerNoStack.e(response.body);
    }
  }

  //그룹 생성
  static Future<bool> createGroup(String groupName) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;

    final url = Uri.parse("$linkurl/users/$uid/groups");
    final headers = {"accept": "*/*", "Authorization": "Bearer $token", "Content-Type": "application/json"};
    final body = jsonEncode({"groupName": groupName});
    final response = await http.post(url, headers: headers, body: body);
    loggerNoStack.t({'Name': 'createGroup', 'url': url});

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      loggerNoStack.i(responseData);
      await findGroup();
      await GroupHistoryData();
      return true;
    } else {
      loggerNoStack.e(response.body);

      return false;
    }
  }

  static Future<void> deleteGroup() async {
    print('deleteGroup');
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData?.first.groupId;

    final url = Uri.parse('$linkurl/users/$uid/groups/$groupId');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    loggerNoStack.t({'Name': 'deleteGroup', 'url': url});

    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.i(jsonBody);
      AppStateNotifier.instance.resetgroup();
    } else {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.e(jsonBody);
    }
  }

  static Future<void> leaveGroup() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData!.first.groupId;
    final url = Uri.parse('$linkurl/users/$uid/members/$groupId');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    loggerNoStack.t({'Name': 'leaveGroup', 'url': url});

    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.i(jsonBody);
      AppStateNotifier.instance.resetgroup();
    } else {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.e(jsonBody);
    }
  }

  static Future<void> KickGroup(String memberId) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    final url = Uri.parse('$linkurl/members/$memberId');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    loggerNoStack.t({'Name': 'KickGroup', 'url': url});

    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.i(jsonBody);
    } else {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.e(jsonBody);
    }
  }

  //참여신청 관리
  static Future<List<Invitation>> getInvitationByGroupId() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData?.first.groupId;

    final url = Uri.parse("$linkurl/users/$uid/groups/$groupId/invitations");
    final headers = {"accept": "*/*", "Authorization": "Bearer $token", "Content-Type": "application/json"};
    final response = await http.get(url, headers: headers);
    loggerNoStack.t({'Name': 'getInvitationByGroupId', 'url': url});
    print(response.statusCode);

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.i(jsonBody['data']);

      List<Invitation> invitations = (jsonBody['data'] as List).map((data) => Invitation.fromJson(data)).toList();
      return invitations;
    } else {
      loggerNoStack.e(response.body);
      throw Exception('Fail');
    }
  }

  //취소,거절,승인
  static Future<void> updateInvitation(String type, String invitationId) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    final url = Uri.parse('$linkurl/users/$uid/invitation/$invitationId?status=$type');
    final headers = {"accept": "*/*", "Authorization": "Bearer $token", "Content-Type": "application/json"};
    final response = await http.put(url, headers: headers);
    loggerNoStack.t({'Name': 'updateInvitation', 'url': url});

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.i(jsonBody['data']);
      await GroupApi.findGroup();
    } else {
      final responseBody = utf8.decode(response.bodyBytes);
      final jsonBody = json.decode(responseBody);
      loggerNoStack.e(jsonBody['data']);
      throw Exception('Fail');
    }
  }

  static Future<void> updateInvitationCode(String type, String code) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    final url = Uri.parse('$linkurl/users/$uid/invitation-codes/$code?status=$type');
    final headers = {"accept": "*/*", "Authorization": "Bearer $token", "Content-Type": "application/json"};
    final response = await http.put(url, headers: headers);
    loggerNoStack.t({'Name': 'updateInvitationCode', 'url': url});

    if (response.statusCode == 200) {
      print('Request successful');
      print('Response body: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

//초대 코드 생성
  static Future<void> createInvitationCode() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData?.first.groupId;
    try {
      final url = Uri.parse("$linkurl/users/$uid/groups/$groupId/invitation-codes");
      final headers = {"accept": "*/*", "Authorization": "Bearer $token", "Content-Type": "application/json"};
      final response = await http.post(url, headers: headers);
      loggerNoStack.t({'Name': 'createInvitationCode', 'url': url});

      if (response.statusCode == 201) {
        loggerNoStack.i(response.body);
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        AppStateNotifier.instance.UpGroupTicket(GroupTicket.fromJson(jsonResponse['data']));
      } else {
        loggerNoStack.i(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> getAllInvitationCodes() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData?.first.groupId;

    try {
      final url = Uri.parse("$linkurl/users/$uid/groups/$groupId/invitation-codes");
      final headers = {"accept": "*/*", "Authorization": "Bearer $token", "Content-Type": "application/json"};
      final response = await http.get(url, headers: headers);
      loggerNoStack.t({'Name': 'getAllInvitationCodes', 'url': url});

      if (response.statusCode == 200) {
        loggerNoStack.i(response.body);
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        var dataList = jsonResponse['data'];
        for (var item in dataList) {
          if (item['status'] == 'ACTIVE') {
            AppStateNotifier.instance.UpGroupTicket(GroupTicket.fromJson(item));
          }
        }
      } else {
        loggerNoStack.e(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  //초대 코드로 그룹 찾기

  static Future<Map<String, dynamic>> getGroupByInvitationCode(String invitationCode) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    final url = Uri.parse("$linkurl/invitation-codes/$invitationCode/group");
    final headers = {"accept": "*/*", "Authorization": "Bearer $token", "Content-Type": "application/json"};
    final response = await http.get(url, headers: headers);

    loggerNoStack.t({'Name': 'getGroupByInvitationCode', 'url': url});

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final groupData = responseData['data'];
      loggerNoStack.i(response.body);
      return groupData;
    } else {
      loggerNoStack.e(response.body);
      throw Exception('Failed to fetch group by invitation code');
    }
  }

//초대 생성
  static Future<bool> createInvitation(String code) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;

    final url = Uri.parse('$linkurl/users/$uid/invitations/$code');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      url,
      headers: headers,
    );
    loggerNoStack.t({'Name': 'createInvitation', 'url': url});

    if (response.statusCode == 201) {
      loggerNoStack.i(response.body);
      await GroupApi.getGroupInvitationByUser();

      return true;
    } else {
      print('초대 요청이 실패하였습니다. 상태 코드: ${response.statusCode}');
      loggerNoStack.i(response.body);
      return false;
    }
  }

//초대 내역 확인?
  static Future<String> getGroupInvitations() async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    final url = Uri.parse('$linkurl/api/groups/getGroupInvitationsByGroupLeader');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.body);
      throw Exception('Failed to getGroupInvitations ');
    }
  }

//초대 수락?
  Future<void> updateGroupInvitation(String token, String status, String userUid) async {
    final url = Uri.parse('$linkurl/api/groups/updateGroupInvitationByGroupLeader');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final data = {
      'status': status,
      'userUid': userUid,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('HTTP POST 요청이 성공하였습니다.');
    } else {
      print('HTTP POST 요청이 실패하였습니다. 상태 코드: ${response.statusCode}');
    }
  }

  //
  static String historytext(String text) {
    if (text == 'The group has been created.') {
      return '그룹 생성';
    } else if (text == 'A member has been added to the group.') {
      return '인원 추가';
    } else {
      return 'null';
    }
  }

  static Future<void> updateGroupInvitationByUser(String status, String invitationId) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;

    final url = Uri.parse('$linkurl/users/${uid}/invitation/${invitationId}');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final data = {
      'status': status,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(data),
    );
    loggerNoStack.t({'Name': 'updateGroupInvitationByUser', 'url': url, 'body': data});

    if (response.statusCode == 200) {
      loggerNoStack.i(response.body);
    } else {
      loggerNoStack.i(response.body);
    }
  }

  static Future<bool> updateGroupLeader(String memberUid) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData?.first.groupId;

    final url = Uri.parse('$linkurl/users/$uid/groups/$groupId?newGroupLeaderUid=$memberUid');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      url,
      headers: headers,
    );
    loggerNoStack.t({'Name': 'updateGroupLeader', 'url': url});

    if (response.statusCode == 200) {
      print(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    } else {
      print('updateGroupLeader 실패하였습니다. 상태 코드: ${response.statusCode}');
      return false;
    }
  }

  static Future<void> updateGroupname(String name) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    String? groupId = AppStateNotifier.instance.groupData?.first.groupId;

    final url = Uri.parse('$linkurl/users/$uid/groups/$groupId?newGroupName=$name');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      url,
      headers: headers,
    );
    loggerNoStack.t({'Name': 'updateGroupname', 'url': url});

    if (response.statusCode == 200) {
      loggerNoStack.i(response.body);
    } else {
      loggerNoStack.i(response.body);
    }
  }
}
