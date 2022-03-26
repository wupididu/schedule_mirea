import 'package:flutter/material.dart';
import 'package:schedule_mirea/db/methods_provider.dart';
import 'package:schedule_mirea/db/models/db_schedule_day.dart';

import 'db/db.dart';
import 'db/models/db_groups.dart';

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
  List<DBGroups?> listGroups = [];
  List<DBScheduleDay?> listSD = [];

  @override
  void initState() {
    super.initState();
    MethodsProvider.get().scheduleConverter.setFile('assets/ИИТ_1 курс_21-22_весна.xlsx');
    MethodsProvider.get().dbRepository.addScheduleOnWeek('ИВБО-02-19');
    update();
  }

  void update() async {
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
            for (DBGroups? element in listGroups)
              Text(element?.toMap().toString() ?? 'none'),
            for (DBScheduleDay? element in listSD)
              Text(element?.toMap().toString() ?? 'none')
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
            tooltip: 'delete',
            child: const Icon(Icons.delete),
          ),
          FloatingActionButton(
            onPressed: () async {

            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
