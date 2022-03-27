// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masjid_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MasjidData _$$_MasjidDataFromJson(Map<String, dynamic> json) =>
    _$_MasjidData(
      name: json['name'] as String,
      image: json['image'],
      rating: (json['rating'] as num).toDouble(),
      position: json['position'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$_MasjidDataToJson(_$_MasjidData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'rating': instance.rating,
      'position': instance.position,
    };
