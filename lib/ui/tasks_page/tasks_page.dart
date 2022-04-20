import 'package:flutter/material.dart';

import '../consts.dart';

class TasksPage extends StatefulWidget {
  final String name;
  final int subjectId;

  const TasksPage({Key? key, required this.name, required this.subjectId})
      : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: Center(
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              maxLines: 200,
              style: const TextStyle(
                color: kTextColor,
                fontSize: 20,
              ),
            ),
          ),
        ),
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
      body: Center(
        child: Text('${widget.subjectId}'),
      ),
    );
  }

  void _onPressArrowBackButton() {
    Navigator.of(context).pop();
  }
}
