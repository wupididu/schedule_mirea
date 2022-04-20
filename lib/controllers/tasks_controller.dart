import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/db/db.dart';
import 'package:schedule_mirea/db/models/db_task.dart';
import 'package:schedule_mirea/db/models/state_of_task.dart';
import 'package:schedule_mirea/utils/settings.dart';

import '../db/models/subject.dart';
import '../db/models/task.dart';

class TasksController {
  final DB _db;
  final Settings _settings;

  TasksController(this._db, this._settings);

  late StreamController<List<Task>> _streamController;

  Stream<List<Task>> get tasksStream => _streamController.stream;
  int? _subjectId;

  Future<void> init(int subjectId) async {
    _subjectId = subjectId;
    final tasks = await getTasks(subjectId: _subjectId);
    _streamController = StreamController();
    _streamController.add(tasks);
  }

  Future<void> dispose() async {
    _streamController.close();
    _subjectId = null;
  }

  Future<List<Task>> getTasks({
    String? groupCode,
    int? subjectId,
  }) async {
    await _db.initialized;

    final _groupCode = groupCode ?? await _settings.getGroup();

    if (_groupCode == null) {
      throw Exception('Group not exist in the settings');
    }

    late List<DBTask> tasks;

    if (subjectId == null) {
      tasks = await _db.getTasks(_groupCode);
    } else {
      tasks = await _db.getSubjectTasks(_groupCode, subjectId);
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

  Future<Task> insertTask({
    required String name,
    required DateTime deadline,
    required String description,
    required StateOfTask stateOfTask,
    required int subjectId,
    String? groupCode,
  }) async {
    final _groupCode = groupCode ?? await _settings.getGroup();
    if (_groupCode == null) {
      throw Exception('Group not exist in the settings');
    }

    final task = DBTask(
      name: name,
      deadline: deadline,
      description: description,
      stateOfTask: stateOfTask,
    );
    final id = await _db.insertTask(
      task: task,
      groupCode: _groupCode,
      subjectId: subjectId,
    );

    getTasks(groupCode: groupCode, subjectId: _subjectId)
        .then((value) => _streamController.add(value));

    return Task(
      id: id,
      name: name,
      deadline: deadline,
      description: description,
      stateOfTask: stateOfTask,
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

    final groupCode = await _settings.getGroup();

    if (groupCode == null) {
      throw Exception('Group not exist in the settings');
    }

    await _db.updateTask(dbTask);

    getTasks(groupCode: groupCode, subjectId: _subjectId)
        .then((value) => _streamController.add(value));
  }

  Future<void> deleteTask(int taskId) async {
    await _db.deleteTask(taskId);
    final groupCode = await _settings.getGroup();
    if (groupCode == null) {
      throw Exception('Group not exist in the settings');
    }
    getTasks(groupCode: groupCode, subjectId: _subjectId)
        .then((value) => _streamController.add(value));
  }

  Future<Subject> getSubjectByTask(int taskId) async {
    final subject = await _db.getSubjectByTask(taskId);
    return Subject(
        id: subject.id!,
        name: subject.name,
        room: subject.room,
        type: subject.type,
        teacher: subject.teacher);
  }

  Future<void> updateStreamTask() async {}
}

final tasksControllerProvider = Provider((ref) => TasksController(
      ref.watch(dbProvider),
      ref.watch(settingsProvider),
    ));
