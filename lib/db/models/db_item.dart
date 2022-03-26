abstract class DBItem {
  int? id;
  
  String getTableName();

  Map<String, dynamic> toMap();  
}