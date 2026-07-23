import '../core/helpers/json_field_helper.dart';

class Device {
  const Device({
    required this.id,
    required this.token,
    this.userId,
    this.venueId,
    this.platform,
    this.deviceName,
    this.isActive = true,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String token;
  final String? userId;
  final String? venueId;
  final String? platform;
  final String? deviceName;
  final bool isActive;
  final DateTime? lastActiveAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Device.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['device', 'data']) ?? json;

    return Device(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      token: JsonFieldHelper.readString(source, [
            'token',
            'deviceToken',
            'device_token',
            'fcmToken',
            'fcm_token',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']),
      platform: JsonFieldHelper.readString(source, [
        'platform',
        'os',
        'devicePlatform',
        'device_platform',
      ]),
      deviceName: JsonFieldHelper.readString(source, [
        'deviceName',
        'device_name',
        'name',
      ]),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      lastActiveAt: JsonFieldHelper.readDateTime(source, [
        'lastActiveAt',
        'last_active_at',
      ]),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'token': token,
        'userId': userId,
        'venueId': venueId,
        'platform': platform,
        'deviceName': deviceName,
        'isActive': isActive,
        'lastActiveAt': lastActiveAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
