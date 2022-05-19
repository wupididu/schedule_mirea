import 'package:flutter/material.dart';
import 'package:schedule_mirea/db/models/state_of_task.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_page.dart';
import 'package:schedule_mirea/ui/tasks_page/task_item.dart';

import '../../db/models/task.dart';
import '../consts.dart';

class TasksPage extends StatefulWidget {
  final String name;
  final int subjectId;
  final TypeOfSubject typeOfSubject;

  const TasksPage(
      {Key? key,
      required this.name,
      required this.subjectId,
      required this.typeOfSubject})
      : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _isInit = false;
    init();
  }

  Future<void> init() async {
    await MethodsProvider.get().tasksController.init(widget.subjectId);
    setState(() {
      _isInit = true;
    });
  }

  @override
  void dispose() {
    MethodsProvider.get().tasksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.name,
            textAlign: TextAlign.center,
            maxLines: 4,
            style: const TextStyle(
              color: kTextColor,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              _subjectTypeIcon[widget.typeOfSubject],
              color: kAccentColor,
              size: 40,
            ),
          ),
        ],
        leading: Container(
          alignment: Alignment.topCenter,
          child: IconButton(
            padding: const EdgeInsets.only(top: 8),
            onPressed: _onPressArrowBackButton,
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: kTextColor,
            ),
          ),
        ),
        titleSpacing: 0,
        toolbarHeight: 100,
        elevation: 0,
        leadingWidth: 50,
      ),
      body: _isInit
          ? StreamBuilder<List<Task>>(
              stream: MethodsProvider.get().tasksController.tasksStream,
              builder: (context, snapshot) {
                final notAcceptedTasks = snapshot.data
                    ?.where((element) =>
                        element.stateOfTask != StateOfTask.doneAndPassed)
                    .map(
                      (e) => TaskItem(
                        task: e,
                        subjectId: widget.subjectId,
                        done: false,
                      ),
                    );

                final acceptedTasks = snapshot.data
                    ?.where((element) =>
                        element.stateOfTask == StateOfTask.doneAndPassed)
                    .map(
                      (e) => TaskItem(
                          task: e, subjectId: widget.subjectId, done: true),
                    );
                return ListView(
                  children: [
                    ...?notAcceptedTasks,
                    IconButton(
                      iconSize: 60,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                TaskEditorPage(subjectId: widget.subjectId)));
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: kAccentColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Text('Сдано:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          )),
                    ),
                    if (acceptedTasks != null && acceptedTasks.isEmpty)
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        child: Text(
                          'У тебя пока нет ни одной выполненной работы по этому предмету :(',
                          style: TextStyle(
                            color: kHintTextColor,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      ...?acceptedTasks,
                  ],
                );
              },
            )
          : null,
    );
  }

  void _onPressArrowBackButton() {
    Navigator.of(context).pop();
  }

  final _subjectTypeIcon = {
    TypeOfSubject.lek: Icons.book_outlined,
    TypeOfSubject.lab: Icons.science,
    TypeOfSubject.prac: Icons.edit,
  };
}
