abstract class DBItem {
  void setId(int id);

  int? getId();

  String getTableName();

  Map<String, dynamic> toMap();
}