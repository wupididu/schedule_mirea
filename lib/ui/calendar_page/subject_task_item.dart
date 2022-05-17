import 'package:flutter/material.dart';
import 'package:schedule_mirea/ui/calendar_page/subject_task.dart';

import '../../models/subject_from_table.dart';
import '../consts.dart';
import '../task_editor/task_editor_page.dart';
import '../widgets/simple_dialog_builder.dart';
import '../widgets/status_task_icon.dart';

class SubjectTaskItem extends StatelessWidget {
  final SubjectTask subjectTask;

  const SubjectTaskItem({Key? key, required this.subjectTask})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  TaskEditorPage(task: subjectTask.task, subjectId: subjectTask.subject.id),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => simpleDialogBuilder(context, subjectTask.task),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Task: ${subjectTask.task.name}',
                          style: _textStyle.copyWith(fontWeight: FontWeight.bold),
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          'Subject: ${subjectTask.subject.name}, $_typeOfSubject',
                          style: _textStyle,
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                      ]),
                ),
                StatusTaskIcon(task: subjectTask.task),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _textStyle = const TextStyle(color: kButtonTextColor);

  String get _typeOfSubject {
    switch (subjectTask.subject.type) {
      case TypeOfSubject.none:
        return '';
      case TypeOfSubject.lek:
        return 'ЛК';
      case TypeOfSubject.prac:
        return 'ПРАК';
      case TypeOfSubject.lab:
        return 'ЛАБ';
    }
  }
}