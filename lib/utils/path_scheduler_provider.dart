import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

/// Это утилита, которая предоставляет возможность получить ссылку на файл,
/// от кода группы.
class PathSchedulerProvider {
  final Map<String, List<String>> _universGroups = {
    'иптип': ['ЭО', 'ЭЛ', 'ЭН', 'ЭЭ', 'ЭС'],
    'иптип_стр': ['ТШ', 'ТД', 'ТХ', 'ТК', 'ТЛ'],
    'иту': ['УД', 'УИ', 'УС'],
    'иту_стр': ['УП', 'УП', 'УУ', 'УН', 'УЮ', 'УМ'],
    'иит': ['ИА', 'ИВ', 'ИК', 'ИМ', 'ИН'],
    'иии': ['КB', 'КА', 'КМ', 'КБ', 'КС', 'КР', 'КТ', 'КК'],
    'икб': ['БА', 'ББ', 'БИ', 'БС', 'БА', 'БП', 'БФ', 'БЭ', 'БО'],
    'ирэи': ['РС', 'РР', 'РИ', 'РК'],
    'итхт': ['ХЕ', 'ХТ', 'ХБ', 'ХХ']
  };

  final _forbiddenWords = <String>{
    'docx',
    'pdf',
    'rtf',
    'экз',
    'маг',
    'расписание',
    'колледж',
  };

  String _enteredCodeGroups(String groupCode) {
    int groupLenght = groupCode.length;

    return (groupCode.substring(0, 2) + groupCode.substring(groupLenght - 2));
  }

  List<String> _receivedCodesForScheduler(String fileName) {
    final nowYear = DateTime.now().year;
    fileName = fileName.toLowerCase();

    final university = fileName.split('_')[0];

    late final List<String>? supportsGroups;

    if (university == 'иптип' && fileName.contains('сем')) {
      supportsGroups = _universGroups['иптип_стр'];
    } else if (university == 'иту' && fileName.contains('сем')) {
      supportsGroups = _universGroups['иту_стр'];
    } else {
      supportsGroups = _universGroups[university];
    }

    late final String codeYear;
    final elements = fileName.split('_');
    if (fileName.contains('курс')) {
      final index = elements.indexOf('курс');
      final yearAdmission = int.parse(elements[index-1]);
      codeYear = (nowYear - yearAdmission).toString().substring(2);
    } else if (fileName.contains(RegExp(r'[0-9]к'))) {
      final element = elements.firstWhere((element) => RegExp(r'[0-9]к').hasMatch(element))[0];
      final yearAdmission = int.parse(element);
      codeYear = (nowYear - yearAdmission).toString().substring(2);
    } else {
      codeYear = '';
    }


    return supportsGroups?.map((e) => e + codeYear).toList() ?? [];
  }

  /// Данный метда предоставляет ссылку на файл в зависимости от [groupCode]
  ///
  /// Если ссылка на файл не найдена, то возварщается [null]
  Future<String?> getLink(String groupCode) async {
    final response =
        await http.Client().get(Uri.parse("https://www.mirea.ru/schedule/"));

    Document document = await compute(html.parse, response.body);

    return await compute(
        _getLink, {'document': document, 'group_code': groupCode});
  }

  String? _getLink(Map<String, dynamic> params) {
    final document = params['document'] as Document;
    final groupCode = params['group_code'] as String;

    final anchors = document.querySelectorAll('a');
    final neededAnchors = anchors
        .where((element) => element.attributes['class'] == 'uk-link-toggle');
    final links = neededAnchors.map((e) => e.attributes['href']);
    final enteredCodeGroup = _enteredCodeGroups(groupCode);

    for (var link in links) {
      String nameLink = link?.replaceAll(' ', '_').split('/').last ?? '';

      if (_forbiddenWords
          .where((element) => nameLink.contains(element))
          .isEmpty) {
        List<String> codeGroupsForFile = _receivedCodesForScheduler(nameLink);

        if (codeGroupsForFile.contains(enteredCodeGroup)) {
          return link;
        }
      }
    }
    return null;
  }
}

final pathSchedulerProvider = Provider((ref) => PathSchedulerProvider());
