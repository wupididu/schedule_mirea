import 'package:flutter/material.dart';

import '../../db/models/state_of_task.dart';
import '../../db/models/task.dart';
import '../../methods_provider.dart';
import '../consts.dart';

SimpleDialog simpleDialogBuilder(context, Task task) => SimpleDialog(
  children: [
    SimpleDialogOption(
      child: Row(
        children: const [
          Icon(
            Icons.delete,
            color: kAccentColor,
          ),
          SizedBox(width: 8),
          Text('delete'),
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Удалить?'),
            actions: [
              TextButton(
                onPressed: () {
                  MethodsProvider.get()
                      .tasksController
                      .deleteTask(task.id);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'да',
                  style: TextStyle(color: kAccentColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'нет',
                  style: TextStyle(color: kAccentColor),
                ),
              ),
            ],
          ),
        );
      },
    ),
    ...(StateOfTask.values
        .map(
          (e) => SimpleDialogOption(
        child: Row(
          children: [
            Icon(
              _statusIcon[e],
              color: kAccentColor,
            ),
            const SizedBox(width: 8),
            Text(_status[e] ?? ''),
          ],
        ),
        onPressed: () {
          MethodsProvider.get()
              .tasksController
              .updateTask(task.copyWith(stateOfTask: e));
          Navigator.of(context).pop();
        },
      ),
    )
        .toList())
  ],
);

final _status = {
  StateOfTask.backlog: 'backlog',
  StateOfTask.inProgress: 'progress',
  StateOfTask.doneNotPassed: 'done',
  StateOfTask.doneAndPassed: 'passed',
};

final _statusIcon = {
  StateOfTask.backlog: Icons.book_outlined,
  StateOfTask.inProgress: Icons.work_outline,
  StateOfTask.doneNotPassed: Icons.done,
  StateOfTask.doneAndPassed: Icons.done_all_outlined,
};