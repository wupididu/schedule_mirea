import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedule_mirea/controllers/tasks_controller.dart';
import 'package:schedule_mirea/db/models/state_of_task.dart';
import 'package:schedule_mirea/utils/settings.dart';

import '../../db/models/task.dart';

class TaskEditorController {
  final TasksController _tasksController;
  late QuillController quillController;
  late TextEditingController titleController;
  final Settings _settings;
  Task? _task;
  int? _subjectId;
  DateTime? deadline;

  TaskEditorController(this._tasksController, this._settings);

  void init(int subjectId, [Task? task]) {
    final document = task == null
        ? Document()
        : Document.fromJson(jsonDecode(task.description));

    titleController = TextEditingController(text: task?.name);
    quillController = QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0));

    _task = task;
    _subjectId = subjectId;
    deadline = task?.deadline;
    if (deadline == null) {
      _getDefaultDateTime.then((value) => deadline == value);
    }
  }

  void dispose() {
    quillController.dispose();
    titleController.dispose();
    _task = null;
    _subjectId = null;
    deadline = null;
  }

  void deleteTask() {
    quillController.clear();
    titleController.clear();
    deadline = null;
    if (_task == null) {
      return;
    }
    _tasksController.deleteTask(_task!.id);
    _task = null;
  }

  bool isUnsafe() {
    if (_task == null || deadline == null) {
      return true;
    }
    final text = _task!.description;
    final title = _task!.name;
    final tDeadline = _task!.deadline;

    final newText = jsonEncode(quillController.document.toDelta().toJson());
    final newTitle = titleController.text;

    if (newText != text ||
        newTitle != title ||
        tDeadline.compareTo(deadline!) != 0) {
      return true;
    }
    return false;
  }

  Future<void> saveTask() async {
    if (_subjectId == null) {
      throw Exception('TaskEditorController: not init');
    }

    if (_task == null) {
      _saveTask();
    } else {
      _updateTask();
    }
  }

  Future<void> _saveTask() async {
    final name = titleController.text;
    final dateNotification = deadline ?? await _getDefaultDateTime;
    final description = jsonEncode(quillController.document.toDelta().toJson());
    const stateOfTask = StateOfTask.backlog;
    final groupCode = await _settings.getGroup();
    if (groupCode == null) {
      throw Exception('');
    }
    final subjectId = _subjectId!;

    print(dateNotification);

    _task = await _tasksController.insertTask(
      name: name,
      deadline: dateNotification,
      description: description,
      stateOfTask: stateOfTask,
      groupCode: groupCode,
      subjectId: subjectId,
    );
  }

  Future<void> _updateTask() async {
    final name = titleController.text;
    final description = jsonEncode(quillController.document.toDelta().toJson());

    _task = _task!.copyWith(
      name: name,
      description: description,
      deadline: deadline ?? _task!.deadline,
    );

    await _tasksController.updateTask(_task!);
  }

  Future<DateTime> get _getDefaultDateTime async {
    final dateNow = DateTime.now();
    final dayNotification = await _settings.getDays();
    return DateTime(dateNow.year, dateNow.month, dateNow.day + dayNotification);
  }
}

final taskEditorControllerProvider = Provider(
  (ref) => TaskEditorController(
    ref.watch(tasksControllerProvider),
    ref.watch(settingsProvider),
  ),
);
