import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/ui/calendar_page/calendar_page_state.dart';
import 'package:schedule_mirea/ui/calendar_page/subject_task.dart';

class CalendarPageStateHolder extends StateNotifier<CalendarPageState>{
  
  CalendarPageStateHolder() : super(CalendarPageState(listOfTasks: []));

  void updateSelectedDate(DateTime newSelectedDate) {
    state = state.copyWith(selectedDate: newSelectedDate);
  }
  
  void updateListOfTasks(List<SubjectTask> newListOfTasks) {
    state = state.copyWith(listOfTasks: newListOfTasks);
  }
}

final calendarPageStateHolderProvider = Provider((ref)=> CalendarPageStateHolder());