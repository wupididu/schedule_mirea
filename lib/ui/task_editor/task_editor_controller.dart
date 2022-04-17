import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  TaskEditorController(this._tasksController, this._settings);

  void init(int subjectId, [Task? task]) {
    titleController = TextEditingController();

    if (task == null) {
      quillController = QuillController.basic();
    } else {
      final text = jsonDecode(task.description);
      quillController = QuillController(
        document: Document.fromJson(text),
        selection: const TextSelection.collapsed(offset: 0),
      );
      titleController.text = task.name;
    }

    _task = task;
    _subjectId = subjectId;
  }

  void dispose() {
    quillController.dispose();
    titleController.dispose();
    _task = null;
    _subjectId;
  }

  void deleteTask() {
    quillController.clear();
    titleController.clear();
    if (_task == null) {
      return;
    }
    _tasksController.deleteTask(_task!.id);
    _task = null;
  }

  Future<void> saveTask() async {
    if (_subjectId == null) {
      throw Exception('TaskEditorController: not init');
    }

    if (_task == null) {
      final name = titleController.text;
      // TODO: надо еще подумать как выбирать дату
      final deadline = DateTime.now();
      final description =
          jsonEncode(quillController.document.toDelta().toJson());
      const stateOfTask = StateOfTask.backlog;
      final groupCode = await _settings.getGroup();
      if(groupCode == null){
        throw Exception('');
      }
      final subjectId = _subjectId!;

      _task = await _tasksController.insertTask(
        name: name,
        deadline: deadline,
        description: description,
        stateOfTask: stateOfTask,
        groupCode: groupCode,
        subjectId: subjectId,
      );
    } else {
      final name = titleController.text;
      final description =
      jsonEncode(quillController.document.toDelta().toJson());

      final task = _task!.copyWith(
        name: name,
        description: description,
      );
      await _tasksController.updateTask(task);
      print('updated');
    }
  }
}

final taskEditorControllerProvider = Provider(
  (ref) => TaskEditorController(
    ref.watch(tasksControllerProvider),
    ref.watch(settingsProvider),
  ),
);
