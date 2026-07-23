import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class VenueStaff {
  const VenueStaff({
    required this.id,
    required this.venueId,
    required this.userId,
    required this.position,
    this.isActive = true,
    this.hiredAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String venueId;
  final String userId;
  final StaffPosition position;
  final bool isActive;
  final DateTime? hiredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VenueStaff.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['venueStaff', 'data']) ?? json;

    return VenueStaff(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      position: StaffPosition.fromJson(
            JsonFieldHelper.readString(source, ['position']),
          ) ??
          StaffPosition.other,
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      hiredAt: JsonFieldHelper.readDateTime(source, [
        'hiredAt',
        'hired_at',
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
        'venueId': venueId,
        'userId': userId,
        'position': position.value,
        'isActive': isActive,
        'hiredAt': hiredAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
