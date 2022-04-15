import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/subject_from_table.dart';

class DBSubject {
  static const tableName = 'subject';

  static const columnId = 'subject_id';
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

  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnName: name,
        columnRoom: room,
        columnType: describeEnum(type),
        columnTeacher: teacher,
      };

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DBSubject &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.teacher, teacher) &&
            const DeepCollectionEquality().equals(other.room, room) &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(room),
      const DeepCollectionEquality().hash(teacher),
      const DeepCollectionEquality().hash(type));
}
