import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/db/db.dart';
import 'repository/db_repository.dart';
import 'utils/schedule_converter.dart';
import 'utils/schedule_file_installer.dart';

// ignore: subtype_of_sealed_class
class MethodsProvider extends ProviderContainer {
  MethodsProvider._();

  static final _instance = MethodsProvider._();

  static MethodsProvider get() => _instance;

  DB get db => read(dbProvider);

  ScheduleConverter get scheduleConverter => read(scheduleConverterProvider);

  DBRepository get dbRepository => read(dbRepositoryProvider);

  ScheduleFileInstaller get scheduleFileInstaller =>
      read(scheduleFileInstallerProvider);
}
