import 'package:riverpod/riverpod.dart';
import 'package:schedule_mirea/exceptions/exceptions.dart';
import 'package:schedule_mirea/utils/path_scheduler_provider.dart';
import 'package:schedule_mirea/utils/schedule_file_installer.dart';
import '../db/db.dart';
import '../db/models/db_groups.dart';
import '../db/models/db_schedule_day.dart';
import '../db/models/db_subject.dart';
import '../../models/even_day.dart';
import '../../models/subject_from_table.dart';
import '../../utils/schedule_converter.dart';
import '../db/models/subject.dart';
import '../utils/settings.dart';

/// Контроллер, который предоставляет взаимодействие с расписанием
class ScheduleController {
  final DB _db;
  final ScheduleConverter _scheduleConverter;
  final ScheduleFileInstaller _scheduleFileInstaller;
  final PathSchedulerProvider _pathSchedulerProvider;
  final Settings _settings;

  ScheduleController(
    this._db,
    this._scheduleConverter,
    this._scheduleFileInstaller,
    this._pathSchedulerProvider,
    this._settings,
  );

  /// Добавляет расписание для группы, которая берется из настроек
  Future<void> addScheduleOnWeek() async {
    await _db.initialized;

    final groupCode = await _settings.getGroup();

    if (groupCode == null) {
      throw Exception('Какие то проблемы, в настройках не лежит код группы');
    }

    final link = await _pathSchedulerProvider.getLink(groupCode);
    if (link == null) {
      return;
    }
    await _scheduleFileInstaller.downloadFile(link);

    await _db.insertGroup(DBGroups(groupCode: groupCode));

    _scheduleConverter.setFile(await _scheduleFileInstaller.scheduleFilePath);

    final scheduleOnWeek = _scheduleConverter.getSubjectsOnWeek(groupCode);

    final allSubjects = _scheduleConverter.getAllSubjects(groupCode);

    for (var element in allSubjects) {
      final subject = DBSubject(
        room: element.room,
        teacher: element.teacher,
        type: element.typeOfSubject,
        name: element.name,
      );
      await _db.insertSubject(subject);
    }

    await _addWeekDay(
      dayOfWeek: DayOfWeek.monday,
      evenDay: scheduleOnWeek.monday,
      groupCode: groupCode,
    );
    await _addWeekDay(
      dayOfWeek: DayOfWeek.tuesday,
      evenDay: scheduleOnWeek.tuesday,
      groupCode: groupCode,
    );
    await _addWeekDay(
      dayOfWeek: DayOfWeek.thursday,
      evenDay: scheduleOnWeek.thursday,
      groupCode: groupCode,
    );
    await _addWeekDay(
      dayOfWeek: DayOfWeek.wednesday,
      evenDay: scheduleOnWeek.wednesday,
      groupCode: groupCode,
    );
    await _addWeekDay(
      dayOfWeek: DayOfWeek.friday,
      evenDay: scheduleOnWeek.friday,
      groupCode: groupCode,
    );
    await _addWeekDay(
      dayOfWeek: DayOfWeek.saturday,
      evenDay: scheduleOnWeek.saturday,
      groupCode: groupCode,
    );
  }

  Future<Subject?> getSubject({
    required String groupCode,
    required DayOfWeek dayOfWeek,
    required bool isEven,
    required int pairNum,
  }) async {
    await _db.initialized;

    final scheduleDay = DBScheduleDay(
      isEven: isEven,
      dayOfWeek: dayOfWeek,
    );
    final subject = await _db.getScheduleSubject(
        groupCode: groupCode, scheduleDay: scheduleDay, pairNum: pairNum);

    if (subject == null) {
      return null;
    }

    return Subject(
      id: subject.id!,
      name: subject.name,
      room: subject.room,
      type: subject.type,
      teacher: subject.teacher,
    );
  }

  Future<List<Subject>> getSubjects([String? groupCode]) async {
    await _db.initialized;

    final code = groupCode ?? await _settings.getGroup();

    if (code == null){
      throw GroupCodeNullException();
    }

    final subjects = await _db.getSubjects(code);
    return subjects
        .map((e) => Subject(
              id: e.id!,
              name: e.name,
              room: e.room,
              teacher: e.teacher,
              type: e.type,
            ))
        .toList();
  }

  Future<void> _addWeekDay({
    required DayOfWeek dayOfWeek,
    required EvenDay evenDay,
    required String groupCode,
  }) async {
    await _addPair(
        isEven: true,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 1,
        subjectFromTable: evenDay.even.first);
    await _addPair(
        isEven: true,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 2,
        subjectFromTable: evenDay.even.second);
    await _addPair(
        isEven: true,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 3,
        subjectFromTable: evenDay.even.third);
    await _addPair(
        isEven: true,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 4,
        subjectFromTable: evenDay.even.fourth);
    await _addPair(
        isEven: true,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 5,
        subjectFromTable: evenDay.even.fifth);
    await _addPair(
        isEven: true,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 6,
        subjectFromTable: evenDay.even.sixth);

    await _addPair(
        isEven: false,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 1,
        subjectFromTable: evenDay.notEven.first);
    await _addPair(
        isEven: false,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 2,
        subjectFromTable: evenDay.notEven.second);
    await _addPair(
        isEven: false,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 3,
        subjectFromTable: evenDay.notEven.third);
    await _addPair(
        isEven: false,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 4,
        subjectFromTable: evenDay.notEven.fourth);
    await _addPair(
        isEven: false,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 5,
        subjectFromTable: evenDay.notEven.fifth);
    await _addPair(
        isEven: false,
        dayOfWeek: dayOfWeek,
        groupCode: groupCode,
        numPair: 6,
        subjectFromTable: evenDay.notEven.sixth);
  }

  Future<void> _addPair({
    required DayOfWeek dayOfWeek,
    required String groupCode,
    required int numPair,
    required SubjectFromTable? subjectFromTable,
    required bool isEven,
  }) async {
    if (subjectFromTable == null) {
      return;
    }

    final subject = DBSubject(
      name: subjectFromTable.name,
      type: subjectFromTable.typeOfSubject,
      teacher: subjectFromTable.teacher,
      room: subjectFromTable.room,
    );

    await _db.insertSchedule(
        scheduleDay: DBScheduleDay(isEven: isEven, dayOfWeek: dayOfWeek),
        groupCode: groupCode,
        pairNum: numPair,
        subject: subject);
  }
}

final scheduleControllerProvider = Provider((ref) => ScheduleController(
      ref.watch(dbProvider),
      ref.watch(scheduleConverterProvider),
      ref.watch(scheduleFileInstallerProvider),
      ref.watch(pathSchedulerProvider),
      ref.watch(settingsProvider),
    ));
