import 'package:schedule_mirea/db/models/db_item.dart';

class DBGroups with DBItem{
  @override
  String getTableName() => tableName;

  static const tableName = 'groups';

  static const columnId = 'id';
  static const columnGroupCode = 'group_code';

  static const createTableQuery = '''
  create table $tableName (
    $columnId integer primary key autoincrement,
    $columnGroupCode text not null
  )
''';


  int? id;
  String groupCode;

  DBGroups({
    this.id,
    required this.groupCode,
  });

  @override
  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnGroupCode: groupCode,
      };

  factory DBGroups.fromMap(Map<String, dynamic> map) => DBGroups(
        id: map[columnId] as int?,
        groupCode: map[columnGroupCode] as String,
      );

  static bool isMatch<T extends DBItem>() => T.toString() == 'DBGroups';

  @override
  int? getId() => id;

  @override
  void setId(int id) {
    this.id = id;
  }
}
