import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/consts.dart';
import 'package:schedule_mirea/ui/notification_page/notification_page_controller.dart';

import '../task_editor/task_editor_page.dart';
import 'notification_page_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final NotificationPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MethodsProvider.get().notificationPageController;
    _controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Уведомления',
            style: TextStyle(
              color: kTextColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titleSpacing: 0,
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _controller.update,
        child: StreamBuilder<List<NotificationPageItemData>>(
          stream: MethodsProvider.get().notificationPageStateHolder.stream,
          builder: (context, snapshot) => ListView(
            children:
                snapshot.data?.map((e) => NotificationItem(item: e)).toList() ??
                    [],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationPageItemData item;

  const NotificationItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TaskEditorPage(task: item.subjectTask.task, subjectId: item.subjectTask.subject.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.subjectTask.subject.name,
                        style: const TextStyle(
                            color: kTextColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.subjectTask.task.name,
                        style: const TextStyle(color: kSecondTextColor),
                      ),
                    ],
                  ),
                ),
                if (item.notificationModel.schedule != null)
                  _getTimeMark(item.notificationModel.schedule!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTimeMark(NotificationSchedule data) {
    final month = data.toMap()['month'];
    final day = data.toMap()['day'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '$month.$day',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: kAccentColor,
        ),
      ),
    );
  }
}
