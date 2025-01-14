import 'package:flutter/material.dart';

class ScheduleResponse {
  final String code;
  final String message;
  final List<ScheduleData> data;

  ScheduleResponse({required this.code, required this.message, required this.data});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleResponse(
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List).map((item) => ScheduleData.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ScheduleData {
  String id;
  String uid;
  bool secret;
  List<String> members;
  String category;
  String title;
  String description;
  int maxDailyNotifications;
  DateTime startDate;
  DateTime endDate;
  DateTime targetDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<int> repeatDays;
  List<TimeOfDay> notificationTimes;

  ScheduleData({
    required this.id,
    required this.uid,
    required this.secret,
    required this.members,
    required this.category,
    required this.title,
    required this.description,
    required this.maxDailyNotifications,
    required this.startDate,
    required this.endDate,
    required this.targetDate,
    required this.startTime,
    required this.endTime,
    required this.repeatDays,
    required this.notificationTimes,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      id: json['id'],
      uid: json['uid'],
      secret: json['secret'],
      members: List<String>.from(json['members']),
      category: json['category'],
      title: json['title'],
      description: json['description'],
      maxDailyNotifications: json['maxDailyNotifications'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      targetDate: DateTime.parse(json['targetDate']),
      startTime: _parseTimeOfDay(json['startTime']),
      endTime: _parseTimeOfDay(json['endTime']),
      repeatDays: List<int>.from(json['repeatDays']),
      notificationTimes: (json['notificationTimes'] as List).map((time) => _parseTimeOfDay(time)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'secret': secret,
      'members': members,
      'category': category,
      'title': title,
      'description': description,
      'maxDailyNotifications': maxDailyNotifications,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'targetDate': targetDate.toIso8601String(),
      'startTime': _formatTimeOfDay(startTime),
      'endTime': _formatTimeOfDay(endTime),
      'repeatDays': repeatDays,
      'notificationTimes': notificationTimes.map(_formatTimeOfDay).toList(),
    };
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }
}
