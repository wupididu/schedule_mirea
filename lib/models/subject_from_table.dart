import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_from_table.freezed.dart';

@freezed
class SubjectFromTable with _$SubjectFromTable {
  factory SubjectFromTable({
    required String name, 
    required String room,
    required String teacher,
    required TypeOfSubject typeOfSubject,
  }) = _SubjectFromTable;
}

enum TypeOfSubject {
  prac,
  lab,
}