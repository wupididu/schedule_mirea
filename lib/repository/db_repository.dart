import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:schedule_mirea/db/db.dart';
import 'package:schedule_mirea/db/models/db_schedule_day.dart';
import 'package:schedule_mirea/db/models/db_subject_schedule.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';
import 'package:schedule_mirea/models/subjects_on_day.dart';
import 'package:schedule_mirea/utils/schedule_converter.dart';

import '../db/models/db_groups.dart';
import '../db/models/db_subject.dart';

class DBRepository {
  final DB _db;
  final ScheduleConverter _scheduleConverter;
  DBRepository(this._db, this._scheduleConverter);

  Future<void> addScheduleOnWeek(String groupCode) async {
    await _db.initialized;

    final subjectsOnWeek = _scheduleConverter.getSubjectsOnWeek(groupCode);

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
