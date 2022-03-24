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
  late final String path;

  DB._();

  static DB get instance => DB._();

  Future<void> init() async {
    final databasePath = await getDatabasesPath();
    path = databasePath + _databaseName;
    _db = await openDatabase(
      _databaseName,
      version: 1,
      onCreate: _onCreate,
    );
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

  Future<T?> get<T extends DBItem>(
    String tableName,
    int id,
    T Function(Map<String, Map> map) fromMap,
  ) async {
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

  Future<int> delete<T extends DBItem>(T item) {
    return _db.delete(
      item.getTableName(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> update<T extends DBItem>(T item) {
    return _db.update(
      item.getTableName(),
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
