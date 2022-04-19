import 'package:flutter/material.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'ui/app_page/app_page.dart';

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
      home: const AppPage(),
    );
  }
}
