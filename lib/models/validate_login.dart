class UserResponse {
  final String code;
  final String message;
  final ValidateData data;

  UserResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  // JSON 데이터를 UserResponse 객체로 변환하는 팩토리 생성자
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      data: ValidateData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  // UserResponse 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ValidateData {
  final String? phoneNumber;
  final int attemptsCount;
  final bool accountLocked;
  final bool expired;
  final DateTime? expiredDate;
  final String? expiredTime;
  final String? email;

  ValidateData({
    this.phoneNumber,
    required this.attemptsCount,
    required this.accountLocked,
    required this.expired,
    this.expiredDate,
    this.expiredTime,
    this.email,
  });

  factory ValidateData.fromJson(Map<String, dynamic> json) {
    return ValidateData(
      phoneNumber: json['phoneNumber'] as String?,
      attemptsCount: json['attemptsCount'] as int,
      accountLocked: json['accountLocked'] as bool,
      expired: json['expired'] as bool,
      expiredDate: json['expiredDate'] != null ? DateTime.parse(json['expiredDate'] as String) : null,
      expiredTime: json['expiredTime'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'attemptsCount': attemptsCount,
      'accountLocked': accountLocked,
      'expired': expired,
      'expiredDate': expiredDate?.toIso8601String(),
      'expiredTime': expiredTime,
      'email': email,
    };
  }
}
