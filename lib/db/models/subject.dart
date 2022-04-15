
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';

part 'subject.freezed.dart';

@freezed
class Subject with _$Subject {
  factory Subject({
    required int id,
    required String name,
    required String room,
    required TypeOfSubject type,
    required String teacher,
  }) = _Subject;
}