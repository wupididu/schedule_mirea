import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:schedule_mirea/db/db.dart';
import 'package:schedule_mirea/db/models/db_schedule_day.dart';
import 'package:schedule_mirea/db/models/db_subject_schedule.dart';
import 'package:schedule_mirea/models/even_day.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';
import 'package:schedule_mirea/models/subjects_on_day.dart';
import 'package:schedule_mirea/utils/schedule_converter.dart';

import '../db/models/db_groups.dart';
import '../db/models/db_subject.dart';
import '../models/subjects_on_week.dart';

class DBRepository {
  final DB _db;
  final ScheduleConverter _scheduleConverter;
  DBRepository(this._db, this._scheduleConverter);

  Future<void> addScheduleOnWeek(String groupCode) async {
    await _db.initialized;

    final subjectsOnWeek = _scheduleConverter.getSubjectsOnWeek(groupCode);

    final groups = await _db.getAll<DBGroups>();
    if(groups.firstWhereOrNull((element) => element?.groupCode == groupCode) != null){
      return;
    }

    final groupId = await _addGroup(groupCode);
    subjectsOnWeek.monday.even;

    final listOfSubjects = await _addAllSubjects(groupCode);

    final mondayEvenId = await _addWeekDay(groupId, DayOfWeek.monday, true);
    await _addSubjectSchedule(
        mondayEvenId, listOfSubjects, subjectsOnWeek.monday.even);

    final tuesdayEvenId = await _addWeekDay(groupId, DayOfWeek.tuesday, true);
    await _addSubjectSchedule(
        tuesdayEvenId, listOfSubjects, subjectsOnWeek.tuesday.even);

    final wednesdayEvenId =
        await _addWeekDay(groupId, DayOfWeek.wednesday, true);
    await _addSubjectSchedule(
        wednesdayEvenId, listOfSubjects, subjectsOnWeek.wednesday.even);

    final thursdayEvenId = await _addWeekDay(groupId, DayOfWeek.thursday, true);
    await _addSubjectSchedule(
        thursdayEvenId, listOfSubjects, subjectsOnWeek.thursday.even);

    final fridayEvenId = await _addWeekDay(groupId, DayOfWeek.friday, true);
    await _addSubjectSchedule(
        fridayEvenId, listOfSubjects, subjectsOnWeek.friday.even);

    final saturdayEvenId = await _addWeekDay(groupId, DayOfWeek.saturday, true);
    await _addSubjectSchedule(
        saturdayEvenId, listOfSubjects, subjectsOnWeek.saturday.even);

    final mondayNotEvenId = await _addWeekDay(groupId, DayOfWeek.monday, false);
    await _addSubjectSchedule(
        mondayNotEvenId, listOfSubjects, subjectsOnWeek.monday.notEven);

    final tuesdayNotEvenId =
        await _addWeekDay(groupId, DayOfWeek.tuesday, false);
    await _addSubjectSchedule(
        tuesdayNotEvenId, listOfSubjects, subjectsOnWeek.tuesday.notEven);

    final wednesdayNotEvenId =
        await _addWeekDay(groupId, DayOfWeek.wednesday, false);
    await _addSubjectSchedule(
        wednesdayNotEvenId, listOfSubjects, subjectsOnWeek.wednesday.notEven);

    final thursdayNotEvenId =
        await _addWeekDay(groupId, DayOfWeek.thursday, false);
    await _addSubjectSchedule(
        thursdayNotEvenId, listOfSubjects, subjectsOnWeek.thursday.notEven);

    final fridayNotEvenId = await _addWeekDay(groupId, DayOfWeek.friday, false);
    await _addSubjectSchedule(
        fridayNotEvenId, listOfSubjects, subjectsOnWeek.friday.notEven);

    final saturdayNotEvenId =
        await _addWeekDay(groupId, DayOfWeek.saturday, false);
    await _addSubjectSchedule(
        saturdayNotEvenId, listOfSubjects, subjectsOnWeek.saturday.notEven);
  }

  Future<SubjectsOnWeek?> getSubjectsOnWeek(String groupCode) async {
    await _db.initialized;

    final groups = await _db.getAll<DBGroups>();

    final groupId = groups
        .firstWhereOrNull((element) => element?.groupCode == groupCode)
        ?.id;

    if (groupId == null) {
      return null;
    }

    final scheduleDays = (await _db.getAll<DBScheduleDay>())
        .where((element) => element?.groupId == groupId).toList();
    final subjects = await _db.getAll<DBSubject>();
    final subjectSchedules = await _db.getAll<DBSubjectSchedule>();

    final monday = EvenDay(
        even: _getSubjectsOnDay(
            true, DayOfWeek.monday, scheduleDays, subjects, subjectSchedules),
        notEven: _getSubjectsOnDay(
            false, DayOfWeek.monday, scheduleDays, subjects, subjectSchedules));

    return SubjectsOnWeek(
      monday: _getEvenDay(
          DayOfWeek.monday, scheduleDays, subjects, subjectSchedules),
      tuesday: _getEvenDay(
          DayOfWeek.tuesday, scheduleDays, subjects, subjectSchedules),
      thursday: _getEvenDay(
          DayOfWeek.thursday, scheduleDays, subjects, subjectSchedules),
      wednesday: _getEvenDay(
          DayOfWeek.wednesday, scheduleDays, subjects, subjectSchedules),
      friday: _getEvenDay(
          DayOfWeek.friday, scheduleDays, subjects, subjectSchedules),
      saturday: _getEvenDay(
          DayOfWeek.saturday, scheduleDays, subjects, subjectSchedules),
    );
  }

  Future<void> deleteAllByGroupeCode(String groupCode) async {
    await _db.initialized;
    final groupId = (await _db.getAll<DBGroups>()).firstWhereOrNull((element) => element?.groupCode == groupCode);

    if (groupId == null) {
      return;
    }



  }


  EvenDay _getEvenDay(
    DayOfWeek dayOfWeek,
    List<DBScheduleDay?> scheduleDays,
    List<DBSubject?> subjects,
    List<DBSubjectSchedule?> subjectSchedules,
  ) =>
      EvenDay(
          even: _getSubjectsOnDay(
              true, dayOfWeek, scheduleDays, subjects, subjectSchedules),
          notEven: _getSubjectsOnDay(
              false, dayOfWeek, scheduleDays, subjects, subjectSchedules));

  SubjectsOnDay _getSubjectsOnDay(
    bool isEven,
    DayOfWeek dayOfWeek,
    List<DBScheduleDay?> scheduleDays,
    List<DBSubject?> subjects,
    List<DBSubjectSchedule?> subjectSchedules,
  ) =>
      SubjectsOnDay(
        first: _getSubject(
            isEven, dayOfWeek, 1, scheduleDays, subjects, subjectSchedules),
        second: _getSubject(
            isEven, dayOfWeek, 2, scheduleDays, subjects, subjectSchedules),
        third: _getSubject(
            isEven, dayOfWeek, 3, scheduleDays, subjects, subjectSchedules),
        fourth: _getSubject(
            isEven, dayOfWeek, 4, scheduleDays, subjects, subjectSchedules),
        fifth: _getSubject(
            isEven, dayOfWeek, 5, scheduleDays, subjects, subjectSchedules),
        sixth: _getSubject(
            isEven, dayOfWeek, 6, scheduleDays, subjects, subjectSchedules),
      );

  SubjectFromTable? _getSubject(
    bool isEven,
    DayOfWeek dayOfWeek,
    int subjectNum,
    List<DBScheduleDay?> scheduleDays,
    List<DBSubject?> subjects,
    List<DBSubjectSchedule?> subjectSchedules,
  ) {
    final scheduleDayId = scheduleDays
        .firstWhereOrNull((element) =>
            element?.dayOfWeek == dayOfWeek && element?.isEven == isEven)
        ?.id;

    if (scheduleDayId == null) {
      throw Exception();
    }

    final subjectId = subjectSchedules
        .firstWhereOrNull((element) =>
            element?.scheduleDayId == scheduleDayId &&
            element?.subjectNum == subjectNum)
        ?.subjectId;

    if (subjectId == null) {
      return null;
    }

    final subject =
        subjects.firstWhereOrNull((element) => element?.id == subjectId);

    if (subject == null) {
      throw Exception();
    }

    return SubjectFromTable(
        name: subject.name,
        room: subject.room,
        teacher: subject.teacher,
        typeOfSubject: subject.type);
  }

  Future<void> _addSubjectSchedule(
    int dayId,
    List<DBSubject> listOfSubjects,
    SubjectsOnDay subjectsOnDay,
  ) async {
    await _addSubjectItem(subjectsOnDay.first, listOfSubjects, 1, dayId);
    await _addSubjectItem(subjectsOnDay.second, listOfSubjects, 2, dayId);
    await _addSubjectItem(subjectsOnDay.third, listOfSubjects, 3, dayId);
    await _addSubjectItem(subjectsOnDay.fourth, listOfSubjects, 4, dayId);
    await _addSubjectItem(subjectsOnDay.fifth, listOfSubjects, 5, dayId);
    await _addSubjectItem(subjectsOnDay.sixth, listOfSubjects, 6, dayId);
  }

  Future<void> _addSubjectItem(
    SubjectFromTable? subjectFromTable,
    List<DBSubject> listOfSubjects,
    int subjectNum,
    int dayId,
  ) async {
    if (subjectFromTable == null) {
      return;
    }

    final subject = listOfSubjects
        .firstWhereOrNull((element) => element.name == subjectFromTable.name);

    if (subject == null) {
      return;
    }

    await _db.insert<DBSubjectSchedule>(DBSubjectSchedule(
      subjectNum: subjectNum,
      scheduleDayId: dayId,
      subjectId: subject.id!,
    ));
  }

  Future<List<DBSubject>> _addAllSubjects(String groupCode) async {
    List<SubjectFromTable> subjects =
        _scheduleConverter.getAllSubjects(groupCode);
    List<DBSubject> result = [];

    for (SubjectFromTable subject in subjects) {
      final dbSubject = DBSubject(
        name: subject.name,
        room: subject.room,
        teacher: subject.teacher,
        type: subject.typeOfSubject,
      );
      final insertedDBSubject = await _db.insert<DBSubject>(dbSubject);
      result.add(insertedDBSubject);
    }

    return result;
  }

  Future<int> _addGroup(String groupCode) async {
    final dbGroups = DBGroups(groupCode: groupCode);
    final groupId = (await _db.insert<DBGroups>(dbGroups)).id;
    if (groupId == null) {
      throw Exception();
    }
    return groupId;
  }

  Future<int> _addWeekDay(int groupId, DayOfWeek dayOfWeek, bool isEven) async {
    final weekDay =
        DBScheduleDay(isEven: isEven, dayOfWeek: dayOfWeek, groupId: groupId);
    final weekDayId = (await _db.insert<DBScheduleDay>(weekDay)).id;
    if (weekDayId == null) {
      throw Exception();
    }
    return groupId;
  }
}

final dbRepositoryProvider = Provider((ref) => DBRepository(
      ref.watch(dbProvider),
      ref.watch(scheduleConverterProvider),
    ));
