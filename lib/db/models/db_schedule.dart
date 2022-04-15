import 'db_groups.dart';
import 'db_schedule_day.dart';
import './db_subject.dart';

class DBSchedule{

  static const tableName = 'schedule';

  static const columnGroupId = 'group_id';
  static const columnPairId = 'pair_id';
  static const columnScheduleDayId = 'schedule_day_id';
  static const columnSubjectId = 'subject_id';


  static const createTableQuery = ''' 
    create table $tableName (
      $columnGroupId integer not null,
      $columnScheduleDayId integer not null,
      $columnPairId integer not null,
      $columnSubjectId integer not null,
      primary key ($columnGroupId, $columnScheduleDayId, $columnPairId),
      foreign key ($columnScheduleDayId) references ${DBScheduleDay.tableName} (${DBScheduleDay.columnId}),
      foreign key ($columnGroupId) references ${DBGroups.tableName} (${DBGroups.columnId}),
      foreign key ($columnSubjectId) references ${DBSubject.tableName} (${DBSubject.columnId})
    )
  ''';

  int groupId;
  int pairId;
  int scheduleDayId;
  int subjectId;

  DBSchedule({
    required this.groupId,
    required this.pairId,
    required this.scheduleDayId,
    required this.subjectId,
  });

  factory DBSchedule.fromMap(Map<String, dynamic> map) =>
      DBSchedule(
        groupId: map[columnGroupId],
        pairId: map[columnPairId],
        scheduleDayId: map[columnScheduleDayId],
        subjectId: map[columnSubjectId],
      );

  Map<String, dynamic> toMap() => {
        columnGroupId: groupId,
        columnScheduleDayId: scheduleDayId,
        columnPairId: pairId,
        columnSubjectId: subjectId,
      };
}