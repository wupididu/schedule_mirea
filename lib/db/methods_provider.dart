import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/repository/db_repository.dart';
import 'package:schedule_mirea/utils/schedule_converter.dart';

// ignore: subtype_of_sealed_class
class MethodsProvider extends ProviderContainer{
  MethodsProvider._();

  static final _instance = MethodsProvider._();

  static MethodsProvider get() => _instance;

  ScheduleConverter get scheduleConverter => read(scheduleConverterProvider);

  DBRepository get dbRepository => read(dbRepositoryProvider);
}