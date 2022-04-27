import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_page_state.freezed.dart';

@freezed
class SettingsPageState with _$SettingsPageState {
  const factory SettingsPageState({
    String? selectedGroupCode,
    required List<String> loadedGroupCode,
    required bool groupCodeChangeMode,
    String? groupCodeError,

    required int selectedDayOfNotification,
    required bool dayOfNotificationChangeMode,

    required TimeOfDay selectedTimeOfNotification,
    required bool timeOfNotificationChangeMode,

    required bool loaded,
  }) = _SettingsPageState;
}
