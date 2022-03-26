import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/db/models/db_item.dart';
import './db_subject.dart';

class DBTask with DBItem {
  @override
  String getTableName() => tableName;

  static const tableName = 'task';

  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDeadline = 'deadline';
  static const columnDescription = 'description';
  static const columnStateOfTask = 'state_of_task';
  static const columnSubjectId = 'subject_id';

  static const createTableQuery = ''' 
    create table $tableName (
      $columnId integer primary key autoincrement, 
      $columnName text not null,
      $columnDeadline datetime not null,
      $columnDescription text not null,
      $columnSubjectId int not null,
      constraint fk_${DBSubject.tableName} foreign key ($columnSubjectId) references ${DBSubject.tableName} (${DBSubject.columnId}) on delete cascade
    )
  ''';

  int? id;
  String name;
  DateTime deadline;
  String description;
  StateOfTask stateOfTask;
  int subjectId;

  DBTask({
    this.id,
    required this.name,
    required this.deadline,
    required this.description,
    required this.stateOfTask,
    required this.subjectId,
  });

  factory DBTask.fromMap(Map<String, dynamic> map) => DBTask(
        id: map[columnId],
        name: map[columnName],
        deadline: map[columnDeadline],
        description: map[columnDescription],
        stateOfTask: StateOfTask.values.firstWhere(
            (element) => describeEnum(element) == map[columnStateOfTask]),
        subjectId: map[columnSubjectId],
      );

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnName: name,
        columnDeadline: deadline,
        columnDescription: description,
        columnStateOfTask: describeEnum(stateOfTask),
        columnSubjectId: subjectId,
      };

  static bool isMatch<T extends DBItem>() => T.toString() == 'DBTask';

  @override
  int? getId() => id;

  @override
  void setId(int id) {
    this.id = id;
  }
}

enum StateOfTask {
  backlog,
  inProgress,
  doneNotPassed,
  doneAndPassed,
}
