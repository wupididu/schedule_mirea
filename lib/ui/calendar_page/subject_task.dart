import 'package:schedule_mirea/db/models/subject.dart';

import '../../db/models/task.dart';

class SubjectTask {
  final Subject subject;
  final Task task;

  SubjectTask({
    required this.subject,
    required this.task,
  });
}
