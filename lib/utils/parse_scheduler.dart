import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class ParseScheduler {
  late String _group;

  final Map<String, String> _universGroups = {
    'ИПТИП': 'Э',
    'ИТУ': 'У',
    'ИИТ': 'И',
    'ИИИ': 'К',
    'ИКБ': 'Б',
    'ИРЭИ': 'Р'
  };

  final _forbiddenWords = <String>{"Стромынка", "экз"};

  ParseScheduler(String group) {
    _group = group;
  }

  void setGroup(String group) {
    _group = group;
  }

  String getGroup() {
    return _group;
  }

  String _enteredCodeGroups() {
    int groupLenght = _group.length;

    return (_group[0] + _group.substring(groupLenght - 2, groupLenght));
  }

  String? _receivedCodeForScheduler(String fileName) {
    const String marker = "экз";
    final nowYear = DateTime.now().year;

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

  Future<String?> getLink() async {
    final response =
        await http.Client().get(Uri.parse("https://www.mirea.ru/schedule/"));
    Document document = html.parse(response.body);
    final anchors = document.querySelectorAll('a');

    int i = 1; // counter

    for (var anchor in anchors) {
      if (anchor.attributes['class'] == 'uk-link-toggle') {
        if (i == 44) {
          //limitation for  bechelor's tables
          break;
        }

        var href = anchor.attributes['href'];
        String link = href.toString();

        String nameLink = link.replaceAll(' ', '_').split('/').last;
        //print(_receivedCode(nameLink));

        if (_enteredCodeGroups() == _receivedCodeForScheduler(nameLink)) {
          return link;
        }

        i++;
      }
    }
    return null;
  }
}
