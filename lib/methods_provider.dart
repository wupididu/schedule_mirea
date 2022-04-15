import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/db/controllers/group_controller.dart';
import 'package:schedule_mirea/db/controllers/tasks_controller.dart';
import 'package:schedule_mirea/db/db_initializer.dart';
import 'db/controllers/schedule_controller.dart';
import 'utils/schedule_converter.dart';
import 'utils/schedule_file_installer.dart';

// ignore: subtype_of_sealed_class
class MethodsProvider extends ProviderContainer {
  MethodsProvider._();

  static final _instance = MethodsProvider._();

  static MethodsProvider get() => _instance;

  DBInitializer get db => read(dbInitializer);

  ScheduleConverter get scheduleConverter => read(scheduleConverterProvider);

  ScheduleController get scheduleController => read(scheduleControllerProvider);

  GroupController get groupController => read(groupControllerProvider);

  TasksController get tasksController => read(tasksControllerProvider);

  ScheduleFileInstaller get scheduleFileInstaller =>
      read(scheduleFileInstallerProvider);
}
