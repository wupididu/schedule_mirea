abstract class DBItem {
  int? id;

  static const columnId = 'id';
  
  String getTableName();

  Map<String, dynamic> toMap();  
}