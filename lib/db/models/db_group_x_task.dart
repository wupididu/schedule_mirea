import 'db_groups.dart';
import 'db_subject.dart';
import 'db_task.dart';

class DBGroupXTask {
  static const tableName = 'group_x_task';

  static const columnGroupId = 'group_id';
  static const columnSubjectId = 'subject_id';
  static const columnTaskId = 'task_id';

  static const createTableQuery = '''
    create table $tableName (
      $columnGroupId integer not null,
      $columnSubjectId integer not null,
      $columnTaskId integer not null,
      primary key ($columnGroupId, $columnSubjectId, $columnTaskId),
      foreign key ($columnGroupId) references ${DBGroups.tableName} (${DBGroups.columnId}),
      foreign key ($columnSubjectId) references ${DBSubject.tableName} (${DBSubject.columnId}),
      foreign key ($columnTaskId) references ${DBTask.tableName} (${DBTask.columnId})
    )
  ''';

  int groupId;
  int subjectId;
  int taskId;

  DBGroupXTask({
    required this.groupId,
    required this.taskId,
    required this.subjectId,
  });

  Map<String, dynamic> toMap() => {
        columnGroupId: groupId,
        columnTaskId: taskId,
        columnSubjectId: subjectId,
      };

  factory DBGroupXTask.fromMap(Map<String, dynamic> map) => DBGroupXTask(
        groupId: map[columnGroupId],
        taskId: map[columnTaskId],
        subjectId: map[columnSubjectId],
      );
}
