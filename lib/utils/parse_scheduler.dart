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

  ParseScheduler(String group) {
    _group = group;
  }

  void setGroup(String group) {
    _group = group;
  }

  String getGroup() {
    return _group;
  }

  String _enteredCode() {
    int groupLenght = _group.length;

    return (_group[0] + _group.substring(groupLenght - 2, groupLenght));
  }

  String _receivedCode(String code) {
    const String marker = "экз";
    final nowYear = DateTime.now().year;

    if (code.split('_')[1].length > 1) {
      code = code.replaceAll('_Стромынка', '');
    } else if (code.split('_')[0] != marker) {
      //This is temporary crutch
      String university = code.split('_')[0];

      int yearAdmission = nowYear - int.parse(code.split('_')[1]);
      String year = yearAdmission.toString();
      int yearSize = year.length;

      return (_universGroups[university]! +
          year.substring(yearSize - 2, yearSize));
    }

    return marker;
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

        if (_enteredCode() == _receivedCode(nameLink)) {
          return link;
        }

        i++;
      }
    }
    return null;
  }
}
