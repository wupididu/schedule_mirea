import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/db/db.dart';
import 'package:schedule_mirea/db/models/db_task.dart';
import 'package:schedule_mirea/db/models/state_of_task.dart';
import 'package:schedule_mirea/utils/settings.dart';

import '../db/models/subject.dart';
import '../db/models/task.dart';

/// Данный контроллер необходим для того чтобы взаимодейстововать с задчами в
/// базе данных. Данный контроллер имеет методы для того чтобы изменять и получать
/// данные, а также стрим для того чтобы получать актуальную информацию в потоке.
///
/// Перед началом использования контроллера, надо
/// проинициализировать его методом [init], передав ему [subjectId] -
/// это id предмета, который он отслеживает.
///
class TasksController {
  final DB _db;
  final Settings _settings;

  TasksController(this._db, this._settings);

  StreamController<List<Task>>? _streamController;
  final StreamController<List<Task>> _allTaskStreamController = StreamController<List<Task>>.broadcast();

  /// Это поток задач для предмета с [_subjectId]
  Stream<List<Task>> get tasksStream => _streamController!.stream;
  int? _subjectId;

  Stream<List<Task>> get allTaskStream => _allTaskStreamController.stream;

  /// Этот метод надо вызвать перед использованием контроллер
  Future<void> init(int subjectId) async {
    _subjectId = subjectId;
    final tasks = await getTasks(subjectId: _subjectId);
    _streamController = StreamController();
    _streamController?.add(tasks);
  }

  /// Этот метод необходимо вызвать, когда контрллер больше не нужен
  Future<void> dispose() async {
    _streamController?.close();
    _streamController = null;
    _subjectId = null;
  }

  /// Метод вызвращает списко задач.
  ///
  /// Если не передать [groupCode] то он вернет список задач, основываясь на
  /// данных из настроек.
  ///
  /// Если передать [subjectId], то вернет задачи для определенного предмета.
  /// Если не передать [subjectId], то он вернет все задачи для определенной группы.
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

  Future<List<Task>> getTasksByDateTime(DateTime dateTime) async {
    await _db.initialized;

    final _groupCode = await _settings.getGroup();

    if (_groupCode == null) {
      throw Exception('Group not exist in the settings');
    }

    final tasks = await _db.getTasksByDateTime(_groupCode, dateTime);

    return tasks.map((e) => Task(
      id: e.id!,
      name: e.name,
      deadline: e.deadline,
      description: e.description,
      stateOfTask: e.stateOfTask,
    )).toList();
  }

  /// Если не передать [groupCode] то он вернет список задач, основываясь на
  /// данных из настроек.
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

    _updateStreamTask();

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

    await _db.updateTask(dbTask);

    _updateStreamTask();
  }

  Future<void> deleteTask(int taskId) async {
    await _db.deleteTask(taskId);
    final groupCode = await _settings.getGroup();
    if (groupCode == null) {
      return;
    }
    _updateStreamTask();
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

  Future<void> _updateStreamTask() async {
    getTasks(subjectId: _subjectId)
        .then((value) => _streamController?.add(value));
    final allTasks = await getTasks();
    _allTaskStreamController.add(allTasks);
  }
}

final tasksControllerProvider = Provider((ref) => TasksController(
      ref.watch(dbProvider),
      ref.watch(settingsProvider),
    ));
