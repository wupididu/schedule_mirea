import 'package:flutter/foundation.dart';
import 'state_of_task.dart';

class DBTask{
  static const tableName = 'task';

  static const columnId = 'task_id';
  static const columnName = 'name';
  static const columnDeadline = 'deadline';
  static const columnDescription = 'description';
  static const columnStateOfTask = 'state_of_task';

  static const createTableQuery = ''' 
    create table $tableName (
      $columnId integer primary key autoincrement, 
      $columnName text not null,
      $columnDeadline datetime not null,
      $columnDescription text not null,
      $columnStateOfTask text not null
     )
  ''';

  int? id;
  String name;
  DateTime deadline;
  String description;
  StateOfTask stateOfTask;

  DBTask({
    this.id,
    required this.name,
    required this.deadline,
    required this.description,
    required this.stateOfTask,
  });

  factory DBTask.fromMap(Map<String, dynamic> map) => DBTask(
        id: map[columnId],
        name: map[columnName],
        deadline: DateTime.parse(map[columnDeadline]),
        description: map[columnDescription],
        stateOfTask: StateOfTask.values.firstWhere(
            (element) => describeEnum(element) == map[columnStateOfTask]),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnName: name,
        columnDeadline: deadline.toString(),
        columnDescription: description,
        columnStateOfTask: describeEnum(stateOfTask),
      };
}
