import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';

class ScheduleFileInstaller {
  Future<String> get scheduleFilePath async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    return documentDirectory.path + "/shedule.xlsx";
  }

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