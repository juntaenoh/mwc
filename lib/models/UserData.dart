import 'dart:convert';

class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String? gender;
  final String? birthday;
  final String? region;
  final double height;
  final double weight;

  UserData({
    required this.uid,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    required this.gender,
    required this.birthday,
    required this.region,
    required this.height,
    required this.weight,
  });

  // JSON에서 UserData 객체로 변환
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      photoUrl: json['photoUrl'],
      gender: json['gender'],
      birthday: json['birthday'],
      region: json['region'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
    );
  }

  // UserData 객체에서 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl,
      'gender': gender,
      'birthday': birthday,
      'region': region,
      'height': height,
      'weight': weight,
    };
  }

  String toString() {
    return ' uid: $uid \n firstName: $firstName \n lastName: $lastName \n photoUrl: $photoUrl \n gender: $gender \n birthday: $birthday \n region: $region \n height: $height \n weight: $weight';
  }

  // 객체를 JSON 문자열로 변환
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // JSON 문자열에서 UserData 객체로 변환
  static UserData fromJsonString(String jsonString) {
    return UserData.fromJson(jsonDecode(jsonString));
  }
}
