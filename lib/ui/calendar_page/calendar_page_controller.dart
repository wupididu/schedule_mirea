import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/ui/calendar_page/subject_task.dart';

import '../../controllers/tasks_controller.dart';
import 'calendar_page_state_holder.dart';

class CalendarPageController {
  final CalendarPageStateHolder _stateHolder;
  final TasksController _tasksController;
  StreamSubscription? _subscription;

  CalendarPageController(this._stateHolder, this._tasksController);

  void init() {
    _subscription = _tasksController.allTaskStream.listen((tasks) async {
      final deadline = _stateHolder.state.selectedDate;

      final deadlineTasks = tasks.where((element) {
        return element.deadline.toString() ==
            deadline?.toString().replaceAll('Z', '');
      });
      final subjectTask =
          await Stream.fromIterable(deadlineTasks).asyncMap((task) async {
        final subject = await _tasksController.getSubjectByTask(task.id);
        return SubjectTask(subject: subject, task: task);
      }).toList();
      _stateHolder.updateListOfTasks(subjectTask);
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> selectDate(DateTime selectedDate) async {
    final tasks = await _tasksController.getTasksByDateTime(selectedDate);
    final subjectTask = await Stream.fromIterable(tasks).asyncMap((task) async {
      final subject = await _tasksController.getSubjectByTask(task.id);
      return SubjectTask(subject: subject, task: task);
    }).toList();
    _stateHolder.updateSelectedDate(selectedDate);
    _stateHolder.updateListOfTasks(subjectTask);
  }
}

final calendarPageControllerProvider = Provider((ref) => CalendarPageController(
    ref.watch(calendarPageStateHolderProvider),
    ref.watch(tasksControllerProvider)));
