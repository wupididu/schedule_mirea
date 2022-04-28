// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SettingsStateTearOff {
  const _$SettingsStateTearOff();

  _SettingsState call(
      {String? groupCode,
      required int dayNotification,
      required TimeOfDay timeNotification}) {
    return _SettingsState(
      groupCode: groupCode,
      dayNotification: dayNotification,
      timeNotification: timeNotification,
    );
  }
}

/// @nodoc
const $SettingsState = _$SettingsStateTearOff();

/// @nodoc
mixin _$SettingsState {
  String? get groupCode => throw _privateConstructorUsedError;
  int get dayNotification => throw _privateConstructorUsedError;
  TimeOfDay get timeNotification => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) then) =
      _$SettingsStateCopyWithImpl<$Res>;
  $Res call(
      {String? groupCode, int dayNotification, TimeOfDay timeNotification});
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  final SettingsState _value;
  // ignore: unused_field
  final $Res Function(SettingsState) _then;

  @override
  $Res call({
    Object? groupCode = freezed,
    Object? dayNotification = freezed,
    Object? timeNotification = freezed,
  }) {
    return _then(_value.copyWith(
      groupCode: groupCode == freezed
          ? _value.groupCode
          : groupCode // ignore: cast_nullable_to_non_nullable
              as String?,
      dayNotification: dayNotification == freezed
          ? _value.dayNotification
          : dayNotification // ignore: cast_nullable_to_non_nullable
              as int,
      timeNotification: timeNotification == freezed
          ? _value.timeNotification
          : timeNotification // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

/// @nodoc
abstract class _$SettingsStateCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(
          _SettingsState value, $Res Function(_SettingsState) then) =
      __$SettingsStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? groupCode, int dayNotification, TimeOfDay timeNotification});
}

/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(
      _SettingsState _value, $Res Function(_SettingsState) _then)
      : super(_value, (v) => _then(v as _SettingsState));

  @override
  _SettingsState get _value => super._value as _SettingsState;

  @override
  $Res call({
    Object? groupCode = freezed,
    Object? dayNotification = freezed,
    Object? timeNotification = freezed,
  }) {
    return _then(_SettingsState(
      groupCode: groupCode == freezed
          ? _value.groupCode
          : groupCode // ignore: cast_nullable_to_non_nullable
              as String?,
      dayNotification: dayNotification == freezed
          ? _value.dayNotification
          : dayNotification // ignore: cast_nullable_to_non_nullable
              as int,
      timeNotification: timeNotification == freezed
          ? _value.timeNotification
          : timeNotification // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

/// @nodoc

class _$_SettingsState implements _SettingsState {
  _$_SettingsState(
      {this.groupCode,
      required this.dayNotification,
      required this.timeNotification});

  @override
  final String? groupCode;
  @override
  final int dayNotification;
  @override
  final TimeOfDay timeNotification;

  @override
  String toString() {
    return 'SettingsState(groupCode: $groupCode, dayNotification: $dayNotification, timeNotification: $timeNotification)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SettingsState &&
            const DeepCollectionEquality().equals(other.groupCode, groupCode) &&
            const DeepCollectionEquality()
                .equals(other.dayNotification, dayNotification) &&
            const DeepCollectionEquality()
                .equals(other.timeNotification, timeNotification));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(groupCode),
      const DeepCollectionEquality().hash(dayNotification),
      const DeepCollectionEquality().hash(timeNotification));

  @JsonKey(ignore: true)
  @override
  _$SettingsStateCopyWith<_SettingsState> get copyWith =>
      __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  factory _SettingsState(
      {String? groupCode,
      required int dayNotification,
      required TimeOfDay timeNotification}) = _$_SettingsState;

  @override
  String? get groupCode;
  @override
  int get dayNotification;
  @override
  TimeOfDay get timeNotification;
  @override
  @JsonKey(ignore: true)
  _$SettingsStateCopyWith<_SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}
