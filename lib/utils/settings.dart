import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Данная утилита хранит все настройки.
class Settings {
  late SharedPreferences prefs;
  Settings._();
  static final _singleton = Settings._();
  static Settings get instance => _singleton;
  final _complete = Completer<bool>();

  Future<void> get initialized => _complete.future;

  /// Перед использованием необходимо проинициализирвать утилиту
  Future<void> init () async {
    if (_complete.isCompleted) {
      return;
    }

    prefs = await SharedPreferences.getInstance();
    _complete.complete(true);
  }

  Future<void> setDaysDeadline(int daysDeadline) async {
    await initialized;
    await prefs.setInt('days', daysDeadline);
  }

  Future<void> setGroup(String group) async {
    await initialized;
    await prefs.setString('group', group);
  }

  Future<void> setTimeNotification(TimeOfDay timeOfDay) async {
    await initialized;
    final time = DateTime(0, 1, 1, timeOfDay.hour, timeOfDay.minute);
    await prefs.setString('time_notifications', time.toString());
  }

  Future<int> getDays() async {
    await initialized;
    return prefs.getInt('days') ?? 3;
  }

  Future<String?> getGroup() async {
    await initialized;
    return prefs.getString('group');
  }

  Future<TimeOfDay> getTimeNotification() async {
    await initialized;
    final value = prefs.getString('time_notifications');
    if (value == null) {
      return const TimeOfDay(hour: 12, minute: 0);
    }
    final dateTime = DateTime.parse(value);
    return TimeOfDay.fromDateTime(dateTime);
  }
}

final settingsProvider = Provider((ref) => Settings.instance);
