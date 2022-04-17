import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  late SharedPreferences prefs;
  Settings._();
  static final _singleton = Settings._();
  static Settings get instance => _singleton;
  bool _isInit = false;


  Future<void> init () async {
    prefs = await SharedPreferences.getInstance();
    _isInit = true;
  }

  Future<void> setDaysDeadline(int daysDeadline)  async {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    await prefs.setInt('days', daysDeadline);
  }

  Future<void> setGroup(String group) async {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    await prefs.setString('group', group);
  }

  Future<void> setTimeNotification(TimeOfDay timeOfDay) async {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    final time = DateTime(0, 1, 1, timeOfDay.hour, timeOfDay.minute);
    await prefs.setString('time_notifications', time.toString());
  }

  int getDays() {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    return prefs.getInt('days') ?? 3;
  }

  String? getGroup() {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    return prefs.getString('group');
  }

  TimeOfDay getTimeNotification() {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    final value = prefs.getString('time_notifications');
    if (value == null){
      throw Exception('Time notifications not exist in the settings');
    }
    final dateTime = DateTime.parse(value);
    return TimeOfDay.fromDateTime(dateTime);
  }
}

final settingsProvider = Provider((ref) => Settings.instance);