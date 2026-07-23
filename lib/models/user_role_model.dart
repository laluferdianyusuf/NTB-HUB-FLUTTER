import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class UserRole {
  const UserRole({
    required this.id,
    required this.userId,
    required this.role,
    this.venueId,
    this.eventId,
    this.communityId,
    this.courierId,
    this.isActive = true,
    this.assignedAt,
  });

  final String id;
  final String userId;
  final Role role;
  final String? venueId;
  final String? eventId;
  final String? communityId;
  final String? courierId;
  final bool isActive;
  final DateTime? assignedAt;

  factory UserRole.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['userRole', 'data']) ?? json;

    return UserRole(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      role: Role.fromJson(JsonFieldHelper.readString(source, ['role'])) ??
          Role.customer,
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']),
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']),
      communityId:
          JsonFieldHelper.readString(source, ['communityId', 'community_id']),
      courierId:
          JsonFieldHelper.readString(source, ['courierId', 'courier_id']),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      assignedAt: JsonFieldHelper.readDateTime(source, [
        'assignedAt',
        'assigned_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'role': role.value,
        'venueId': venueId,
        'eventId': eventId,
        'communityId': communityId,
        'courierId': courierId,
        'isActive': isActive,
        'assignedAt': assignedAt?.toIso8601String(),
      };
}
