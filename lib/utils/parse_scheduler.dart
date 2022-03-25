import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class ParseScheduler {
  late String _group;
  final int twoPositions = 2;
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

  Future<String?> getLink() async {
    const int firstPosition = 0;
    int groupLenght = _group.length;

    String identification = _group[firstPosition] +
        _group.substring(groupLenght - twoPositions, groupLenght);
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

    const int one = 1;
    const int first = 0;

    int i = 1; // counter

    for (var anchor in anchors) {
      if (anchor.attributes['class'] == 'uk-link-toggle') {
        if (i == 36) {
          //limitation for  bechelor's tables
          break;
        }

        var href = anchor.attributes['href'];
        String link = href.toString().replaceAll(' ', '_');
        String linkBuff = link;
        String twoDashPart = link.split('_')[one];

        String university = (link.split('/')[7]).split('_')[first];

        if (twoDashPart.length > one) {
          linkBuff = link.replaceAll('_Стромынка', '');
          twoDashPart = linkBuff.split('_')[one];
        }
        i++;

        int yearAdmission = nowYear - int.parse(twoDashPart);
        String year = yearAdmission.toString();
        int yearSize = year.length;
        //print(_universGroups[university]! + year.substring(yearSize - 2, yearSize));
        //print(link);

        links.putIfAbsent(
            _universGroups[university]! +
                year.substring(yearSize - twoPositions, yearSize),
            () => link);
      }
    }
    return links;
  }
}
