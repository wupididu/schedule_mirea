// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'home_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$HomePageStateTearOff {
  const _$HomePageStateTearOff();

  _HomePageState call(
      {required List<Subject?> subjects,
      required DateTime selectedDate,
      required int currentWeek,
      int? currentPair}) {
    return _HomePageState(
      subjects: subjects,
      selectedDate: selectedDate,
      currentWeek: currentWeek,
      currentPair: currentPair,
    );
  }
}

/// @nodoc
const $HomePageState = _$HomePageStateTearOff();

/// @nodoc
mixin _$HomePageState {
  List<Subject?> get subjects => throw _privateConstructorUsedError;
  DateTime get selectedDate => throw _privateConstructorUsedError;
  int get currentWeek => throw _privateConstructorUsedError;
  int? get currentPair => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomePageStateCopyWith<HomePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageStateCopyWith<$Res> {
  factory $HomePageStateCopyWith(
          HomePageState value, $Res Function(HomePageState) then) =
      _$HomePageStateCopyWithImpl<$Res>;
  $Res call(
      {List<Subject?> subjects,
      DateTime selectedDate,
      int currentWeek,
      int? currentPair});
}

/// @nodoc
class _$HomePageStateCopyWithImpl<$Res>
    implements $HomePageStateCopyWith<$Res> {
  _$HomePageStateCopyWithImpl(this._value, this._then);

  final HomePageState _value;
  // ignore: unused_field
  final $Res Function(HomePageState) _then;

  @override
  $Res call({
    Object? subjects = freezed,
    Object? selectedDate = freezed,
    Object? currentWeek = freezed,
    Object? currentPair = freezed,
  }) {
    return _then(_value.copyWith(
      subjects: subjects == freezed
          ? _value.subjects
          : subjects // ignore: cast_nullable_to_non_nullable
              as List<Subject?>,
      selectedDate: selectedDate == freezed
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentWeek: currentWeek == freezed
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      currentPair: currentPair == freezed
          ? _value.currentPair
          : currentPair // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$HomePageStateCopyWith<$Res>
    implements $HomePageStateCopyWith<$Res> {
  factory _$HomePageStateCopyWith(
          _HomePageState value, $Res Function(_HomePageState) then) =
      __$HomePageStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<Subject?> subjects,
      DateTime selectedDate,
      int currentWeek,
      int? currentPair});
}

/// @nodoc
class __$HomePageStateCopyWithImpl<$Res>
    extends _$HomePageStateCopyWithImpl<$Res>
    implements _$HomePageStateCopyWith<$Res> {
  __$HomePageStateCopyWithImpl(
      _HomePageState _value, $Res Function(_HomePageState) _then)
      : super(_value, (v) => _then(v as _HomePageState));

  @override
  _HomePageState get _value => super._value as _HomePageState;

  @override
  $Res call({
    Object? subjects = freezed,
    Object? selectedDate = freezed,
    Object? currentWeek = freezed,
    Object? currentPair = freezed,
  }) {
    return _then(_HomePageState(
      subjects: subjects == freezed
          ? _value.subjects
          : subjects // ignore: cast_nullable_to_non_nullable
              as List<Subject?>,
      selectedDate: selectedDate == freezed
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentWeek: currentWeek == freezed
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      currentPair: currentPair == freezed
          ? _value.currentPair
          : currentPair // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$_HomePageState implements _HomePageState {
  _$_HomePageState(
      {required this.subjects,
      required this.selectedDate,
      required this.currentWeek,
      this.currentPair});

  @override
  final List<Subject?> subjects;
  @override
  final DateTime selectedDate;
  @override
  final int currentWeek;
  @override
  final int? currentPair;

  @override
  String toString() {
    return 'HomePageState(subjects: $subjects, selectedDate: $selectedDate, currentWeek: $currentWeek, currentPair: $currentPair)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomePageState &&
            const DeepCollectionEquality().equals(other.subjects, subjects) &&
            const DeepCollectionEquality()
                .equals(other.selectedDate, selectedDate) &&
            const DeepCollectionEquality()
                .equals(other.currentWeek, currentWeek) &&
            const DeepCollectionEquality()
                .equals(other.currentPair, currentPair));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(subjects),
      const DeepCollectionEquality().hash(selectedDate),
      const DeepCollectionEquality().hash(currentWeek),
      const DeepCollectionEquality().hash(currentPair));

  @JsonKey(ignore: true)
  @override
  _$HomePageStateCopyWith<_HomePageState> get copyWith =>
      __$HomePageStateCopyWithImpl<_HomePageState>(this, _$identity);
}

abstract class _HomePageState implements HomePageState {
  factory _HomePageState(
      {required List<Subject?> subjects,
      required DateTime selectedDate,
      required int currentWeek,
      int? currentPair}) = _$_HomePageState;

  @override
  List<Subject?> get subjects;
  @override
  DateTime get selectedDate;
  @override
  int get currentWeek;
  @override
  int? get currentPair;
  @override
  @JsonKey(ignore: true)
  _$HomePageStateCopyWith<_HomePageState> get copyWith =>
      throw _privateConstructorUsedError;
}
