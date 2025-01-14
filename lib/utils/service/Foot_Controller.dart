import 'dart:convert';

import 'package:mwc/index.dart';
import 'package:mwc/main.dart';
import 'package:mwc/models/FootData.dart';
import 'package:mwc/models/WeightData.dart';
import 'package:http/http.dart' as http;

class FootprintApi {
  static String linkurl = mainurl;

  static String printUTCTime() {
    DateTime nowUTC = DateTime.now().toLocal();
    print(nowUTC);
    String utcString = nowUTC.toIso8601String();
    print(utcString);

    String result = utcString.substring(0, utcString.length - 1) + '+00:00';
    //String result = '2024-03-13T02:23:04.909893+00:00';
    return result;
  }

  static String formatToISO8601(DateTime dateTime) {
    // Use DateFormat to format the DateTime
    final DateFormat formatter = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'");
    return formatter.format(dateTime.toUtc());
  }

  static Future<bool?> footScan(String rawdata) async {
    DateTime utcNow = DateTime.now().toUtc();

    // Convert and format the time
    String formattedDate = formatToISO8601(utcNow);
    bool va = false;

    String? uid = AppStateNotifier.instance.testuid;

    var url = Uri.parse('http://${AppStateNotifier.instance.testurl}/demo/v1/users/${uid}/footprints');
    var headers = {'accept': '*/*', 'Content-Type': 'application/json'};

    var body = jsonEncode({'rawData': rawdata, 'mesuredDateTime': formattedDate});
    loggerNoStack.t({'Name': 'footScan', 'url': url, 'mesuredDateTimee': formattedDate, 'data': rawdata.length.toString()});

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);

        await AppStateNotifier.instance.UpScanData(jsonResponse).then((value) {
          va = true;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        va = false;
      }
    } on Exception catch (e) {
      loggerNoStack.e(e);
    }
    return va;
  }

  static Future<bool?> testfootScan(List datalist) async {
    String date = printUTCTime();
    bool va = false;
    String? token = AppStateNotifier.instance.apiToken;

    String? uid = AppStateNotifier.instance.testuid;

    //var url = Uri.parse('https://carencoinc.com/it/service/test/users/$uid/footprints');
    final uri = Uri.http('15.165.125.100:8080', '/kr/carenco-service/api/v1/test/users/$uid/footprints');

    var headers = {'accept': '*/*', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    var body = json.encode(datalist);
    loggerNoStack.t({'Name': 'testfootScan', 'url': uri, 'mesured_time': date, 'count': body.length.toString()});

    try {
      // HTTP 요청에 타임아웃을 30초로 설정
      var response = await http.post(uri, headers: headers, body: body).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(decodedBody);
        loggerNoStack.i(jsonResponse);

        await AppStateNotifier.instance.UpScanData(jsonResponse['data'][0]).then((value) {
          va = true;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        va = false;
      }
    } on http.ClientException catch (e) {
      // HTTP 클라이언트 예외 처리
      loggerNoStack.e(e);
      va = false;
    } on TimeoutException catch (e) {
      // 타임아웃 예외 처리
      loggerNoStack.e('Request timed out: $e');
      va = false;
    } on Exception catch (e) {
      // 기타 예외 처리
      loggerNoStack.e(e);
      va = false;
    }

    return va;
  }

  static Future<void> getfoothistory(String from, String to) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    if (token == null || uid == null) {
      loggerNoStack.e('토큰이나 UID가 null입니다.');
      return;
    }

    var url = Uri.parse('$linkurl/users/$uid/footprints?from=$from&to=$to');
    var headers = {'accept': '*/*', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    loggerNoStack.t({'Name': 'getfoothistory', 'url': url});

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // 응답 데이터 디코딩 및 null 체크
      List<dynamic> responseData = jsonDecode(response.body)['data'] ?? [];
      loggerNoStack.i(response.body);

      // 응답 데이터가 null이 아니고 비어있지 않은지 확인
      if (responseData.isNotEmpty) {
        List<FootData> footHistory = responseData.map((data) => FootData.fromJson(data)).toList();
        await AppStateNotifier.instance.Upfoothistory(footHistory);
        await AppStateNotifier.instance.sortfootdata('new');
      } else {
        // 응답 데이터가 비어있는 경우 처리
        await AppStateNotifier.instance.delfoothistory();
        print(AppStateNotifier.instance.footdata);
        loggerNoStack.i('응답 데이터가 비어있습니다.');
      }
    } else {
      loggerNoStack.e(response.body);
    }
  }

  static Future<void> deleteSomePrint(String id) async {
    DateTime now = DateTime.now();
    String toDate = DateFormat('yyyy/MM/dd').format(now);
    DateTime monthsBefore = DateTime(now.year, now.month - 3, now.day);
    String fromDate = DateFormat('yyyy/MM/dd').format(monthsBefore);
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    if (token == null || uid == null) {
      loggerNoStack.e('토큰이나 UID가 null입니다.');
      return;
    }

    var url = Uri.parse('$linkurl/users/$uid/footprints?id=$id');
    var headers = {'accept': '*/*', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    loggerNoStack.t({'Name': 'deleteSomePrint', 'url': url});

    var response = await http.delete(url, headers: headers);
    print(response.statusCode);

    if (response.statusCode == 200) {
      // 응답 데이터 디코딩 및 null 체크
      List<dynamic> responseData = jsonDecode(response.body)['data'] ?? [];
      loggerNoStack.i(responseData);
      await getfoothistory('${fromDate}', '${toDate}');
    } else {
      loggerNoStack.e(response.body);
    }
  }

  static Future<void> deleteSomeWegith(String? id) async {
    DateTime now = DateTime.now();
    String toDate = DateFormat('yyyy/MM/dd').format(now);
    DateTime monthsBefore = DateTime(now.year, now.month - 3, now.day);
    String fromDate = DateFormat('yyyy/MM/dd').format(monthsBefore);
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    if (token == null || uid == null) {
      loggerNoStack.e('토큰이나 UID가 null입니다.');
      return;
    }

    var url = Uri.parse('$linkurl/users/$uid/weights?id=$id');
    var headers = {'accept': '*/*', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    loggerNoStack.t({'Name': 'deleteSomePrint', 'url': url});

    var response = await http.delete(url, headers: headers);
    print(response.statusCode);

    if (response.statusCode == 200) {
      // 응답 데이터 디코딩 및 null 체크
      List<dynamic> responseData = jsonDecode(response.body)['data'] ?? [];
      loggerNoStack.i(responseData);
      await getweighthistory('${fromDate}', '${toDate}');
    } else {
      loggerNoStack.e(response.body);
    }
  }

  static Future<void> deleteAllWegith() async {
    DateTime now = DateTime.now();
    String toDate = DateFormat('yyyy/MM/dd').format(now);
    DateTime monthsBefore = DateTime(now.year, now.month - 3, now.day);
    String fromDate = DateFormat('yyyy/MM/dd').format(monthsBefore);
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    if (token == null || uid == null) {
      loggerNoStack.e('토큰이나 UID가 null입니다.');
      return;
    }

    var url = Uri.parse('$linkurl/users/$uid/weights?from=$fromDate&to=$toDate');
    var headers = {'accept': '*/*', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    loggerNoStack.t({'Name': 'deleteSomePrint', 'url': url});

    var response = await http.delete(url, headers: headers);
    print(response.statusCode);

    if (response.statusCode == 200) {
      // 응답 데이터 디코딩 및 null 체크
      List<dynamic> responseData = jsonDecode(response.body)['data'] ?? [];
      loggerNoStack.i(responseData);
      await getweighthistory('${fromDate}', '${toDate}');
    } else {
      loggerNoStack.e(response.body);
    }
  }

  static Future<void> getweighthistory(String from, String to) async {
    final String? token = await AppStateNotifier.instance.getAccessToken();

    String? uid = AppStateNotifier.instance.userdata?.uid;
    if (token == null || uid == null) {
      loggerNoStack.e('토큰이나 UID가 null입니다.');
      return;
    }
    var url = Uri.parse('$linkurl/users/$uid/weights?from=$from&to=$to');
    var headers = {'accept': '*/*', 'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

    var response = await http.get(url, headers: headers);
    loggerNoStack.t({'Name': 'getweighthistory', 'url': url});
    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['data'];
      loggerNoStack.i(response.body);
      List<WeightData> WeightHistory = responseData.map((data) => WeightData.fromJson(data)).toList();
      calculateWeightChanges(WeightHistory);
      await AppStateNotifier.instance.UpWeightHistory(WeightHistory);
      await AppStateNotifier.instance.sortweightdata('old');
    } else {
      loggerNoStack.e(response.body);
    }
  }

  static void calculateWeightChanges(List<WeightData> weightDataList) {
    // 날짜 순서대로 정렬
    weightDataList.sort((a, b) => a.measuredTime.compareTo(b.measuredTime));

    for (int i = 1; i < weightDataList.length; i++) {
      weightDataList[i].weightChange = weightDataList[i].weight - weightDataList[i - 1].weight;
    }
  }
}
