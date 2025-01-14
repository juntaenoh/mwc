import 'dart:convert';
import 'package:mwc/main.dart';
import 'package:mwc/models/Schedule.dart';
import 'package:mwc/models/UserData.dart';

import 'package:http/http.dart' as http;

import 'package:mwc/index.dart';

class ScheduleService {
  static String linkurl = mainurl;

  static Future<bool> createScheduleInputData(String category, String title, String description, int maxDailyNotifications, String startDate,
      String endDate, String startTime, String endTime, List<int> repeatDays, List<String> notificationTimes, String notificationOption) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();
    String? uid = AppStateNotifier.instance.userdata?.uid;
    final url = Uri.parse('$linkurl/users/$uid/schedule');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "category": category,
      "title": title,
      "description": description,
      "maxDailyNotifications": maxDailyNotifications,
      "startDate": startDate,
      "endDate": endDate,
      "startTime": startTime,
      "endTime": endTime,
      "repeatDays": repeatDays,
      "notificationTimes": notificationTimes,
      "notificationOption": notificationOption,
    });

    loggerNoStack.t({'Name': 'createScheduleInputData', 'url': url, 'body': body});
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);
        return true;
      } else {
        loggerNoStack.e(response.body);
        return false;
      }
    } catch (e) {
      loggerNoStack.e(e);
      return false;
    }
  }

  static Future<void> getScheduleData(String from, String to) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();
    String? uid = AppStateNotifier.instance.userdata?.uid;
    final url = Uri.parse('$linkurl/users/$uid/schedule?from=$from&to=$to');
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    loggerNoStack.t({'Name': 'getScheduleData', 'url': url});
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final jsonBody = json.decode(responseBody);
        loggerNoStack.i(jsonBody);
        if (jsonBody['data'] != null && jsonBody['data'].isNotEmpty) {
          List<ScheduleData> data = (jsonBody['data'] as List).map((m) => ScheduleData.fromJson(m)).toList();
          AppStateNotifier.instance.UpSchadule(data);
        }
      } else {
        loggerNoStack.e(response.body);
        List<ScheduleData> data = [];
        AppStateNotifier.instance.UpSchadule(data);
        throw Exception('Failed to load schedule data');
      }
    } catch (e) {
      loggerNoStack.e(e);
      throw Exception('Failed to load schedule data');
    }
  }
}
