// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'masjid_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MasjidData _$MasjidDataFromJson(Map<String, dynamic> json) {
  return _MasjidData.fromJson(json);
}

/// @nodoc
class _$MasjidDataTearOff {
  const _$MasjidDataTearOff();

  _MasjidData call(
      {required String name,
      dynamic image,
      required double rating,
      required Map<String, dynamic> position}) {
    return _MasjidData(
      name: name,
      image: image,
      rating: rating,
      position: position,
    );
  }

  MasjidData fromJson(Map<String, Object?> json) {
    return MasjidData.fromJson(json);
  }
}

/// @nodoc
const $MasjidData = _$MasjidDataTearOff();

/// @nodoc
mixin _$MasjidData {
  String get name => throw _privateConstructorUsedError;
  dynamic get image => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  Map<String, dynamic> get position => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MasjidDataCopyWith<MasjidData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MasjidDataCopyWith<$Res> {
  factory $MasjidDataCopyWith(
          MasjidData value, $Res Function(MasjidData) then) =
      _$MasjidDataCopyWithImpl<$Res>;
  $Res call(
      {String name,
      dynamic image,
      double rating,
      Map<String, dynamic> position});
}

/// @nodoc
class _$MasjidDataCopyWithImpl<$Res> implements $MasjidDataCopyWith<$Res> {
  _$MasjidDataCopyWithImpl(this._value, this._then);

  final MasjidData _value;
  // ignore: unused_field
  final $Res Function(MasjidData) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? image = freezed,
    Object? rating = freezed,
    Object? position = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
abstract class _$MasjidDataCopyWith<$Res> implements $MasjidDataCopyWith<$Res> {
  factory _$MasjidDataCopyWith(
          _MasjidData value, $Res Function(_MasjidData) then) =
      __$MasjidDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      dynamic image,
      double rating,
      Map<String, dynamic> position});
}

/// @nodoc
class __$MasjidDataCopyWithImpl<$Res> extends _$MasjidDataCopyWithImpl<$Res>
    implements _$MasjidDataCopyWith<$Res> {
  __$MasjidDataCopyWithImpl(
      _MasjidData _value, $Res Function(_MasjidData) _then)
      : super(_value, (v) => _then(v as _MasjidData));

  @override
  _MasjidData get _value => super._value as _MasjidData;

  @override
  $Res call({
    Object? name = freezed,
    Object? image = freezed,
    Object? rating = freezed,
    Object? position = freezed,
  }) {
    return _then(_MasjidData(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed ? _value.image : image,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      position: position == freezed
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MasjidData implements _MasjidData {
  const _$_MasjidData(
      {required this.name,
      this.image,
      required this.rating,
      required this.position});

  factory _$_MasjidData.fromJson(Map<String, dynamic> json) =>
      _$$_MasjidDataFromJson(json);

  @override
  final String name;
  @override
  final dynamic image;
  @override
  final double rating;
  @override
  final Map<String, dynamic> position;

  @override
  String toString() {
    return 'MasjidData(name: $name, image: $image, rating: $rating, position: $position)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MasjidData &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other.rating, rating) &&
            const DeepCollectionEquality().equals(other.position, position));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(rating),
      const DeepCollectionEquality().hash(position));

  @JsonKey(ignore: true)
  @override
  _$MasjidDataCopyWith<_MasjidData> get copyWith =>
      __$MasjidDataCopyWithImpl<_MasjidData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MasjidDataToJson(this);
  }
}

abstract class _MasjidData implements MasjidData {
  const factory _MasjidData(
      {required String name,
      dynamic image,
      required double rating,
      required Map<String, dynamic> position}) = _$_MasjidData;

  factory _MasjidData.fromJson(Map<String, dynamic> json) =
      _$_MasjidData.fromJson;

  @override
  String get name;
  @override
  dynamic get image;
  @override
  double get rating;
  @override
  Map<String, dynamic> get position;
  @override
  @JsonKey(ignore: true)
  _$MasjidDataCopyWith<_MasjidData> get copyWith =>
      throw _privateConstructorUsedError;
}
