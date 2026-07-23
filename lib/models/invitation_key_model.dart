import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class InvitationKey {
  const InvitationKey({
    required this.id,
    required this.code,
    this.venueId,
    this.role,
    this.maxUses,
    this.usedCount = 0,
    this.expiresAt,
    this.isActive = true,
    this.createdAt,
  });

  final String id;
  final String? venueId;
  final String code;
  final Role? role;
  final int? maxUses;
  final int usedCount;
  final DateTime? expiresAt;
  final bool isActive;
  final DateTime? createdAt;

  factory InvitationKey.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['invitationKey', 'data']) ?? json;

    return InvitationKey(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']),
      code: JsonFieldHelper.readString(source, ['code', 'key']) ?? '',
      role: Role.fromJson(JsonFieldHelper.readString(source, ['role'])),
      maxUses: JsonFieldHelper.readInt(source, ['maxUses', 'max_uses']),
      usedCount: JsonFieldHelper.readInt(source, [
            'usedCount',
            'used_count',
          ]) ??
          0,
      expiresAt: JsonFieldHelper.readDateTime(source, [
        'expiresAt',
        'expires_at',
      ]),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'code': code,
        'role': role?.value,
        'maxUses': maxUses,
        'usedCount': usedCount,
        'expiresAt': expiresAt?.toIso8601String(),
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
      };
}
