import 'dart:convert';

class TestUser {
  String uid;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? gender;
  String? birthday;
  double height;
  double? weight;
  String? address;
  String? detailedAddress;
  String? underlyingConditions;
  String? occupation;
  List<TestUserRecord> TestUserRecords;

  TestUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.birthday,
    required this.height,
    required this.weight,
    required this.address,
    required this.detailedAddress,
    this.underlyingConditions,
    this.occupation,
    required this.TestUserRecords,
  });

  // JSON 데이터를 받아 TestUser 객체로 변환하는 factory 생성자
  factory TestUser.fromJson(Map<String, dynamic> json) {
    return TestUser(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      birthday: json['birthday'],
      height: (json['height'] != null) ? json['height'].toDouble() : null,
      weight: (json['weight'] != null) ? json['weight'].toDouble() : null,
      address: json['address'],
      detailedAddress: json['detailedAddress'],
      underlyingConditions: json['underlyingConditions'],
      occupation: json['occupation'],
      TestUserRecords:
          (json['userRecords'] != null) ? (json['userRecords'] as List).map((i) => TestUserRecord.fromJson(i)).toList() : [], // null일 경우 빈 리스트로 처리
    );
  }

  // TestUser 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'address': address,
      'detailedAddress': detailedAddress,
      'underlyingConditions': underlyingConditions,
      'occupation': occupation,
      'userRecords': TestUserRecords.map((e) => e.toJson()).toList(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class TestUserRecord {
  String recordId;
  DateTime measuredDate; // 날짜
  DateTime measuredTime; // 시간 (실제 DateTime 타입)
  String rawData;
  double weight;
  int classType;
  int accuracy;
  String imageUrl;

  TestUserRecord({
    required this.recordId,
    required this.measuredDate,
    required this.measuredTime,
    required this.rawData,
    required this.weight,
    required this.classType,
    required this.accuracy,
    required this.imageUrl,
  });

  // JSON 데이터를 받아 TestUserRecord 객체로 변환하는 factory 생성자
  factory TestUserRecord.fromJson(Map<String, dynamic> json) {
    return TestUserRecord(
      recordId: json['recordId'],
      measuredDate: DateTime.parse(json['measuredDate']), // 날짜는 DateTime으로 파싱
      measuredTime: parseTime(json['measuredTime']), // 시간만 있는 경우 처리
      rawData: json['rawData'],
      weight: (json['weight'] != null) ? json['weight'].toDouble() : null,
      classType: json['classType'],
      accuracy: json['accuracy'],
      imageUrl: json['imageUrl'],
    );
  }

  // 시간 문자열을 DateTime으로 변환 (기본 날짜에 시간 적용)
  static DateTime parseTime(String timeString) {
    final now = DateTime.now(); // 오늘 날짜를 기준으로 사용
    if (timeString.contains(':') && timeString.length == 8) {
      // 시간만 있는 경우
      final timeParts = timeString.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]), // 시
        int.parse(timeParts[1]), // 분
        int.parse(timeParts[2]), // 초
      );
    } else {
      // 만약 시간 형식이 맞지 않다면 기본값 반환 (예외 처리)
      throw FormatException('Invalid time format');
    }
  }

  // TestUserRecord 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'recordId': recordId,
      'measuredDate': measuredDate.toIso8601String().split('T')[0], // 날짜만 저장
      'measuredTime': measuredTime.toIso8601String().split('T')[1], // 시간만 저장
      'rawData': rawData,
      'weight': weight,
      'classType': classType,
      'accuracy': accuracy,
      'imageUrl': imageUrl,
    };
  }
}
