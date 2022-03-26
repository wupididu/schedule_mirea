import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:schedule_mirea/db/models/db_item.dart';
import 'package:schedule_mirea/db/models/db_schedule_day.dart';
import 'package:schedule_mirea/db/models/db_subject_schedule.dart';
import 'package:schedule_mirea/db/models/db_task.dart';
import 'package:sqflite/sqflite.dart';
import './models/db_groups.dart';
import './models/db_subject.dart';

class DB {
  static const _databaseName = 'schedule_database.db';
  late final Database _db;
  final _complete = Completer<bool>();

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
    print('init');
    _complete.complete(true);
    print(_complete.isCompleted);
  }

  Future<void> dispose() async {
    await _db.close();
  }

  void _onCreate(Database db, int version) async {
    await db.execute(DBGroups.createTableQuery);
    await db.execute(DBScheduleDay.createTableQuery);
    await db.execute(DBSubjectSchedule.createTableQuery);
    await db.execute(DBSubject.createTableQuery);
    await db.execute(DBTask.createTableQuery);
  }

  Future<T> insert<T extends DBItem>(T item) async {
    item.id = await _db.insert(item.getTableName(), item.toMap());
    return item;
  }

  Future<T?> get<T extends DBItem>(int id) async {
    final tableName = _getTableName<T>();
    final fromMap = _getFromMapMethod<T>();

    final List<Map> maps = await _db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return fromMap(maps.first.cast());
    }
    return null;
  }

  Future<List<T?>> getAll<T extends DBItem>() async {
    final tableName = _getTableName<T>();
    final fromMap = _getFromMapMethod<T>();

    final List<Map<String, dynamic>> maps = await _db.query(tableName);
    print(maps);
    final List<T?> result = maps.map<T?>((map) => fromMap(map)).toList();
    return result;
  }

  Future<int> delete<T extends DBItem>(int id) {
    final tableName = _getTableName<T>();

    return _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll<T extends DBItem>() {
    final tableName = _getTableName<T>();

    return _db.delete(tableName);
  }

  Future<int> update<T extends DBItem>(T item) {
    return _db.update(
      item.getTableName(),
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  String _getTableName<T extends DBItem>() {
    print(T.toString());
    if (DBGroups.isMatch<T>()) {
      return DBGroups.tableName;
    }

    if (DBScheduleDay.isMatch<T>()) {
      return DBScheduleDay.tableName;
    }

    if (DBSubject.isMatch<T>()) {
      return DBSubject.tableName;
    }

    if (DBSubjectSchedule.isMatch<T>()) {
      return DBSubjectSchedule.tableName;
    }

    if (DBTask.isMatch<T>()) {
      return DBTask.tableName;
    }

    throw Exception('Unsupported DB model');
  }

  Function(Map<String, dynamic> map) _getFromMapMethod<T extends DBItem>() {
    if (DBGroups.isMatch<T>()) {
      return DBGroups.fromMap;
    }

    if (DBScheduleDay.isMatch<T>()) {
      return DBScheduleDay.fromMap;
    }

    if (DBSubject.isMatch<T>()) {
      return DBSubject.fromMap;
    }

    if (DBSubjectSchedule.isMatch<T>()) {
      return DBSubjectSchedule.fromMap;
    }

    if (DBTask.isMatch<T>()) {
      return DBTask.fromMap;
    }

    throw Exception('Unsupported DB model');
  }
}

final dbProvider = Provider((ref) => DB.instance);
