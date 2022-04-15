class DBGroups{
  static const tableName = 'groups';

  static const columnId = 'group_id';
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

  Map<String, dynamic> toMap() => {
        if (id != null) columnId: id,
        columnGroupCode: groupCode,
      };

  factory DBGroups.fromMap(Map<String, dynamic> map) => DBGroups(
        id: map[columnId] as int?,
        groupCode: map[columnGroupCode] as String,
      );
}
