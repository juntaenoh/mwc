class Invitation {
  final String invitationId;
  final String type;
  final String requestUid;
  final String requestUserFirstName;
  final String requestUserLastName;
  final String responseUid;
  final String responseUserFirstName;
  final String responseUserLastName;
  final String status;
  final Group? group;

  Invitation({
    required this.invitationId,
    required this.type,
    required this.requestUid,
    required this.requestUserFirstName,
    required this.requestUserLastName,
    required this.responseUid,
    required this.responseUserFirstName,
    required this.responseUserLastName,
    required this.status,
    this.group,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      invitationId: json['invitationId'],
      type: json['type'],
      requestUid: json['requestUid'],
      requestUserFirstName: json['requestUserFirstName'],
      requestUserLastName: json['requestUserLastName'],
      responseUid: json['responseUid'],
      responseUserFirstName: json['responseUserFirstName'],
      responseUserLastName: json['responseUserLastName'],
      status: json['status'],
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invitationId': invitationId,
      'type': type,
      'requestUid': requestUid,
      'requestUserFirstName': requestUserFirstName,
      'requestUserLastName': requestUserLastName,
      'responseUid': responseUid,
      'responseUserFirstName': responseUserFirstName,
      'responseUserLastName': responseUserLastName,
      'status': status,
      'group': group?.toJson(),
    };
  }
}

class Group {
  final String groupId;
  final String groupName;

  Group({
    required this.groupId,
    required this.groupName,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'],
      groupName: json['groupName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
    };
  }
}
