// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'subject_from_table.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SubjectFromTableTearOff {
  const _$SubjectFromTableTearOff();

  _SubjectFromTable call(
      {required String name,
      required String room,
      required String teacher,
      required TypeOfSubject typeOfSubject}) {
    return _SubjectFromTable(
      name: name,
      room: room,
      teacher: teacher,
      typeOfSubject: typeOfSubject,
    );
  }
}

/// @nodoc
const $SubjectFromTable = _$SubjectFromTableTearOff();

/// @nodoc
mixin _$SubjectFromTable {
  String get name => throw _privateConstructorUsedError;
  String get room => throw _privateConstructorUsedError;
  String get teacher => throw _privateConstructorUsedError;
  TypeOfSubject get typeOfSubject => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubjectFromTableCopyWith<SubjectFromTable> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubjectFromTableCopyWith<$Res> {
  factory $SubjectFromTableCopyWith(
          SubjectFromTable value, $Res Function(SubjectFromTable) then) =
      _$SubjectFromTableCopyWithImpl<$Res>;
  $Res call(
      {String name, String room, String teacher, TypeOfSubject typeOfSubject});
}

/// @nodoc
class _$SubjectFromTableCopyWithImpl<$Res>
    implements $SubjectFromTableCopyWith<$Res> {
  _$SubjectFromTableCopyWithImpl(this._value, this._then);

  final SubjectFromTable _value;
  // ignore: unused_field
  final $Res Function(SubjectFromTable) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? room = freezed,
    Object? teacher = freezed,
    Object? typeOfSubject = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      room: room == freezed
          ? _value.room
          : room // ignore: cast_nullable_to_non_nullable
              as String,
      teacher: teacher == freezed
          ? _value.teacher
          : teacher // ignore: cast_nullable_to_non_nullable
              as String,
      typeOfSubject: typeOfSubject == freezed
          ? _value.typeOfSubject
          : typeOfSubject // ignore: cast_nullable_to_non_nullable
              as TypeOfSubject,
    ));
  }
}

/// @nodoc
abstract class _$SubjectFromTableCopyWith<$Res>
    implements $SubjectFromTableCopyWith<$Res> {
  factory _$SubjectFromTableCopyWith(
          _SubjectFromTable value, $Res Function(_SubjectFromTable) then) =
      __$SubjectFromTableCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name, String room, String teacher, TypeOfSubject typeOfSubject});
}

/// @nodoc
class __$SubjectFromTableCopyWithImpl<$Res>
    extends _$SubjectFromTableCopyWithImpl<$Res>
    implements _$SubjectFromTableCopyWith<$Res> {
  __$SubjectFromTableCopyWithImpl(
      _SubjectFromTable _value, $Res Function(_SubjectFromTable) _then)
      : super(_value, (v) => _then(v as _SubjectFromTable));

  @override
  _SubjectFromTable get _value => super._value as _SubjectFromTable;

  @override
  $Res call({
    Object? name = freezed,
    Object? room = freezed,
    Object? teacher = freezed,
    Object? typeOfSubject = freezed,
  }) {
    return _then(_SubjectFromTable(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      room: room == freezed
          ? _value.room
          : room // ignore: cast_nullable_to_non_nullable
              as String,
      teacher: teacher == freezed
          ? _value.teacher
          : teacher // ignore: cast_nullable_to_non_nullable
              as String,
      typeOfSubject: typeOfSubject == freezed
          ? _value.typeOfSubject
          : typeOfSubject // ignore: cast_nullable_to_non_nullable
              as TypeOfSubject,
    ));
  }
}

/// @nodoc

class _$_SubjectFromTable implements _SubjectFromTable {
  _$_SubjectFromTable(
      {required this.name,
      required this.room,
      required this.teacher,
      required this.typeOfSubject});

  @override
  final String name;
  @override
  final String room;
  @override
  final String teacher;
  @override
  final TypeOfSubject typeOfSubject;

  @override
  String toString() {
    return 'SubjectFromTable(name: $name, room: $room, teacher: $teacher, typeOfSubject: $typeOfSubject)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubjectFromTable &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.room, room) &&
            const DeepCollectionEquality().equals(other.teacher, teacher) &&
            const DeepCollectionEquality()
                .equals(other.typeOfSubject, typeOfSubject));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(room),
      const DeepCollectionEquality().hash(teacher),
      const DeepCollectionEquality().hash(typeOfSubject));

  @JsonKey(ignore: true)
  @override
  _$SubjectFromTableCopyWith<_SubjectFromTable> get copyWith =>
      __$SubjectFromTableCopyWithImpl<_SubjectFromTable>(this, _$identity);
}

abstract class _SubjectFromTable implements SubjectFromTable {
  factory _SubjectFromTable(
      {required String name,
      required String room,
      required String teacher,
      required TypeOfSubject typeOfSubject}) = _$_SubjectFromTable;

  @override
  String get name;
  @override
  String get room;
  @override
  String get teacher;
  @override
  TypeOfSubject get typeOfSubject;
  @override
  @JsonKey(ignore: true)
  _$SubjectFromTableCopyWith<_SubjectFromTable> get copyWith =>
      throw _privateConstructorUsedError;
}
