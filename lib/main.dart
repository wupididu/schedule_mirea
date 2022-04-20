import 'package:flutter/material.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'ui/app_page/app_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    MethodsProvider.get().db.init();
    MethodsProvider.get().settings.init();
    MethodsProvider.get().settings.setGroup('ИВБО-02-19');
    MethodsProvider.get().pathSchedulerProviderController.getLink('ИВБО-02-19');
    MethodsProvider.get().scheduleController.addScheduleOnWeek();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: kTheme,
      home: const AppPage(),
    );
  }
}
