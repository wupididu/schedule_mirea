import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/ui/home_page/home_page_state.dart';
import 'package:schedule_mirea/utils/calendar_utils.dart';

class HomePageStateHolder extends StateNotifier<HomePageState> {
  HomePageStateHolder() : super(HomePageState(
    selectedDate: DateTime.now(),
    subjects: [],
    currentWeek: CalendarUtils.getCurrentWeek(),
    currentPair: null,
  ));

  void updateState(HomePageState newState){
    state = newState;
  }

  void setCurrentPair(int? pair) {
    if (pair == state.currentPair) {
      return;
    }
    state = state.copyWith(currentPair: pair);
  }
}

final homePageStateProvider = Provider((ref) => HomePageStateHolder());