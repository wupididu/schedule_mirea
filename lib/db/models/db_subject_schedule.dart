import 'package:schedule_mirea/db/models/db_item.dart';
import 'db_schedule_day.dart';
import './db_subject.dart';

class DBSubjectSchedule with DBItem {
  @override
  String getTableName() => tableName;

  static const tableName = 'subject_schedule';

  static const columnId = 'id';
  static const columnSubjectNum = 'subject_num';
  static const columnScheduleDayId = 'schedule_day_id';
  static const columnSubjectId = 'subject_id';

  static const createTableQuery = ''' 
    create table $tableName (
      $columnId int primary key,
      $columnSubjectNum int not null,
      $columnScheduleDayId int not null,
      $columnSubjectId int not null,
      foreign key ($columnScheduleDayId) references ${DBScheduleDay.tableName} (${DBScheduleDay.columnId}),
      foreign key ($columnSubjectId) references ${DBSubject.tableName} (${DBSubject.columnId})
    )
  ''';

  @override
  int? id;
  int subjectNum;
  int scheduleDayId;
  int subjectId;

  DBSubjectSchedule({
    this.id,
    required this.subjectNum,
    required this.scheduleDayId,
    required this.subjectId,
  });

  factory DBSubjectSchedule.fromMap(Map<String, dynamic> map) =>
      DBSubjectSchedule(
        id: map[columnId] as int?,
        subjectNum: map[columnSubjectNum],
        scheduleDayId: map[columnScheduleDayId],
        subjectId: map[columnSubjectId],
      );

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnScheduleDayId: scheduleDayId,
        columnSubjectId: subjectId,
      };

  static bool isMatch<T extends DBItem>() => T.toString() == 'DBSubjectSchedule';
}