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

  void updateGroupCode(String groupCode, List<String> loadedGroups) {
    state = state?.copyWith(
      selectedGroupCode: groupCode,
      groupCodeChangeMode: false,
      loadedGroupCode: loadedGroups,
    );
  }

  void turnOnChangeModeGroupCode() {
    state = state?.copyWith(
      groupCodeChangeMode: true,
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
}

final settingsPageStateHolder = Provider((ref) => SettingsPageStateHolder());
