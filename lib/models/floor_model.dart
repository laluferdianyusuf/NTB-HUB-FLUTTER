import '../core/helpers/json_field_helper.dart';

class Floor {
  const Floor({
    required this.id,
    required this.venueId,
    required this.name,
    this.level = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String venueId;
  final String name;
  final int level;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Floor.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['floor', 'data']) ?? json;

    return Floor(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      level: JsonFieldHelper.readInt(source, ['level', 'floorLevel', 'floor_level']) ??
          0,
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
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
        'name': name,
        'level': level,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
