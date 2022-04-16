import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/models/task.dart';
import 'tasks_controller.dart';
import '../utils/settings.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  final TasksController _tasksController;
  final Settings _settings;
  final _notification = FlutterLocalNotificationsPlugin();
  final _onNotifications = StreamController<String?>();
  Stream<String?> onNotifications() => _onNotifications.stream;

  NotificationController(this._tasksController, this._settings);

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notification.initialize(settings,
        onSelectNotification: (payload) async {
      _onNotifications.add(payload);
    });
    tz.initializeTimeZones();
  }

  Future<void> addNotificationForTask(Task task) async {
    final notificationDays = (await _settings.getDays());

    late final DateTime time;
    late final String title;
    late final String body;
    final subject = await _tasksController.getSubjectByTask(task.id);
    if (task.deadline.day - DateTime.now().day >= notificationDays) {
      time = task.deadline.add(Duration(days: -notificationDays));
      title = "Приближается дедлайн по задаче ${task.name}";
      body = "До дедлайна дней: $notificationDays \n"
          "Задача: ${task.name}\n"
          "Предмет: ${subject.name}";
    } else {
      time = task.deadline.add(const Duration(days: -1));
      title = "Завтра дедлайн по задаче ${task.name}";
      body = "До дедлайна дней: 1 \n"
          "Задача: ${task.name}\n"
          "Предмет: ${subject.name}";
    }

    _scheduleNotification(
      id: task.id,
      title: title,
      body: body,
      time: time,
    );
  }

  /// Если не передать код группы, то он возьмется из настроек
  Future<void> updateNotifications([String? groupCode]) async {
    final code = groupCode ?? await _settings.getGroup();
    if (code == null) {
      throw Exception("Grope code not exist in the settings");
    }

    await _notification.cancelAll();

    final tasks = await _tasksController.getTasks(groupCode: code);

    tasks
        .where((element) => DateTime.now().compareTo(element.deadline) == -1)
        .forEach(addNotificationForTask);
  }

  Future<void> _scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime time,
  }) async {
    _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(time, tz.local),
      await _notificationDetails(),
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }
}

final notificationControllerProvider = Provider((ref) => NotificationController(
    ref.watch(tasksControllerProvider), ref.watch(settingsProvider)));
