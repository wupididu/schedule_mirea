import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/models/task.dart';
import 'tasks_controller.dart';
import '../utils/settings.dart';

class NotificationController {
  final TasksController _tasksController;
  final Settings _settings;
  NotificationController(this._tasksController, this._settings);

  Future<void> init() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'scheduled',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true,
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  Future<void> addNotificationForTask(Task task) async {
    final notificationDays = _settings.getDays();
    final timeNotifications = _settings.getTimeNotification();

    late final DateTime time;
    late final String title;
    late final String body;
    final subject = await _tasksController.getSubjectByTask(task.id);
    if (task.deadline.day - DateTime.now().day >= notificationDays) {
      time = task.deadline.add(Duration(days: -notificationDays));
      title = "Приближается дедлайн по задаче ${task.name}";
      body = "До дедлайна дней: $notificationDays. "
          "Задача: ${task.name}. "
          "Предмет: ${subject.name}. "
          "Время: ${task.deadline.hour}:${task.deadline.minute}";
    } else {
      time = task.deadline.add(const Duration(days: -1));
      title = "Завтра дедлайн по задаче ${task.name}";
      body = "До дедлайна дней: 1. "
          "Задача: ${task.name}. "
          "Предмет: ${subject.name} "
          "Время: ${task.deadline.hour}:${task.deadline.minute}";
    }

    _scheduleNotification(
      id: task.id,
      title: title,
      body: body,
      time: time.add(
        Duration(
          hours: timeNotifications.hour,
          minutes: timeNotifications.minute,
        ),
      ),
    );
  }

  /// Если не передать код группы, то он возьмется из настроек
  Future<void> updateNotifications([String? groupCode]) async {
    final code = groupCode ?? _settings.getGroup();
    if (code == null) {
      throw Exception("Grope code not exist in the settings");
    }

    await AwesomeNotifications().cancelAll();

    final tasks = await _tasksController.getTasks(groupCode: code);

    tasks
        .where((element) => DateTime.now().compareTo(element.deadline) == -1)
        .forEach(addNotificationForTask);
  }

  Future<void> _scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    Map<String, String>? payload,
    required DateTime time,
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'scheduled',
          title: title,
          body: body,
          payload: payload,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          autoDismissible: false,
          notificationLayout: NotificationLayout.BigText,
        ),
        schedule: NotificationCalendar.fromDate(date: time));
  }
}

final notificationControllerProvider = Provider((ref) => NotificationController(
    ref.watch(tasksControllerProvider), ref.watch(settingsProvider)));
