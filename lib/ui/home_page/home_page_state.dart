import 'package:freezed_annotation/freezed_annotation.dart';

import '../../db/models/subject.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  factory HomePageState({
    required List<Subject?> subjects,
    required DateTime selectedDate,
    required int currentWeek,
    int? currentPair,
}) = _HomePageState;
}