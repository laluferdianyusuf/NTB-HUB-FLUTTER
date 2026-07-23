import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class VenueUnit {
  const VenueUnit({
    required this.id,
    required this.venueId,
    required this.serviceId,
    required this.name,
    required this.type,
    required this.price,
    this.floorId,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String venueId;
  final String serviceId;
  final String? floorId;
  final String name;
  final UnitType type;
  final double price;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VenueUnit.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['venueUnit', 'unit', 'data']) ?? json;

    return VenueUnit(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      serviceId: JsonFieldHelper.readString(source, [
            'serviceId',
            'service_id',
          ]) ??
          '',
      floorId: JsonFieldHelper.readString(source, ['floorId', 'floor_id']),
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      type: UnitType.fromJson(JsonFieldHelper.readString(source, ['type'])) ??
          UnitType.room,
      price: JsonFieldHelper.readDecimal(source, ['price', 'amount']),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ], fallback: false),
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
        'serviceId': serviceId,
        'floorId': floorId,
        'name': name,
        'type': type.value,
        'price': price,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
