import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_controller.dart';

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
  bool readOnly = true;

  @override
  void initState() {
    super.initState();
    if (widget.task == null) {
      readOnly = false;
    }
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
        elevation: 0,
        leadingWidth: 50,
        leading: IconButton(
          onPressed: _onPressArrowBackButton,
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: kTextColor,
          ),
        ),
        title: Text(
          'Задание',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: kTextColor),
        ),
        titleSpacing: 0,
        actions: _actions,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextFormField(
                    controller: _textController,
                    style: Theme.of(context).textTheme.headline4,
                    enabled: !readOnly,
                    decoration: InputDecoration(
                      hintText: 'Задание',
                      border: InputBorder.none,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: kHintTextColor),
                    ),
                  ),
                  Expanded(
                    child: _getEditor(),
                  ),
                ],
              ),
            ),
          ),
          QuillToolbar.basic(
            iconTheme: const QuillIconTheme(
              iconSelectedFillColor: kPrimaryColor,
            ),
            controller: _quillController,
            multiRowsDisplay: false,
            onImagePickCallback: (file) async => file.path,
            onVideoPickCallback: (file) async => file.path,
          ),
        ],
      ),
    );
  }

  void _onPressArrowBackButton() {
    if (MethodsProvider.get().taskEditorController.isUnsafe()) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Сохранить изменения?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      MethodsProvider.get().taskEditorController.saveTask();
                      Navigator.of(context).pop();
                    },
                    child: const Text('да'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('нет'),
                  ),
                ],
              )).then((value) => Navigator.of(context).pop());
    } else {
      Navigator.of(context).pop();
    }
  }

  List<Widget> get _actions => [
        readOnly
            ? IconButton(
                onPressed: () => setState(() {
                  readOnly = false;
                }),
                icon: const Icon(
                  Icons.edit,
                  color: kTextColor,
                ),
              )
            : IconButton(
                onPressed: () async {
                  await MethodsProvider.get().taskEditorController.saveTask();
                  setState(() {
                    readOnly = true;
                  });
                },
                icon: const Icon(
                  Icons.save_outlined,
                  color: kTextColor,
                ),
              ),
        IconButton(
          onPressed: _onPressCalendarButton,
          icon: const Icon(
            Icons.calendar_today_outlined,
            color: kTextColor,
          ),
        ),
        IconButton(
          onPressed: () {
            MethodsProvider.get().taskEditorController.deleteTask();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.delete_outline,
            color: kTextColor,
          ),
        ),
      ];

  void _onPressCalendarButton() {
    showDatePicker(
      context: context,
      initialDate:
          MethodsProvider.get().taskEditorController.deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      currentDate: MethodsProvider.get().taskEditorController.deadline,
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: kPrimaryColor,
          ),
        ),
        child: child!,
      ),
    ).then(
      (value) {
        if (value != null) {
          MethodsProvider.get().taskEditorController.deadline = value;
        }
      },
    );
  }

  QuillEditor _getEditor() => readOnly
      ? QuillEditor(
          controller: _quillController,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: FocusNode(),
          autoFocus: true,
          readOnly: true,
          expands: false,
          padding: EdgeInsets.zero,
          keyboardAppearance: Brightness.light,
          placeholder: "Описание",
        )
      : QuillEditor(
          controller: _quillController,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: FocusNode(),
          autoFocus: true,
          readOnly: false,
          expands: false,
          padding: EdgeInsets.zero,
          keyboardAppearance: Brightness.light,
          placeholder: "Описание",
        );
}
