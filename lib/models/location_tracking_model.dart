import '../core/helpers/json_field_helper.dart';

class LocationTracking {
  const LocationTracking({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.speed,
    this.heading,
    this.recordedAt,
  });

  final String id;
  final String userId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final DateTime? recordedAt;

  factory LocationTracking.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['locationTracking', 'data']) ?? json;

    return LocationTracking(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      latitude: JsonFieldHelper.readDouble(source, ['latitude', 'lat']) ?? 0,
      longitude: JsonFieldHelper.readDouble(source, [
            'longitude',
            'lng',
            'long',
          ]) ??
          0,
      accuracy: JsonFieldHelper.readDouble(source, ['accuracy']),
      speed: JsonFieldHelper.readDouble(source, ['speed']),
      heading: JsonFieldHelper.readDouble(source, ['heading', 'bearing']),
      recordedAt: JsonFieldHelper.readDateTime(source, [
        'recordedAt',
        'recorded_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'speed': speed,
        'heading': heading,
        'recordedAt': recordedAt?.toIso8601String(),
      };
}
