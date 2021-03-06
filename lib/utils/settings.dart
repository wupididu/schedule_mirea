import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/models/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Данная утилита хранит все настройки.
class Settings {
  late SharedPreferences prefs;
  Settings._();
  static final _singleton = Settings._();
  static Settings get instance => _singleton;
  final _complete = Completer<bool>();
  final StreamController<SettingsState> _controller =
      StreamController<SettingsState>();

  Stream<SettingsState> get stream => _controller.stream;

  SettingsState? state;

  Future<void> get initialized => _complete.future;

  /// Перед использованием необходимо проинициализирвать утилиту
  Future<void> init() async {
    if (_complete.isCompleted) {
      return;
    }

    prefs = await SharedPreferences.getInstance();
    _complete.complete(true);

    final dayNotification = await getDays();
    final timeNotification = await getTimeNotification();
    final groupCode = await getGroup();

    state = SettingsState(
        groupCode: groupCode,
        dayNotification: dayNotification,
        timeNotification: timeNotification);

    _controller.add(state!);
  }

  Future<void> setDaysDeadline(int daysDeadline) async {
    await initialized;
    await prefs.setInt('days', daysDeadline);

    state = state!.copyWith(
      dayNotification: daysDeadline,
    );

    _controller.add(state!);
  }

  Future<void> setGroup(String? group) async {
    await initialized;
    await prefs.setString('group', group ?? '');

    state = state!.copyWith(
      groupCode: group,
    );

    _controller.add(state!);
  }

  Future<void> setTimeNotification(TimeOfDay timeOfDay) async {
    await initialized;
    final time = DateTime(0, 1, 1, timeOfDay.hour, timeOfDay.minute);
    await prefs.setString('time_notifications', time.toString());

    state = state!.copyWith(
      timeNotification: timeOfDay,
    );

    _controller.add(state!);
  }

  Future<int> getDays() async {
    await initialized;
    return prefs.getInt('days') ?? 3;
  }

  Future<String?> getGroup() async {
    await initialized;
    final group = prefs.getString('group');
    return group == '' ? null : group;
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
