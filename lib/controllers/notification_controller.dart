import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/models/task.dart';
import 'tasks_controller.dart';
import '../utils/settings.dart';

/// Данный контроллер предоставляет возможность взаимодействовать с оповещениями
///
/// Перед началом использования надо проинициализировать [init]
///
///
class NotificationController {
  final TasksController _tasksController;
  final Settings _settings;
  NotificationController(this._tasksController, this._settings);
  List<StreamSubscription> _subscription = [];

  Future<void> init() async {
    await AwesomeNotifications().initialize(
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

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    _subscription
      ..add(_settings.stream.listen((event) {
        updateNotifications();
      }))
      ..add(_tasksController.allTaskStream.listen((event) {
        updateNotifications();
      }));
  }

  Future<void> dispose() async {
    for (var element in _subscription) {
      element.cancel();
    }
    _subscription = [];
  }

  /// Добавляет задачу в список для оповещения
  ///
  /// Количество дней, за которое надо оповестить о дедлайне, берется из настроек, как и время оповещения.
  Future<void> addNotificationForTask(Task task) async {
    final notificationDays = await _settings.getDays();
    final timeNotifications = await _settings.getTimeNotification();

    late final DateTime time;
    late final String title;
    late final String body;
    late final int deadlineDays;
    final subject = await _tasksController.getSubjectByTask(task.id);
    final differenceDays = task.deadline.difference(DateTime.now()).inDays;
    if (differenceDays >= notificationDays) {
      time = task.deadline.subtract(Duration(days: notificationDays));
      deadlineDays = notificationDays;
    } else {
      time = task.deadline.add(const Duration(days: -1));
      deadlineDays = 1;
    }

    title = "Приближается дедлайн по задаче ${task.name}";
    body = "До дедлайна дней: $deadlineDays."
        "Задача: ${task.name}. "
        "Предмет: ${subject.name}. ";

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
    await AwesomeNotifications().cancelAll();

    final code = groupCode ?? await _settings.getGroup();
    if (code == null) {
      return;
    }

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
