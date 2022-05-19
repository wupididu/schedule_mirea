import 'package:flutter/material.dart';
import 'package:schedule_mirea/controllers/schedule_controller.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';
import 'package:schedule_mirea/ui/subjects_page/subjects_item.dart';

import '../../db/models/subject.dart';
import '../consts.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<Subject> _subjects = [];
  final ScheduleController _scheduleController =
      MethodsProvider.get().scheduleController;

  @override
  void initState() {
    super.initState();
    _scheduleController.getSubjects().then((value) => setState(() {
          _subjects = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final mapSubject = <String, Map<TypeOfSubject, int>>{};
    final subjects = _subjects.map((e) {
      print(e);
      final reg = RegExp(r'кр.|^[0-9].*н\s');
      final name = e.name.replaceAll(reg, '').trim();
      return e.copyWith(name: name);
    }).where((element) => !element.name.contains('..'));
    for (var element in subjects) {
      if (mapSubject.keys.contains(element.name)) {
        mapSubject[element.name]?.addAll({element.type: element.id});
      } else {
        mapSubject.addAll({
          element.name: {element.type: element.id}
        });
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Предметы',
            style: TextStyle(
              color: kTextColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titleSpacing: 0,
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 140 / 80,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: mapSubject.keys
            .map((name) => SubjectsItem(name: name, types: mapSubject[name]))
            .toList(),
      ),
    );
  }
}
