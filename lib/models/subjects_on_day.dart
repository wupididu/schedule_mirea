import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/models/subject_from_table.dart';

part 'subjects_on_day.freezed.dart';

@freezed
class SubjectsOnDay with _$SubjectsOnDay {
  factory SubjectsOnDay({
    SubjectFromTable? firstEven,
    SubjectFromTable? firstNotEven,

    SubjectFromTable? secondEven,
    SubjectFromTable? secondNotEven,

    SubjectFromTable? thirdEven,
    SubjectFromTable? thirdNotEven,

    SubjectFromTable? fourthEven,
    SubjectFromTable? fourthNotven,

    SubjectFromTable? fifthEven,
    SubjectFromTable? fifthNotEven,

    SubjectFromTable? sixthEven,
    SubjectFromTable? sixthNotEven,
  }) = _SubjectsOnDay;
}