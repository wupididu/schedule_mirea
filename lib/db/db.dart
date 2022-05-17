import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:schedule_mirea/db/models/db_group_x_task.dart';
import 'package:schedule_mirea/db/models/db_schedule.dart';
import 'package:schedule_mirea/db/models/db_schedule_day.dart';
import 'package:sqflite/sqflite.dart';

import 'models/db_groups.dart';
import 'models/db_subject.dart';
import 'models/db_task.dart';

/// Этот класс предоставляет взаимодействие с локальной базой данных
///
/// Для того чтобы начать пользоваться данным классом, надо его проинициализировать, вызвать метод [init()]
class DB {
  static const _databaseName = 'schedule_database.db';
  late final Database _db;
  final _complete = Completer<bool>();

  /// Этот метод позваоляет ждать проинициализировано ли БД
  /// ```dart
  ///   ...
  ///   await DB().initialized;
  ///   ...
  /// ```
  Future<void> get initialized => _complete.future;

  DB._();

  static final _singleton = DB._();
  static DB get instance => _singleton;

  Future<void> init() async {
    if (_complete.isCompleted) {
      return;
    }
    _db = await openDatabase(
      _databaseName,
      version: 1,
      onCreate: _onCreate,
    );
    await _createScheduleDays();
    _complete.complete(true);
  }

  Future<void> dispose() async {
    await _db.close();
  }

  void _onCreate(Database db, int version) async {
    await db.execute(DBGroups.createTableQuery);
    await db.execute(DBSubject.createTableQuery);
    await db.execute(DBScheduleDay.createTableQuery);
    await db.execute(DBTask.createTableQuery);
    await db.execute(DBSchedule.createTableQuery);
    await db.execute(DBGroupXTask.createTableQuery);
  }

  Future<int> insertGroup(DBGroups group) async {
    final allGroups = await getGroups();
    final groupCodes = allGroups.map((e) => e.groupCode).toList();

    if (groupCodes.contains(group.groupCode)) {
      return allGroups
          .firstWhere((element) => element.groupCode == group.groupCode)
          .id!;
    }

    return await _db.insert(DBGroups.tableName, group.toMap());
  }

  /// Удаляет группу из базы данных. Также удаляет все связанные с ним данные.
  ///
  /// Если передать несуществую группу, то вызовется ошибка
  Future<void> deleteGroup(String groupCode) async {
    final groups = await getGroups();

    if (groups.firstWhereOrNull((element) => element.groupCode == groupCode) ==
        null) {
      throw Exception('group not exist');
    }

    final removedId = await _db.delete(DBGroups.tableName,
        where: '${DBGroups.columnGroupCode} = ?', whereArgs: [groupCode]);

    await _db.delete(DBSchedule.tableName,
        where: '${DBSchedule.columnGroupId} = ?', whereArgs: [removedId]);

    await _deleteUselessSubject();
    await _deleteUselessTask();
    await deleteUselessSchedule(groupCode);
  }

  Future<List<DBGroups>> getGroups() async {
    final groups = await _db.query(DBGroups.tableName);
    final result = groups.map<DBGroups>((e) => DBGroups.fromMap(e)).toList();
    return result;
  }

  Future<void> insertSubject(DBSubject subject) async {
    final existSubjects = await getAllSubjects();

    if (existSubjects.contains(subject)) {
      return;
    }

    await _db.insert(DBSubject.tableName, subject.toMap());
  }

  Future<List<DBSubject>> getSubjects(String groupCode) async {
    final groupId = await _findGroupId(groupCode);

    final query = ''' 
      select sub.* from ${DBSubject.tableName} sub 
      inner join ${DBSchedule.tableName} sc 
      on sc.${DBSchedule.columnGroupId} = $groupId
      and sc.${DBSchedule.columnSubjectId} = sub.${DBSubject.columnId}
    ''';

    final resSubjects = await _db.rawQuery(query);
    return resSubjects.map((e) => DBSubject.fromMap(e)).toList();
  }

  Future<List<DBSubject>> getAllSubjects() async {
    final resSubjects = await _db.query(DBSubject.tableName);
    return resSubjects.map((e) => DBSubject.fromMap(e)).toList();
  }

  Future<void> insertSchedule({
    required DBScheduleDay scheduleDay,
    required String groupCode,
    required int pairNum,
    required DBSubject subject,
  }) async {
    final subjectId = await _findSubjectId(subject);

    final groupId = await _findGroupId(groupCode);

    final scheduleDayId = await _findScheduleDayId(scheduleDay);

    final schedule = DBSchedule(
      groupId: groupId,
      pairId: pairNum,
      scheduleDayId: scheduleDayId,
      subjectId: subjectId,
    );

    await _db.insert(
      DBSchedule.tableName,
      schedule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DBSubject?> getScheduleSubject({
    required String groupCode,
    required DBScheduleDay scheduleDay,
    required pairNum,
  }) async {
    final groupId = await _findGroupId(groupCode);
    final scheduleDayId = await _findScheduleDayId(scheduleDay);

    final resSchedule = await _db.query(
      DBSchedule.tableName,
      where: '${DBSchedule.columnGroupId} = ? '
          'and ${DBSchedule.columnPairId} = ? '
          'and ${DBSchedule.columnScheduleDayId} = ?',
      whereArgs: [groupId, pairNum, scheduleDayId],
    );

    if (resSchedule.isEmpty) {
      return null;
    }

    final subjectId = DBSchedule.fromMap(resSchedule.first).subjectId;

    final resSubject = await _db.query(
      DBSubject.tableName,
      where: '${DBSubject.columnId} = ?',
      whereArgs: [subjectId],
    );

    if (resSubject.isEmpty) {
      throw ('Not expecting error');
    }

    return DBSubject.fromMap(resSubject.first);
  }

  Future<int> insertTask({
    required DBTask task,
    required String groupCode,
    required int subjectId,
  }) async {
    final groupId = await _findGroupId(groupCode);

    final taskId = await _db.insert(DBTask.tableName, task.toMap());

    final groupXTask = DBGroupXTask(
      groupId: groupId,
      taskId: taskId,
      subjectId: subjectId,
    );

    await _db.insert(DBGroupXTask.tableName, groupXTask.toMap());

    return taskId;
  }

  Future<List<DBTask>> getTasks(String groupCode) async {
    final groupId = await _findGroupId(groupCode);
    final query = '''
      select t.* from ${DBTask.tableName} t 
      inner join ${DBGroupXTask.tableName} g
      on g.${DBGroupXTask.columnGroupId} = $groupId
      and t.${DBTask.columnId} = g.${DBGroupXTask.columnTaskId}
    ''';
    final resTask = await _db.rawQuery(query);
    return resTask.map((e) => DBTask.fromMap(e)).toList();
  }

  Future<List<DBTask>> getSubjectTasks(String groupCode, int subjectId) async {
    final groupId = await _findGroupId(groupCode);
    final query = '''
      select t.* from ${DBTask.tableName} t 
      inner join ${DBGroupXTask.tableName} g
      on g.${DBGroupXTask.columnGroupId} = $groupId
      and g.${DBGroupXTask.columnSubjectId} = $subjectId
      and t.${DBTask.columnId} = g.${DBGroupXTask.columnTaskId}
    ''';
    final resTask = await _db.rawQuery(query);
    return resTask.map((e) => DBTask.fromMap(e)).toList();
  }

  Future<List<DBTask>> getTasksByDateTime(
      String groupCode, DateTime dateTime) async {
    final groupId = await _findGroupId(groupCode);
    final query = '''
      select t.* from ${DBTask.tableName} t 
      inner join ${DBGroupXTask.tableName} g
      on g.${DBGroupXTask.columnGroupId} = $groupId
      and t.${DBTask.columnId} = g.${DBGroupXTask.columnTaskId}
      and t.${DBTask.columnDeadline} = '${dateTime.toString().replaceAll('Z', '')}'
    ''';
    final resTasks = await _db.rawQuery(query);
    return resTasks.map(DBTask.fromMap).toList();
  }

  Future<void> deleteTask(int taskId) async {
    final removedTaskId = await _db.delete(
      DBTask.tableName,
      where: '${DBTask.columnId} = ?',
      whereArgs: [taskId],
    );

    await _db.delete(
      DBGroupXTask.tableName,
      where: '${DBGroupXTask.columnTaskId} = ?',
      whereArgs: [removedTaskId],
    );
  }

  Future<void> updateTask(DBTask task) async {
    if (task.id == null) {
      throw Exception('Error in updating task. Id should not be null');
    }

    await _db.update(
      DBTask.tableName,
      task.toMap(),
      where: '${DBTask.columnId} = ?',
      whereArgs: [task.id],
    );
  }

  Future<DBSubject> getSubjectByTask(int taskId) async {
    final query = '''
      select s.* from ${DBSubject.tableName} s
      inner join ${DBGroupXTask.tableName} g
      on g.${DBGroupXTask.columnTaskId} = $taskId and
      s.${DBSubject.columnId} = g.${DBGroupXTask.columnSubjectId}
    ''';
    final result = await _db.rawQuery(query);
    if (result.isEmpty) {
      throw Exception('task not have subject');
    }
    return DBSubject.fromMap(result.first);
  }

  Future<void> _deleteUselessSubject() async {
    final allSchedules = await _db.query(DBSchedule.tableName);
    final usingSubjectIds =
        allSchedules.map<int>((e) => DBSchedule.fromMap(e).subjectId).toSet();

    final allSubjects = await _db.query(DBSubject.tableName);
    final allSubjectsIds =
        allSubjects.map<int>((e) => DBSubject.fromMap(e).id!).toSet();

    final uselessId = allSubjectsIds.difference(usingSubjectIds).toList();

    if (uselessId.isEmpty) {
      return;
    }

    var row = 'delete from ${DBSubject.tableName} where';

    for (int i = 0; i < uselessId.length; i++) {
      row += ' ${DBSubject.columnId} = ${uselessId[i]}';

      if (i != uselessId.length - 1) {
        row += ' or';
      }
    }
    await _db.rawDelete(row);
  }

  Future<void> _deleteUselessTask() async {
    final resGroupXTask = await _db.query(DBGroupXTask.tableName);
    final usingTaskId =
        resGroupXTask.map((e) => DBGroupXTask.fromMap(e).taskId).toSet();

    final allTasks = await _getTasks();
    final allTaskId = allTasks.map((e) => e.id!).toSet();

    final uselessId = allTaskId.difference(usingTaskId).toList();

    if (uselessId.isEmpty) {
      return;
    }

    var row = 'delete from ${DBTask.tableName} where';

    for (int i = 0; i < uselessId.length; i++) {
      row += ' ${DBTask.columnId} = ${uselessId[i]}';

      if (i != uselessId.length - 1) {
        row += ' or';
      }
    }
    await _db.rawDelete(row);
  }

  Future<int> _findScheduleDayId(DBScheduleDay scheduleDay) async {
    final resScheduleDay = await _db.query(
      DBScheduleDay.tableName,
      where: '${DBScheduleDay.columnIsEven} = ? '
          'and ${DBScheduleDay.columnDayOfWeek} = ?',
      whereArgs: [
        scheduleDay.isEven ? 1 : 0,
        describeEnum(scheduleDay.dayOfWeek)
      ],
    );

    if (resScheduleDay.isEmpty) {
      throw Exception('scheduleDay not exist');
    }

    return DBScheduleDay.fromMap(resScheduleDay.first).id!;
  }

  Future<int> _findGroupId(String groupCode) async {
    final resGroup = await _db.query(DBGroups.tableName,
        where: '${DBGroups.columnGroupCode} = ?', whereArgs: [groupCode]);

    if (resGroup.isEmpty) {
      throw Exception('group not exist');
    }

    return DBGroups.fromMap(resGroup.first).id!;
  }

  Future<int> _findSubjectId(DBSubject subject) async {
    final resSubject = await _db.query(
      DBSubject.tableName,
      where: '${DBSubject.columnName} = ? '
          'and ${DBSubject.columnTeacher} = ? '
          'and ${DBSubject.columnRoom} = ? '
          'and ${DBSubject.columnType} =? ',
      whereArgs: [
        subject.name,
        subject.teacher,
        subject.room,
        describeEnum(subject.type)
      ],
    );

    if (resSubject.isEmpty) {
      throw Exception('subject not exist');
    }

    return DBSubject.fromMap(resSubject.first).id!;
  }

  Future<void> _createScheduleDays() async {
    List<DBScheduleDay> allDays = [];

    for (var element in DayOfWeek.values) {
      allDays.add(DBScheduleDay(isEven: true, dayOfWeek: element));
      allDays.add(DBScheduleDay(isEven: false, dayOfWeek: element));
    }

    for (var element in allDays) {
      await _db.insert(DBScheduleDay.tableName, element.toMap());
    }
  }

  Future<List<DBTask>> _getTasks() async {
    final resTask = await _db.query(DBTask.tableName);
    return resTask.map((e) => DBTask.fromMap(e)).toList();
  }

  Future<void> deleteUselessSchedule(String groupCode) async {
    final groupId = await _findGroupId(groupCode);
    await _db.delete(DBSchedule.tableName,
        where: '${DBSchedule.columnGroupId} = ?', whereArgs: [groupId]);
  }
}

final dbProvider = Provider((ref) => DB.instance);
