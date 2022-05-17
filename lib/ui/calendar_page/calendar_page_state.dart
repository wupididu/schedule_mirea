import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/ui/calendar_page/subject_task.dart';

part 'calendar_page_state.freezed.dart';

@freezed
class CalendarPageState with _$CalendarPageState {
  factory CalendarPageState({
    required List<SubjectTask> listOfTasks,
    DateTime? selectedDate,
  }) = _CalendarPageSate;
}