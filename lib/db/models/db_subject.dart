import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/db/models/db_item.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';

class DBSubject with DBItem {
  @override
  String getTableName() => tableName;

  static const tableName = 'subject';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnRoom = 'room';
  static const columnType = 'type';
  static const columnTeacher = 'teacher';

  static const createTableQuery = ''' 
    create table $tableName (
      $columnId integer primary key autoincrement,
      $columnName text not null,
      $columnRoom text not null,
      $columnType text not null,
      $columnTeacher text not null
    )
  ''';

  int? id;
  String name;
  String room;
  TypeOfSubject type;
  String teacher;

  DBSubject({
    this.id,
    required this.name,
    required this.room,
    required this.type,
    required this.teacher,
  });

  factory DBSubject.fromMap(Map<String, dynamic> map) => DBSubject(
        id: map[columnId],
        name: map[columnName],
        room: map[columnRoom],
        type: TypeOfSubject.values.firstWhere(
          (element) => describeEnum(element) == map[columnType],
          orElse: () => TypeOfSubject.none,
        ),
        teacher: map[columnTeacher],
      );

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnName: name,
        columnRoom: room,
        columnType: describeEnum(type),
        columnTeacher: teacher,
      };

  static bool isMatch<T extends DBItem>() => T.toString() == 'DBSubject';

  @override
  int? getId() => id;

  @override
  void setId(int id) {
    this.id = id;
  }
}
