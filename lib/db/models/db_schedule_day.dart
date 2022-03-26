import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/db/models/db_item.dart';
import './db_groups.dart';

class DBScheduleDay with DBItem {
  @override
  String getTableName() => tableName;

  static const tableName = 'schedule_day';

  static const columnId = 'id';
  static const columnIsEven = 'is_even';
  static const columnDayOfWeek = 'day_of_week';
  static const columnGroupId = 'group_id';

  static const createTableQuery = '''
  create table $tableName (
    $columnId integer primary key autoincrement,
    $columnIsEven bool not null,
    $columnDayOfWeek text not null,
    $columnGroupId int not null,
    foreign key ($columnGroupId) references ${DBGroups.tableName} (${DBGroups.columnId})
  )
''';

  int? id;
  bool isEven;
  DayOfWeek dayOfWeek;
  int groupId;

  DBScheduleDay({
    this.id,
    required this.isEven,
    required this.dayOfWeek,
    required this.groupId,
  });

  factory DBScheduleDay.fromMap(Map<String, dynamic> map) => DBScheduleDay(
        id: map[columnId] as int?,
        isEven: map[columnIsEven] == 1,
        dayOfWeek: DayOfWeek.values.firstWhere(
            (element) => describeEnum(element) == map[columnDayOfWeek]),
        groupId: map[columnGroupId] as int,
      );

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnIsEven: isEven ? 1 : 0,
        columnDayOfWeek: describeEnum(dayOfWeek),
        columnGroupId: groupId,
      };

  static bool isMatch<T extends DBItem>() => T.toString() == 'DBScheduleDay';

  @override
  int? getId() => id;

  @override
  void setId(int id) {
    this.id = id;
  }
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}
