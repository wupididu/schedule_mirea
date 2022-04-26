import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

/// Это утилита, которая предоставляет возможность получить ссылку на файл,
/// от кода группы.
class PathSchedulerProvider {
  late String _group;

  final Map<String, String> _universGroups = {
    'иптип': 'Э',
    'иту': 'У',
    'иит': 'И',
    'иии': 'К',
    'икб': 'Б',
    'ирэи': 'Р'
  };

  final _forbiddenWords = <String>{
    'стромынка',
    'экз',
    'маг',
    'расписание',
    'колледж'
  };

  String _enteredCodeGroups() {
    int groupLenght = _group.length;

    return (_group[0] + _group.substring(groupLenght - 2, groupLenght));
  }

  String? _receivedCodeForScheduler(String fileName) {
    final nowYear = DateTime.now().year;
    fileName = fileName.toLowerCase();

    for (String word in _forbiddenWords) {
      if (fileName.contains(word)) {
        return null;
      }
    }

    String university = fileName.split('_')[0];

    int yearAdmission = nowYear - int.parse(fileName.split('_')[1]);
    String year = yearAdmission.toString();
    int yearSize = year.length;

    return (_universGroups[university]! +
        year.substring(yearSize - 2, yearSize));
  }

  /// Данный метда предоставляет ссылку на файл в зависимости от [groupCode]
  ///
  /// Если ссылка на файл не найдена, то возварщается [null]
  Future<String?> getLink(String groupCode) async {
    _group = groupCode;
    final response =
        await http.Client().get(Uri.parse("https://www.mirea.ru/schedule/"));
    Document document = html.parse(response.body);
    final anchors = document.querySelectorAll('a');

    for (var anchor in anchors) {
      if (anchor.attributes['class'] == 'uk-link-toggle') {
        var href = anchor.attributes['href'];
        String link = href.toString();

        String nameLink = link.replaceAll(' ', '_').split('/').last;

        if (_enteredCodeGroups() == _receivedCodeForScheduler(nameLink)) {
          return link;
        }
      }
    }
    return null;
  }
}

final pathSchedulerProvider = Provider((ref) => PathSchedulerProvider());
