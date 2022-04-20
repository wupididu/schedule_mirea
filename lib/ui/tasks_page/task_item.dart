import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_page.dart';

import '../../db/models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final int subjectId;
  final bool done;
  TaskItem({Key? key, required this.task, required this.subjectId, required this.done})
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
                  TaskEditorPage(task: task, subjectId: subjectId),
            ),
          );
        },
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    task.name,
                    maxLines: 3,
                    textWidthBasis: TextWidthBasis.parent,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kButtonTextColor,
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
                      style: const TextStyle(
                        color: kButtonTextColor,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      child: const Icon(
                        Icons.done,
                        color: kButtonTextColor,
                      ),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: kButtonTextColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                    )
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
}
