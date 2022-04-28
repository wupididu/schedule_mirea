import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule_mirea/models/subjects_on_day.dart';

part 'even_day.freezed.dart';

@freezed
class EvenDay with _$EvenDay{
  factory EvenDay({
    required SubjectsOnDay even,
    required SubjectsOnDay notEven,
  }) = _EvenDay;
}