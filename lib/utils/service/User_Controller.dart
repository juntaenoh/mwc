import 'dart:convert';
import 'package:mwc/main.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/models/UserData.dart';
import 'package:mwc/models/testuser.dart';
import 'package:mwc/models/validate_login.dart';
import 'package:mwc/widgets/custom_dialog.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:mwc/index.dart';

class UserController {
  static const _testuserdata = 'testuserdata';
  static String linkurl = mainurl;

  //유효성 검사
  static Future<ValidateData?> validate(String text, String inputType) async {
    String encodedText = Uri.encodeComponent(text);
    var url = inputType == 'phone' ? Uri.parse('$linkurl/validate?phoneNumber=$encodedText') : Uri.parse('$linkurl/validate?email=$text');
    var headers = {'accept': '*/*', 'Content-Type': 'application/json'};

    try {
      loggerNoStack.t({'Name': 'validate', 'url': url});
      var response = await http.post(url, headers: headers);
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        ValidateData validateData = ValidateData.fromJson(jsonResponse['data']);
        return validateData;
      } else {
        print('null');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //유효성 검사
  static Future<ValidateData?> validateLogin(bool isSuccess, String email) async {
    var url = Uri.parse('$linkurl/validete-login?inSuccess=$isSuccess&email=$email');
    var headers = {'accept': '*/*', 'Content-Type': 'application/json'};

    try {
      loggerNoStack.t({'Name': 'validate_login', 'url': url});
      var response = await http.post(url, headers: headers);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        ValidateData validateData = ValidateData.fromJson(jsonResponse['data']);
        return validateData;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to validate login: $e');
    }
  }

  static Future<void> deleteUser() async {
    print('deleteUser');
    // final String? token = await UserController.getsavedToken();
    final String? token = await AppStateNotifier.instance.getAccessToken();
    String? uid = AppStateNotifier.instance.userdata?.uid;
    if (token == null || uid == null) {
      loggerNoStack.e('토큰이나 UID가 null입니다.');
      return;
    }

    var url = Uri.parse('$linkurl/users/$uid');
    var headers = {'accept': '*/*', 'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

    var response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      await AppStateNotifier.instance.logout();
    } else {
      print(response.statusCode);
    }
  }

  // 토큰 생성
  static Future<void> CreateNewToken(String token) async {
    try {
      final url = Uri.parse('$linkurl/auth/tokens?firebaseToken=$token');

      final response = await http.post(url);
      loggerNoStack.t({'Name': 'CreateNewToken', 'url': url});

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);

        String newtoken = jsonResponse['token']['accessToken'];
        String refreshToken = jsonResponse['token']['refreshToken'];
        await AppStateNotifier.instance.UpToken(newtoken, true);
        await AppStateNotifier.instance.UprefreshToken(refreshToken);
      } else {}
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> RefreshNewToken(String token) async {
    try {
      final url = Uri.parse('$linkurl/auth/access-token?refreshToken=$token');
      final response = await http.post(url);
      loggerNoStack.t({'Name': 'RefreshNewToken', 'url': url});
      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);

        String refreshToken = jsonResponse['token']['accessToken'];

        await AppStateNotifier.instance.UpToken(refreshToken, true);
      } else {
        loggerNoStack.e(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<bool> signUpInputData(
      String? birthday, String firstName, String lastName, String gender, double height, double weight, String optionRegion) async {
    String token = await AppStateNotifier.instance.firebaseToken!;
    print(token);

    final url = Uri.parse('$linkurl/users').replace(queryParameters: {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      if (birthday != null) 'birthday': birthday,
      //'region': optionRegion,
      'height': height.toString(),
      'weight': weight.toString(),
      'firebaseToken': token,
    });

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    loggerNoStack.t({'Name': 'signUpInputData', 'url': url});

    try {
      final response = await http.post(url, headers: headers);
      print(response.body);
      if (response.statusCode == 201) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        print(jsonResponse);

        String newtoken = jsonResponse['token']['accessToken'];
        String refreshToken = jsonResponse['token']['refreshToken'];
        await AppStateNotifier.instance.UpToken(newtoken, true);
        await AppStateNotifier.instance.UprefreshToken(refreshToken);

        AppStateNotifier.instance.UpUserInfo(UserData.fromJson(jsonResponse['data']));
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> gettestuser() async {
    final url = Uri.parse('http://${AppStateNotifier.instance.testurl}/demo/v1/users/0ca1fde8-0f50-4f1b-bebe-f0b32bb44d0a');

    final headers = {
      'accept': '*/*',
      'Content-Type': 'application/json',
    };
    loggerNoStack.t({'Name': 'gettest', 'url': url});

    try {
      final response = await http.get(url, headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        print(jsonResponse);

        TestUser userData = TestUser.fromJson(jsonResponse);
        AppStateNotifier.instance.UptestUserInfo(userData);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> modiProfile(
      String birthday, String firstName, String lastName, String gender, double height, double weight, File? image) async {
    String? uid = AppStateNotifier.instance.userdata?.uid;
    final String? token = await AppStateNotifier.instance.getAccessToken();

    final url =
        Uri.parse('$linkurl/users/${uid}?firstName=$firstName&lastName=$lastName&gender=$gender&birthday=$birthday&height=$height&weight=$weight');

    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body =
        jsonEncode({'firstName': firstName, "lastName": lastName, "gender": gender, "birthday": birthday, "height": height, "weight": weight});
    loggerNoStack.t({'Name': 'modiProfile', 'url': url, 'body': body});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);

        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);

        AppStateNotifier.instance.UpUserInfo(UserData.fromJson(jsonResponse['data']));
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        loggerNoStack.e(jsonResponse);

        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  static Future<void> uploadProfileImage(bool isimage, File? image) async {
    print('image');
    print(isimage);
    print(image);

    String? uid = AppStateNotifier.instance.userdata?.uid;
    final String? token = await AppStateNotifier.instance.getAccessToken();

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$linkurl/users/$uid/photo?upload=$isimage'),
    );

    request.headers.addAll(headers);

    isimage
        ? request.files.add(await http.MultipartFile.fromPath(
            'file',
            image?.path ?? '',
          ))
        : null;
    loggerNoStack.t({'Name': 'uploadProfileImage', 'request': request, 'file': image?.path});

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Upload successful');
        print(await response.stream.bytesToString());
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Upload failed with error: $e');
    }
  }

  static Future<bool> getprofile(String token) async {
    final url = Uri.parse('$linkurl/profile');

    final response = await http.get(
      url,
      headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
    );
    loggerNoStack.t({'Name': 'getprofile', 'url': url, 'token': token});

    if (response.statusCode == 200) {
      loggerNoStack.i(response.body);
      String decodedBody = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(decodedBody);
      AppStateNotifier.instance.UpUserInfo(UserData.fromJson(jsonResponse['data']));
      return true;
    } else {
      loggerNoStack.e(response.body);
      return false;
    }
  }

  static Future<void> updatetester(
      String birthday, String firstName, String lastName, String gender, double height, double weight, String underlyingConditions) async {
    print('Start -------- updatetester');
    Map<String, dynamic> body = ({
      "birthday": birthday,
      'firstName': firstName,
      "lastName": lastName,
      "gender": gender,
      "height": height,
      "weight": weight,
      "underlyingConditions": underlyingConditions
    });
    await savetester(body);
  }

  static Future<bool> testGetAuth(
      String occupation, String phoneNumber, String? email, String address, String? detailedAddress, String region) async {
    final Map<String, dynamic> testerData = await gettester();
    print(testerData);
    final String? birthday = testerData['birthday'];
    final String? firstName = testerData['firstName'];
    final String? lastName = testerData['lastName'];
    final String? gender = testerData['gender'];
    final double? height = testerData['height'];
    final double? weight = testerData['weight'];
    final String? underlyingConditions = testerData['underlyingConditions'];

    final queryParams = {
      "birthday": birthday,
      'firstName': firstName,
      "lastName": lastName,
      "gender": gender,
      "height": height.toString(),
      "weight": weight.toString(),
      if (underlyingConditions != 'none') "underlyingConditions": underlyingConditions,
      'occupation': occupation,
      'phoneNumber': phoneNumber,
      "region": 'IT',
      if (email != null && email.isNotEmpty && email != '') 'email': email,
      'address': address,
      if (detailedAddress != null && detailedAddress.isNotEmpty && detailedAddress != '') 'detailedAddress': detailedAddress,
    };

    final uri = Uri.https('carencoinc.com', '/it/service/test/users', queryParams);

    loggerNoStack.t({
      'Name': 'testGetAuth',
      'url': uri,
    });

    try {
      final response = await http.post(
        uri,
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);

        String newtoken = jsonResponse['data']['uid'];
        await AppStateNotifier.instance.Uptestuid(newtoken);
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        loggerNoStack.e(jsonResponse);
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  static Future<bool> getdatamode(
    String birthday,
    String gender,
    double height,
    String? email,
  ) async {
    final body = jsonEncode({
      'email': email ?? null,
      'gender': gender,
      'birthday': birthday,
      'height': height,
    });
    var url = Uri.parse('http://${AppStateNotifier.instance.testurl}/demo/v1/users');
    var headers = {'accept': '*/*', 'Content-Type': 'application/json'};

    loggerNoStack.t({'Name': 'getdatamode', headers: headers, 'url': url, 'body': body});

    try {
      var response = await http.post(url, headers: headers, body: body);

      print(response);
      print(response.statusCode);
      if (response.statusCode == 201) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);
        String newtoken = jsonResponse['uid'];
        await AppStateNotifier.instance.Uptestuid(newtoken);
        TestUser userData = TestUser.fromJson(jsonResponse);
        AppStateNotifier.instance.UptestUserInfo(userData);
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        loggerNoStack.e(jsonResponse);
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  static Future<bool> recoverGetAuth(String birthday, String firstName, String lastName) async {
    final queryParams = {
      "birthday": birthday,
      'firstName': firstName,
      "lastName": lastName,
    };

    final uri = Uri.http('15.165.125.100:8080', '/kr/carenco-service/api/v1/test/users', queryParams);

    loggerNoStack.t({
      'Name': 'recoverGetAuth',
      'url': uri,
    });

    try {
      final response = await http.get(
        uri,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);

        String newtoken = jsonResponse['data']['uid'];
        await AppStateNotifier.instance.Uptestuid(newtoken);
        return true;
      } else {
        var jsonResponse = jsonDecode(response.body);
        loggerNoStack.e(jsonResponse);
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  static Future<bool> savetester(Map<String, dynamic> data) async {
    print('savetester');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_testuserdata, jsonEncode(data));
    return true;
  }

  static Future<Map<String, dynamic>> gettester() async {
    print('Start ------ gettester');
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_testuserdata) == null) {
      return {};
    } else {
      String? jsonData = prefs.getString(_testuserdata);
      return jsonDecode(jsonData!);
    }
  }

  static Future<String?> removetester() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_testuserdata);
    AppStateNotifier.instance.logout();
    print('removedata');
    return null;
  }
}
