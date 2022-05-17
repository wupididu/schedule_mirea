// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'calendar_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$CalendarPageStateTearOff {
  const _$CalendarPageStateTearOff();

  _CalendarPageSate call(
      {required List<SubjectTask> listOfTasks, DateTime? selectedDate}) {
    return _CalendarPageSate(
      listOfTasks: listOfTasks,
      selectedDate: selectedDate,
    );
  }
}

/// @nodoc
const $CalendarPageState = _$CalendarPageStateTearOff();

/// @nodoc
mixin _$CalendarPageState {
  List<SubjectTask> get listOfTasks => throw _privateConstructorUsedError;
  DateTime? get selectedDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarPageStateCopyWith<CalendarPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarPageStateCopyWith<$Res> {
  factory $CalendarPageStateCopyWith(
          CalendarPageState value, $Res Function(CalendarPageState) then) =
      _$CalendarPageStateCopyWithImpl<$Res>;
  $Res call({List<SubjectTask> listOfTasks, DateTime? selectedDate});
}

/// @nodoc
class _$CalendarPageStateCopyWithImpl<$Res>
    implements $CalendarPageStateCopyWith<$Res> {
  _$CalendarPageStateCopyWithImpl(this._value, this._then);

  final CalendarPageState _value;
  // ignore: unused_field
  final $Res Function(CalendarPageState) _then;

  @override
  $Res call({
    Object? listOfTasks = freezed,
    Object? selectedDate = freezed,
  }) {
    return _then(_value.copyWith(
      listOfTasks: listOfTasks == freezed
          ? _value.listOfTasks
          : listOfTasks // ignore: cast_nullable_to_non_nullable
              as List<SubjectTask>,
      selectedDate: selectedDate == freezed
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
abstract class _$CalendarPageSateCopyWith<$Res>
    implements $CalendarPageStateCopyWith<$Res> {
  factory _$CalendarPageSateCopyWith(
          _CalendarPageSate value, $Res Function(_CalendarPageSate) then) =
      __$CalendarPageSateCopyWithImpl<$Res>;
  @override
  $Res call({List<SubjectTask> listOfTasks, DateTime? selectedDate});
}

/// @nodoc
class __$CalendarPageSateCopyWithImpl<$Res>
    extends _$CalendarPageStateCopyWithImpl<$Res>
    implements _$CalendarPageSateCopyWith<$Res> {
  __$CalendarPageSateCopyWithImpl(
      _CalendarPageSate _value, $Res Function(_CalendarPageSate) _then)
      : super(_value, (v) => _then(v as _CalendarPageSate));

  @override
  _CalendarPageSate get _value => super._value as _CalendarPageSate;

  @override
  $Res call({
    Object? listOfTasks = freezed,
    Object? selectedDate = freezed,
  }) {
    return _then(_CalendarPageSate(
      listOfTasks: listOfTasks == freezed
          ? _value.listOfTasks
          : listOfTasks // ignore: cast_nullable_to_non_nullable
              as List<SubjectTask>,
      selectedDate: selectedDate == freezed
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_CalendarPageSate implements _CalendarPageSate {
  _$_CalendarPageSate({required this.listOfTasks, this.selectedDate});

  @override
  final List<SubjectTask> listOfTasks;
  @override
  final DateTime? selectedDate;

  @override
  String toString() {
    return 'CalendarPageState(listOfTasks: $listOfTasks, selectedDate: $selectedDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CalendarPageSate &&
            const DeepCollectionEquality()
                .equals(other.listOfTasks, listOfTasks) &&
            const DeepCollectionEquality()
                .equals(other.selectedDate, selectedDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(listOfTasks),
      const DeepCollectionEquality().hash(selectedDate));

  @JsonKey(ignore: true)
  @override
  _$CalendarPageSateCopyWith<_CalendarPageSate> get copyWith =>
      __$CalendarPageSateCopyWithImpl<_CalendarPageSate>(this, _$identity);
}

abstract class _CalendarPageSate implements CalendarPageState {
  factory _CalendarPageSate(
      {required List<SubjectTask> listOfTasks,
      DateTime? selectedDate}) = _$_CalendarPageSate;

  @override
  List<SubjectTask> get listOfTasks;
  @override
  DateTime? get selectedDate;
  @override
  @JsonKey(ignore: true)
  _$CalendarPageSateCopyWith<_CalendarPageSate> get copyWith =>
      throw _privateConstructorUsedError;
}
