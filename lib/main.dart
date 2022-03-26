import 'package:flutter/material.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/db/models/db_schedule_day.dart';

import 'db/db.dart';
import 'db/models/db_groups.dart';
import 'models/subjects_on_week.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SubjectsOnWeek? subjectsOnWeek;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await MethodsProvider.get().db.init();
    await MethodsProvider.get().scheduleFileInstaller.downloadFile('https://webservices.mirea.ru/upload/iblock/02b/jdfkm0v4ejxqsodmoakzxy9j3ea1i7bk/ИИТ_3 курс_21-22_весна.xlsx');
    final path = await MethodsProvider.get().scheduleFileInstaller.scheduleFilePath;
    MethodsProvider.get().scheduleConverter.setFile(path);
    await MethodsProvider.get().dbRepository.addScheduleOnWeek('ИВБО-03-19');
    update();
  }

  void update() async {
    final subject = await MethodsProvider.get().dbRepository.getSubjectsOnWeek('ИВБО-03-19');
    setState(() {
      subjectsOnWeek = subject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (subjectsOnWeek != null)
              Text(subjectsOnWeek.toString())
            else
              const Text('none'),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              update();
            },
            tooltip: 'update',
            child: const Icon(Icons.update),
          ),
          FloatingActionButton(
            onPressed: () async {
              await MethodsProvider.get().db.deleteAll<DBGroups>();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.delete),
          ),
          FloatingActionButton(
            onPressed: () async {
              final a = await MethodsProvider.get().db.getAll<DBScheduleDay>();
              print(a);
            },
            tooltip: 'Increment',
            child: const Icon(Icons.update),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
