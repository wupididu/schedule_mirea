import 'dart:io';

import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';

class SheduleFileInstaller {
  Future<String> get sheduleFilePath async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    return documentDirectory.path + "/shedule.xlsx";
  }

  Future<void> downloadFile(String uri) async {
    var url = Uri.tryParse(uri);
    if (url == null) {
      return;
    }
    var response = await get(url);
    final path = await sheduleFilePath;
    final file = File(path);
    file.writeAsBytesSync(response.bodyBytes);
  }

  Future<void> deleteFile() async {
    final path = await sheduleFilePath;
    final file = File(path);
    await file.delete();
  }
}
