import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';

part 'subjects_on_day.freezed.dart';

@freezed
class SubjectsOnDay with _$SubjectsOnDay {
  factory SubjectsOnDay({
    SubjectFromTable? first,
    SubjectFromTable? second,
    SubjectFromTable? third,
    SubjectFromTable? fourth,
    SubjectFromTable? fifth,
    SubjectFromTable? sixth,
  }) = _SubjectsOnDay;
}