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

  Future<String?> getLink() async{
    String identification =
        _group[0] + _group.substring(_group.length - 2, _group.length);
    var links = await _fillMap();

    if (links.containsKey(identification)) {
      //print(links[identification]);
      return links[identification];
    }
    return null;
  }

  Future<Map<String, String>> _fillMap() async {
    var links = <String, String>{};
    final response =
    await http.Client().get(Uri.parse("https://www.mirea.ru/schedule/"));
    Document document = html.parse(response.body);
    final anchors = document.querySelectorAll('a');
    final nowYear = DateTime.now().year;
    int i = 1;

    for (var anchor in anchors) {
      if (anchor.attributes['class'] == 'uk-link-toggle') {
        if (i == 36) {
          break;
        }
        var href = anchor.attributes['href'];
        String link = href.toString().replaceAll(' ', '_');
        String linkBuff = link;
        int indDash = link.indexOf('_');
        String university = link.substring(80, indDash);

        if (link[indDash + 2] != '_') {
          linkBuff = link.replaceAll('_Стромынка', '');
        }
        i++;

        int yearAdmission = nowYear - int.parse(linkBuff.substring(indDash + 1, indDash + 2));
        String year = yearAdmission.toString();
        int yearSize = year.length;
        //print(_universGroups[university]! + year.substring(yearSize - 2, yearSize));
        //print(link);

        links.putIfAbsent(
            _universGroups[university]! + year.substring(yearSize - 2, yearSize), () => link);
      }
    }

    return links;
  }
}
