import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/controllers/tasks_controller.dart';
import 'package:schedule_mirea/ui/calendar_page/subject_task.dart';
import 'package:schedule_mirea/ui/notification_page/notification_page_state.dart';
import 'package:schedule_mirea/ui/notification_page/notification_page_state_holder.dart';

class NotificationPageController {
  final _notificationController = AwesomeNotifications();
  final TasksController _tasksController;
  final NotificationPageStateHolder _stateHolder;

  NotificationPageController(this._tasksController, this._stateHolder);

  Future<void> update() async {
    final notifications =
        await _notificationController.listScheduledNotifications();
    final tasks = await _tasksController.getTasks();
    final state = await Stream.fromIterable(notifications)
        .asyncMap<NotificationPageItemData>((event) async {
          final task =
              tasks.firstWhere((element) => element.id == event.content?.id);

          final subject = await _tasksController.getSubjectByTask(task.id);

          return NotificationPageItemData(
              SubjectTask(subject: subject, task: task), event);
        })
        .toList();

    state.sort((a, b) => a.subjectTask.task.deadline.compareTo(b.subjectTask.task.deadline));

    _stateHolder.update(state);
  }
}

final notificationPageControllerProvider = Provider((ref) =>
    NotificationPageController(ref.watch(tasksControllerProvider),
        ref.watch(notificationPageStateHolderProvider)));
