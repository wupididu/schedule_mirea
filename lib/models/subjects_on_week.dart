import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/models/subjects_on_day.dart';

part 'subjects_on_week.freezed.dart';

@freezed
class SubjectsOnWeek with _$SubjectsOnWeek{
  factory SubjectsOnWeek({
    required SubjectsOnDay monday,
    required SubjectsOnDay thuesday,
    required SubjectsOnDay wednesday,
    required SubjectsOnDay thursday,
    required SubjectsOnDay friday,
    required SubjectsOnDay saturday,
  }) = _SubjectsOnWeek;
}