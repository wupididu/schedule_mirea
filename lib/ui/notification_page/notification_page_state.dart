import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:schedule_mirea/ui/calendar_page/subject_task.dart';

class NotificationPageItemData {
  final SubjectTask subjectTask;
  final NotificationModel notificationModel;

  NotificationPageItemData(this.subjectTask, this.notificationModel);
}