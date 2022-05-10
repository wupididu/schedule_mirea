import 'package:flutter/foundation.dart';

class DBScheduleDay{
  static const tableName = 'schedule_day';

  static const columnId = 'schedule_day_id';
  static const columnIsEven = 'is_even';
  static const columnDayOfWeek = 'day_of_week';

  static const createTableQuery = '''
  create table $tableName (
    $columnId integer primary key autoincrement,
    $columnIsEven bool not null,
    $columnDayOfWeek text not null
  )
''';

  int? id;
  bool isEven;
  DayOfWeek dayOfWeek;

  DBScheduleDay({
    this.id,
    required this.isEven,
    required this.dayOfWeek,
  });

  factory DBScheduleDay.fromMap(Map<String, dynamic> map) => DBScheduleDay(
        id: map[columnId] as int?,
        isEven: map[columnIsEven] == 1,
        dayOfWeek: DayOfWeek.values.firstWhere(
            (element) => describeEnum(element) == map[columnDayOfWeek]),
      );

  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnIsEven: isEven ? 1 : 0,
        columnDayOfWeek: describeEnum(dayOfWeek),
      };
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}
