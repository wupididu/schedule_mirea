import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';

/// Данная утилита устанавливает файл с расписанием в определенное место
/// на устройстве из сети по URL адресу
class ScheduleFileInstaller {

  /// Метод возвращает место, где лежит файл
  Future<String> get scheduleFilePath async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    return documentDirectory.path + "/schedule.xlsx";
  }

  /// Данный метод устанваливает файл из uri
  Future<void> downloadFile(String uri) async {
    var url = Uri.tryParse(uri);
    if (url == null) {
      return;
    }
    var response = await get(url);
    final path = await scheduleFilePath;
    final file = File(path);
    file.writeAsBytesSync(response.bodyBytes);
  }

  Future<void> deleteFile() async {
    final path = await scheduleFilePath;
    final file = File(path);
    await file.delete();
  }
}

final scheduleFileInstallerProvider = Provider((ref)=>ScheduleFileInstaller());