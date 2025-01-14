import 'dart:convert';

class GroupTicket {
  final String invitationCodeId;
  final String code;
  final String status;
  final DateTime expirationTime;
  final Group group;

  GroupTicket({
    required this.invitationCodeId,
    required this.code,
    required this.status,
    required this.expirationTime,
    required this.group,
  });

  factory GroupTicket.fromJson(Map<String, dynamic> json) {
    return GroupTicket(
      invitationCodeId: json['invitationCodeId'],
      code: json['code'],
      status: json['status'],
      expirationTime: DateTime.parse(json['expirationTime']),
      group: Group.fromJson(json['group']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invitationCodeId': invitationCodeId,
      'code': code,
      'status': status,
      'expirationTime': expirationTime.toIso8601String(),
      'group': group.toJson(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class Group {
  final String groupId;
  final String groupName;
  final String groupStatus;
  final String groupType;

  Group({
    required this.groupId,
    required this.groupName,
    required this.groupStatus,
    required this.groupType,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      groupName: json['groupName'],
      groupStatus: json['groupStatus'],
      groupType: json['groupType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupStatus': groupStatus,
      'groupType': groupType,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
