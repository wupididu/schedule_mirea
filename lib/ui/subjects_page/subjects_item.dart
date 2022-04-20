import 'package:flutter/material.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/tasks_page/tasks_page.dart';

import '../../models/subject_from_table.dart';

class SubjectsItem extends StatelessWidget {
  final String name;
  final Map<TypeOfSubject, int>? types;

  SubjectsItem({Key? key, required this.name, this.types}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: kTextColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      onTap: () async {
        if (types == null) {
          return;
        }

        if (types!.length > 1) {
          await showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                    // title: const Text('Выбери для какого предмата'),
                    children: types!.keys
                        .map((e) => SimpleDialogOption(
                              child: Row(
                                children: [
                                  Icon(
                                    _chooseIcon[e],
                                    color: kAccentColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(_chooseText[e] ?? ''),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TasksPage(
                                        name: name, subjectId: types![e]!)));
                              },
                            ))
                        .toList(),
                  ));
        } else if (types!.length == 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  TasksPage(name: name, subjectId: types!.values.first)));
        }
      },
    );
  }

  final _chooseText = {
    TypeOfSubject.lek: 'Лекция',
    TypeOfSubject.lab: 'Лабораторная',
    TypeOfSubject.prac: 'Практическая',
  };

  final _chooseIcon = {
    TypeOfSubject.lek: Icons.book_outlined,
    TypeOfSubject.lab: Icons.science,
    TypeOfSubject.prac: Icons.edit,
  };
}
