// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'even_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EvenDayTearOff {
  const _$EvenDayTearOff();

  _EvenDay call({required SubjectsOnDay even, required SubjectsOnDay notEven}) {
    return _EvenDay(
      even: even,
      notEven: notEven,
    );
  }
}

/// @nodoc
const $EvenDay = _$EvenDayTearOff();

/// @nodoc
mixin _$EvenDay {
  SubjectsOnDay get even => throw _privateConstructorUsedError;
  SubjectsOnDay get notEven => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EvenDayCopyWith<EvenDay> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EvenDayCopyWith<$Res> {
  factory $EvenDayCopyWith(EvenDay value, $Res Function(EvenDay) then) =
      _$EvenDayCopyWithImpl<$Res>;
  $Res call({SubjectsOnDay even, SubjectsOnDay notEven});

  $SubjectsOnDayCopyWith<$Res> get even;
  $SubjectsOnDayCopyWith<$Res> get notEven;
}

/// @nodoc
class _$EvenDayCopyWithImpl<$Res> implements $EvenDayCopyWith<$Res> {
  _$EvenDayCopyWithImpl(this._value, this._then);

  final EvenDay _value;
  // ignore: unused_field
  final $Res Function(EvenDay) _then;

  @override
  $Res call({
    Object? even = freezed,
    Object? notEven = freezed,
  }) {
    return _then(_value.copyWith(
      even: even == freezed
          ? _value.even
          : even // ignore: cast_nullable_to_non_nullable
              as SubjectsOnDay,
      notEven: notEven == freezed
          ? _value.notEven
          : notEven // ignore: cast_nullable_to_non_nullable
              as SubjectsOnDay,
    ));
  }

  @override
  $SubjectsOnDayCopyWith<$Res> get even {
    return $SubjectsOnDayCopyWith<$Res>(_value.even, (value) {
      return _then(_value.copyWith(even: value));
    });
  }

  @override
  $SubjectsOnDayCopyWith<$Res> get notEven {
    return $SubjectsOnDayCopyWith<$Res>(_value.notEven, (value) {
      return _then(_value.copyWith(notEven: value));
    });
  }
}

/// @nodoc
abstract class _$EvenDayCopyWith<$Res> implements $EvenDayCopyWith<$Res> {
  factory _$EvenDayCopyWith(_EvenDay value, $Res Function(_EvenDay) then) =
      __$EvenDayCopyWithImpl<$Res>;
  @override
  $Res call({SubjectsOnDay even, SubjectsOnDay notEven});

  @override
  $SubjectsOnDayCopyWith<$Res> get even;
  @override
  $SubjectsOnDayCopyWith<$Res> get notEven;
}

/// @nodoc
class __$EvenDayCopyWithImpl<$Res> extends _$EvenDayCopyWithImpl<$Res>
    implements _$EvenDayCopyWith<$Res> {
  __$EvenDayCopyWithImpl(_EvenDay _value, $Res Function(_EvenDay) _then)
      : super(_value, (v) => _then(v as _EvenDay));

  @override
  _EvenDay get _value => super._value as _EvenDay;

  @override
  $Res call({
    Object? even = freezed,
    Object? notEven = freezed,
  }) {
    return _then(_EvenDay(
      even: even == freezed
          ? _value.even
          : even // ignore: cast_nullable_to_non_nullable
              as SubjectsOnDay,
      notEven: notEven == freezed
          ? _value.notEven
          : notEven // ignore: cast_nullable_to_non_nullable
              as SubjectsOnDay,
    ));
  }
}

/// @nodoc

class _$_EvenDay implements _EvenDay {
  _$_EvenDay({required this.even, required this.notEven});

  @override
  final SubjectsOnDay even;
  @override
  final SubjectsOnDay notEven;

  @override
  String toString() {
    return 'EvenDay(even: $even, notEven: $notEven)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EvenDay &&
            const DeepCollectionEquality().equals(other.even, even) &&
            const DeepCollectionEquality().equals(other.notEven, notEven));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(even),
      const DeepCollectionEquality().hash(notEven));

  @JsonKey(ignore: true)
  @override
  _$EvenDayCopyWith<_EvenDay> get copyWith =>
      __$EvenDayCopyWithImpl<_EvenDay>(this, _$identity);
}

abstract class _EvenDay implements EvenDay {
  factory _EvenDay(
      {required SubjectsOnDay even,
      required SubjectsOnDay notEven}) = _$_EvenDay;

  @override
  SubjectsOnDay get even;
  @override
  SubjectsOnDay get notEven;
  @override
  @JsonKey(ignore: true)
  _$EvenDayCopyWith<_EvenDay> get copyWith =>
      throw _privateConstructorUsedError;
}
