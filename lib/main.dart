import 'package:flutter/material.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/task_editor/task_editor_page.dart';
import 'db/models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? subjectId;
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await MethodsProvider.get().db.init();
    await MethodsProvider.get().settings.init();
    MethodsProvider.get().settings
      ..setGroup('ИВБО-02-19')
      ..setTimeNotification(const TimeOfDay(hour: 12, minute: 0));
    final subjects = await MethodsProvider.get()
        .scheduleController
        .getSubjects('ИВБО-02-19');
    final tasks = await MethodsProvider.get()
        .tasksController
        .getTasks(groupCode: 'ИВБО-02-19', subjectId: subjects.first.id);
    setState(() {
      subjectId = subjects.first.id;
      _tasks.addAll(tasks);
    });
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    print('print');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final children = _tasks
        .map(
          (e) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskEditorPage(
                    subjectId: subjectId!,
                    task: e,
                  ),
                ),
              );
            },
            child: Text(e.name),
          ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: subjectId == null
            ? const Center(
                child: Text('Loading ...'),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  final tasks = await MethodsProvider.get()
                      .tasksController
                      .getTasks(groupCode: 'ИВБО-02-19', subjectId: subjectId);
                  setState(() {
                    _tasks.clear();
                    _tasks.addAll(tasks);
                  });
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    ...children,
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskEditorPage(
                              subjectId: subjectId!,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
