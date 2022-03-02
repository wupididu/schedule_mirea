import 'dart:io';

import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';

class SheduleFileInstaller {
  String? _sheduleFilePath;

  Future<String?> downloadFile(String uri) async {
    var url = Uri.tryParse(uri);
    if (url == null) {
      return null;
    }
    var response = await get(url);
    var documentDirectory = await getApplicationDocumentsDirectory();
    var _sheduleFilePath = documentDirectory.path + "/shedule.xlsx";
    final file = File(_sheduleFilePath);
    file.writeAsBytesSync(response.bodyBytes);
    return _sheduleFilePath;
  }

  Future<void> deleteFile() async {
    if (_sheduleFilePath == null) {
      return;
    }
    final file = File(_sheduleFilePath!);
    await file.delete();
  }
}
