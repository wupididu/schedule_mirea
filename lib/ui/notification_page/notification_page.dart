import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    AwesomeNotifications()
        .listScheduledNotifications()
        .then((value) => setState(() {
              _notifications = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          final value =
              await AwesomeNotifications().listScheduledNotifications();
          setState(() {
            _notifications = value;
          });
        },
        child: ListView(
          children: _notifications.map((e) => Text(e.toString())).toList(),
        ),
      ),
    );
  }
}
