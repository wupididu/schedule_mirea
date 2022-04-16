import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  late SharedPreferences prefs;
  Settings._();
  static final _singleton = Settings._();
  static Settings get instance => _singleton;
  bool _isInit = false;


  Future<void> init () async {
    prefs = await SharedPreferences.getInstance();
    _isInit = true;
  }

  void setDaysDeadline(int daysDeadline)  async {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    await prefs.setInt('days', daysDeadline);
  }

  void setGroup(String group) async {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    await prefs.setString('group', group);
  }

  Future<int> getDays() async{
    if (!_isInit){
      throw Exception('Settings not init');
    }
    return prefs.getInt('days') ?? 3;
  }

  Future<String?> getGroup() async {
    if (!_isInit){
      throw Exception('Settings not init');
    }
    return prefs.getString('group');
  }
}

final settingsProvider = Provider((ref) => Settings.instance);