import 'dart:convert';

class GroupData {
  String groupId;
  String groupName;
  String groupType;
  String groupStatus;
  List<Member> members;

  GroupData({
    required this.groupId,
    required this.groupName,
    required this.groupType,
    required this.groupStatus,
    required this.members,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      groupId: json['groupId'],
      groupName: json['groupName'],
      groupType: json['groupType'],
      groupStatus: json['groupStatus'],
      members: (json['members'] as List).map((m) => Member.fromJson(m)).toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupType': groupType,
      'groupStatus': groupStatus,
      'members': members.map((m) => m.toJson()).toList(),
    };
  }

  static GroupData fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final data = jsonMap['data'][0];
    return GroupData.fromJson(data);
  }

  @override
  String toString() {
    return 'Group ID: $groupId, Group Name: $groupName, Members Count: ${members.length}';
  }
}

class Member {
  String memberId;
  String uid;
  String authority;
  String firstName;
  String lastName;
  String? photoUrl;
  Status? status;

  Member({
    required this.memberId,
    required this.uid,
    required this.authority,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.status,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      uid: json['uid'],
      authority: json['authority'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      photoUrl: json['photoUrl'],
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'uid': uid,
      'authority': authority,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl,
      'status': status?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Member ID: $memberId, Authority: $authority';
  }
}

class Status {
  String id;
  bool humanHeight;
  bool humanWeight;
  bool humanFootprint;
  bool schedule;

  Status({
    required this.id,
    required this.humanHeight,
    required this.humanWeight,
    required this.humanFootprint,
    required this.schedule,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] ?? '',
      humanHeight: json['humanHeight'] ?? false,
      humanWeight: json['humanWeight'] ?? false,
      humanFootprint: json['humanFootprint'] ?? false,
      schedule: json['schedule'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'humanHeight': humanHeight,
      'humanWeight': humanWeight,
      'humanFootprint': humanFootprint,
      'schedule': schedule,
    };
  }
}
