import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/ui/settings_page/settings_page_state.dart';

class SettingsPageStateHolder extends StateNotifier<SettingsPageState?> {
  SettingsPageStateHolder()
      : super(null);

  void init(SettingsPageState newState) {
    state = newState;
  }

  void setLoading(bool isLoading) {
    state = state?.copyWith(
      loaded: isLoading,
    );
  }

  void updateGroupCode(String? groupCode, List<String> loadedGroups) {
    state = state?.copyWith(
      selectedGroupCode: groupCode,
      groupCodeChangeMode: false,
      loadedGroupCode: loadedGroups,
    );
  }

  void updateLoadedGroups(List<String> loadedGroups) {
    state = state?.copyWith(
      groupCodeChangeMode: false,
      loadedGroupCode: loadedGroups,
    );
  }

  void turnChangeModeGroupCode(bool value) {
    state = state?.copyWith(
      groupCodeChangeMode: value,
    );
  }

  void updateErrorGroupCode(String? error) {
    state = state?.copyWith(
      groupCodeError: error,
      loaded: false,
    );
  }

  void clear() {
    state = null;
  }

  void setDayNotification(int day) {
    state = state?.copyWith(
      selectedDayOfNotification: day,
      dayOfNotificationChangeMode: false,
    );
  }

  void turnOnChangeModeDayNotification (bool value) {
    state = state?.copyWith(
      dayOfNotificationChangeMode: value,
    );
  }

  void updateTimeNotification (TimeOfDay time) {
    state = state?.copyWith(
      selectedTimeOfNotification: time,
    );
  }
}

final settingsPageStateHolder = Provider((ref) => SettingsPageStateHolder());
