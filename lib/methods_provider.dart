import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/controllers/notification_controller.dart';
import 'package:schedule_mirea/db/db_initializer.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_controller.dart';
import 'package:schedule_mirea/utils/path_scheduler_provider.dart';
import 'package:schedule_mirea/utils/settings.dart';
import 'controllers/group_controller.dart';
import 'controllers/schedule_controller.dart';
import 'controllers/tasks_controller.dart';

// ignore: subtype_of_sealed_class
/// Это общий провайдер приложения, который предоставляет контроллеры всех
/// необходимых модулей, а также контроллеры всех виджетов.
class MethodsProvider extends ProviderContainer {
  MethodsProvider._();

  static final _instance = MethodsProvider._();

  static MethodsProvider get() => _instance;

  DBInitializer get db => read(dbInitializer);

  ScheduleController get scheduleController => read(scheduleControllerProvider);

  GroupController get groupController => read(groupControllerProvider);

  TasksController get tasksController => read(tasksControllerProvider);

  NotificationController get notificationController =>
      read(notificationControllerProvider);

  Settings get settings => read(settingsProvider);

  TaskEditorController get taskEditorController =>
      read(taskEditorControllerProvider);
  
  PathSchedulerProvider get pathSchedulerProviderController => read(pathSchedulerProvider);
}
