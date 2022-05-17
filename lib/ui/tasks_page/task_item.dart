import 'package:flutter/material.dart';
import 'package:schedule_mirea/db/models/state_of_task.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_page.dart';
import 'package:schedule_mirea/ui/widgets/simple_dialog_builder.dart';
import 'package:schedule_mirea/ui/widgets/status_task_icon.dart';

import '../../db/models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final int subjectId;
  final bool done;
  TaskItem({
    Key? key,
    required this.task,
    required this.subjectId,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  TaskEditorPage(task: task, subjectId: subjectId),
            ),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => simpleDialogBuilder(context, task),
          );
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: _buttonColor[task.stateOfTask],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    task.name,
                    maxLines: 3,
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: _buttonTextColor[task.stateOfTask],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _formatDate(task),
                      style: TextStyle(
                        color: _buttonTextColor[task.stateOfTask],
                        fontSize: 12,
                      ),
                    ),
                    StatusTaskIcon(task: task),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(Task task) {
    final date = task.deadline;
    return '${_dayOfWeek[date.weekday]}, ${date.day} ${_month[date.month]}';
  }

  final _dayOfWeek = {
    DateTime.sunday: 'вс',
    DateTime.monday: 'пн',
    DateTime.tuesday: 'вт',
    DateTime.thursday: 'ср',
    DateTime.wednesday: 'чт',
    DateTime.friday: 'пт',
    DateTime.saturday: 'сб',
  };

  final _month = {
    DateTime.january: 'январь',
    DateTime.february: 'февраль',
    DateTime.march: 'март',
    DateTime.april: 'апрель',
    DateTime.may: 'май',
    DateTime.june: 'июнь',
    DateTime.july: 'июль',
    DateTime.august: 'август',
    DateTime.september: 'сентябрь',
    DateTime.october: 'октябрь',
    DateTime.november: 'ноябрь',
    DateTime.december: 'декабрь',
  };

  final _buttonColor = {
    StateOfTask.backlog: kPrimaryColor,
    StateOfTask.inProgress: kPrimaryColor,
    StateOfTask.doneNotPassed: kPrimaryColor,
    StateOfTask.doneAndPassed: kSecondaryColor,
  };

  final _buttonTextColor = {
    StateOfTask.backlog: kButtonTextColor,
    StateOfTask.inProgress: kButtonTextColor,
    StateOfTask.doneNotPassed: kButtonTextColor,
    StateOfTask.doneAndPassed: kTextColor,
  };
}
