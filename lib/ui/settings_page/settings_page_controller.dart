import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/controllers/group_controller.dart';
import 'package:schedule_mirea/controllers/schedule_controller.dart';
import 'package:schedule_mirea/ui/settings_page/settings_page_state_holder.dart';
import 'package:schedule_mirea/utils/path_scheduler_provider.dart';

import '../../utils/settings.dart';
import 'settings_page_state.dart';

class SettingsPageController {
  final Settings _settings;
  final SettingsPageStateHolder _stateHolder;
  final GroupController _groupController;
  final ScheduleController _scheduleController;
  final PathSchedulerProvider _pathSchedulerProvider;

  SettingsPageController(
    this._settings,
    this._stateHolder,
    this._groupController,
    this._scheduleController,
    this._pathSchedulerProvider,
  );

  Future<void> init() async {
    final groupCode = await _settings.getGroup();
    final loadedGroups = await _groupController.getGroups();
    final dayNotification = await _settings.getDays();
    final timeNotification = await _settings.getTimeNotification();

    print('init');
    final state = SettingsPageState(
      loaded: false,
      selectedGroupCode: groupCode,
      loadedGroupCode: loadedGroups,
      groupCodeChangeMode: groupCode == null,
      groupCodeError: null,
      selectedDayOfNotification: dayNotification,
      dayOfNotificationChangeMode: false,
      selectedTimeOfNotification: timeNotification,
      timeOfNotificationChangeMode: false,
    );

    _stateHolder.init(state);
  }

  void dispose() {
    _stateHolder.clear();
  }

  void turnChangeModeGroupCode(bool value) {
    _stateHolder.turnChangeModeGroupCode(value);
  }

  Future<void> getLoadedGroup(String groupCode) async {
    final groups = await _groupController.getGroups();

    if (!groups.contains(groupCode)) {
      await updateGroupCode(groupCode);
      return;
    }
    final loadedGroups = await _groupController.getGroups();

    _stateHolder.updateGroupCode(groupCode, loadedGroups);
    _stateHolder.updateErrorGroupCode(null);
    _settings.setGroup(groupCode);
    _stateHolder.setLoading(false);
  }

  Future<void> updateGroupCode(String groupCode) async {
    print(groupCode);
    _stateHolder.setLoading(true);

    if (!RegExp(r'[А-Яа-я]{4}-[0-9]{2}-[0-9]{2}').hasMatch(groupCode)) {
      _stateHolder
          .updateErrorGroupCode('Формат группы не корректный АААА-00-00');
      return;
    }

    late final String? link;
    try {
      link = await _pathSchedulerProvider.getLink(groupCode.toUpperCase());
    } catch (e) {
      _stateHolder.updateErrorGroupCode('Что то пошло не так :(');
      return;
    }

    if (link == null) {
      _stateHolder.updateErrorGroupCode('Что то пошло не так :(');
      return;
    }

    await _scheduleController.addScheduleOnWeek(
      groupCode: groupCode,
      urlLink: link,
    );

    final loadedGroups = await _groupController.getGroups();

    _stateHolder.updateGroupCode(groupCode, loadedGroups);
    _stateHolder.updateErrorGroupCode(null);
    _settings.setGroup(groupCode);
    _stateHolder.setLoading(false);
  }

  Future<void> updateDayNotification(int day) async {
    await _settings.setDaysDeadline(day);
    _stateHolder.setDayNotification(day);
  }

  void turnChangeModeDayNotification(bool value) {
    _stateHolder.turnOnChangeModeDayNotification(value);
  }

  Future<void> updateTimeNotification(TimeOfDay time) async {
    await _settings.setTimeNotification(time);
    _stateHolder.updateTimeNotification(time);
  }
}

final settingsPageControllerProvider = Provider((ref) => SettingsPageController(
      ref.watch(settingsProvider),
      ref.watch(settingsPageStateHolder),
      ref.watch(groupControllerProvider),
      ref.watch(scheduleControllerProvider),
      ref.watch(pathSchedulerProvider),
    ));
