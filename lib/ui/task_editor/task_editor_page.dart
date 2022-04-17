import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_controller.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_pop_menu.dart';

import '../../db/models/task.dart';

class TaskEditorPage extends StatefulWidget {
  final Task? task;
  final int subjectId;
  const TaskEditorPage({required this.subjectId, this.task, Key? key})
      : super(key: key);

  @override
  State<TaskEditorPage> createState() => _TaskEditorPageState();
}

class _TaskEditorPageState extends State<TaskEditorPage> {
  late final QuillController _quillController;
  late final TextEditingController _textController;
  late final TaskEditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MethodsProvider.get().taskEditorController
      ..init(widget.subjectId, widget.task);
    _quillController = _controller.quillController;
    _textController = _controller.titleController;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kTextColor,
            )),
        leadingWidth: 30,
        title: Text(
          'задание',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        elevation: 0,
        actions: const [TaskEditorPopMenu()],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  TextFormField(
                    controller: _textController,
                    style: Theme.of(context).textTheme.headline4,
                    decoration: const InputDecoration(
                      hintText: 'Задание',
                      border: InputBorder.none,
                    ),
                  ),
                  Expanded(
                    child: QuillEditor.basic(
                      controller: _quillController,
                      readOnly: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          QuillToolbar.basic(
            controller: _quillController,
            multiRowsDisplay: false,
          ),
        ],
      ),
    );
  }
}
