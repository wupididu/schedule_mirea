import 'package:flutter/material.dart';

import '../../db/models/state_of_task.dart';
import '../../db/models/task.dart';
import '../consts.dart';

class StatusTaskIcon extends StatelessWidget {
  final Task task;

  StatusTaskIcon({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        _statusIcon[task.stateOfTask],
        color: _iconColor[task.stateOfTask],
      ),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border:
        Border.all(color: _iconColor[task.stateOfTask]!),
        borderRadius:
        const BorderRadius.all(Radius.circular(100)),
      ),
    );
  }

  final _statusIcon = {
    StateOfTask.backlog: Icons.book_outlined,
    StateOfTask.inProgress: Icons.work_outline,
    StateOfTask.doneNotPassed: Icons.done,
    StateOfTask.doneAndPassed: Icons.done_all_outlined,
  };

  final _iconColor = {
    StateOfTask.backlog: kButtonTextColor,
    StateOfTask.inProgress: kButtonTextColor,
    StateOfTask.doneNotPassed: kButtonTextColor,
    StateOfTask.doneAndPassed: kAccentColor,
  };
}
