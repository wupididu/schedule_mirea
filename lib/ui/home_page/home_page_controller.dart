import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/schedule_controller.dart';
import '../../db/models/db_schedule_day.dart';
import '../../db/models/subject.dart';
import '../../utils/calendar_utils.dart';
import '../../utils/settings.dart';
import '../consts.dart';
import 'home_page_state.dart';
import 'home_page_state_holder.dart';


class HomePageController {
  final Settings _settings;
  final HomePageStateHolder _stateHolder;
  final ScheduleController _scheduleController;
  StreamSubscription? _subscription;

  HomePageController(
      this._stateHolder, this._settings, this._scheduleController);

  void init() {
    updateSubjects(_stateHolder.state.selectedDate);

    DateTime current = DateTime.now();
    Stream<TimeOfDay> timer = Stream.periodic(const Duration(seconds: 1), (i) {
      current = current.add(const Duration(seconds: 1));
      return TimeOfDay(hour: current.hour, minute: current.minute);
    });

    _subscription = timer.listen(_onTimeOfDayTimer);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> updateSubjects(DateTime dateTime) async {
    final subjects = <Subject?>[];
    final groupCode = await _settings.getGroup();
    if (groupCode == null) {
      return;
    }

    final currentWeek = CalendarUtils.getCurrentWeek(dateTime);
    final isEven = CalendarUtils.getCurrentWeek(dateTime) % 2 == 0;

    subjects
      ..add(await _scheduleController.getSubject(
          groupCode: groupCode,
          dayOfWeek: _dayOfWeek(dateTime),
          isEven: isEven,
          pairNum: 1))
      ..add(await _scheduleController.getSubject(
          groupCode: groupCode,
          dayOfWeek: _dayOfWeek(dateTime),
          isEven: isEven,
          pairNum: 2))
      ..add(await _scheduleController.getSubject(
          groupCode: groupCode,
          dayOfWeek: _dayOfWeek(dateTime),
          isEven: isEven,
          pairNum: 3))
      ..add(await _scheduleController.getSubject(
          groupCode: groupCode,
          dayOfWeek: _dayOfWeek(dateTime),
          isEven: isEven,
          pairNum: 4))
      ..add(await _scheduleController.getSubject(
          groupCode: groupCode,
          dayOfWeek: _dayOfWeek(dateTime),
          isEven: isEven,
          pairNum: 5))
      ..add(await _scheduleController.getSubject(
          groupCode: groupCode,
          dayOfWeek: _dayOfWeek(dateTime),
          isEven: isEven,
          pairNum: 6));

    _stateHolder.updateState(HomePageState(
        subjects: subjects, selectedDate: dateTime, currentWeek: currentWeek));
  }

  DayOfWeek _dayOfWeek(DateTime dateTime) {
    switch (dateTime.weekday) {
      case (1):
        return DayOfWeek.monday;
      case (2):
        return DayOfWeek.tuesday;
      case (3):
        return DayOfWeek.thursday;
      case (4):
        return DayOfWeek.wednesday;
      case (5):
        return DayOfWeek.friday;
      case (6):
        return DayOfWeek.saturday;
      default:
        return DayOfWeek.sunday;
    }
  }

  void _onTimeOfDayTimer(TimeOfDay time) {
    int? currentPair;
    kPairTimeMap.forEach((key, value) {
      final startTime = value['start']!;
      final endTime = value['end']!;

      final start = DateTime(0, 0, 0, startTime.hour, startTime.minute);
      final end = DateTime(0, 0, 0, endTime.hour, endTime.minute);
      final current = DateTime(0, 0, 0, time.hour, time.minute);

      final compareStart = current.compareTo(start);
      final compareEnd = current.compareTo(end);

      if (compareStart == 0 ||
          compareEnd == 0 ||
          (compareStart == 1 && compareEnd == -1)) {
        currentPair = key;
      }
    });

    _stateHolder.setCurrentPair(currentPair);
  }
}

final homePageControllerProvider = Provider((ref) => HomePageController(
    ref.watch(homePageStateProvider),
    ref.watch(settingsProvider),
    ref.watch(scheduleControllerProvider)));
