import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/db/db.dart';
import 'package:schedule_mirea/db/models/db_task.dart';
import 'package:schedule_mirea/db/models/state_of_task.dart';

import '../models/task.dart';

class TasksController {
  final DB _db;

  TasksController(this._db);

  Future<List<Task>> getTasks({
    required String groupCode,
    int? subjectId,
  }) async {
    await _db.initialized;

    late List<DBTask> tasks;

    if (subjectId == null) {
      tasks = await _db.getTasks(groupCode);
    } else {
      tasks = await _db.getSubjectTasks(groupCode, subjectId);
    }

    return tasks
        .map((e) => Task(
              id: e.id!,
              name: e.name,
              deadline: e.deadline,
              description: e.description,
              stateOfTask: e.stateOfTask,
            ))
        .toList();
  }

  Future<void> insertTask({
    required String name,
    required DateTime deadline,
    required String description,
    required StateOfTask stateOfTask,
    required String groupCode,
    required int subjectId,
  }) async {
    final task = DBTask(
      name: name,
      deadline: deadline,
      description: description,
      stateOfTask: stateOfTask,
    );
    await _db.insertTask(
      task: task,
      groupCode: groupCode,
      subjectId: subjectId,
    );
  }

  Future<void> updateTask(Task task) async {
    final dbTask = DBTask(
      id: task.id,
      name: task.name,
      deadline: task.deadline,
      description: task.description,
      stateOfTask: task.stateOfTask,
    );

    await _db.updateTask(dbTask);
  }

  Future<void> deleteTask(int taskId) async {
    await _db.deleteTask(taskId);
  }
}

final tasksControllerProvider =
    Provider((ref) => TasksController(ref.watch(dbProvider)));
