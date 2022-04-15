import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/db/models/state_of_task.dart';

part 'task.freezed.dart';

@freezed
class Task with _$Task {
  factory Task({
    required int id,
    required String name,
    required DateTime deadline,
    required String description,
    required StateOfTask stateOfTask,
  }) = _Task;
}