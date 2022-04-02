import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  late SharedPreferences prefs;

  void setDays(int days)  async {
    await prefs.setInt('days', days);
  }

  void setGroup(String group) async {
    await prefs.setString('group', group);
  }

  Future<int?> getDays() async{
    return prefs.getInt('days');
  }

  Future<String?> getGroup() async {
    return prefs.getString('group');
  }
}