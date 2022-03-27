import 'package:freezed_annotation/freezed_annotation.dart';

part 'masjid_data.freezed.dart';
part 'masjid_data.g.dart';

@freezed
class MasjidData with _$MasjidData {
  const factory MasjidData({
    required String name,
    image,
    required double rating,
    required Map<String, dynamic> position,
  }) = _MasjidData;

  factory MasjidData.fromJson(Map<String, dynamic> json) =>
      _$MasjidDataFromJson(json);
}
