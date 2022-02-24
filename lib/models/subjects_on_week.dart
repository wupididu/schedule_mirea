import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/models/even_day.dart';
import 'package:schedule_mirea/models/subjects_on_day.dart';

part 'subjects_on_week.freezed.dart';

@freezed
class SubjectsOnWeek with _$SubjectsOnWeek{
  factory SubjectsOnWeek({
    required EvenDay monday,
    required EvenDay thuesday,
    required EvenDay wednesday,
    required EvenDay thursday,
    required EvenDay friday,
    required EvenDay saturday,
  }) = _SubjectsOnWeek;
}