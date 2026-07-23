import '../core/helpers/json_field_helper.dart';

class Menu {
  const Menu({
    required this.id,
    required this.venueId,
    required this.name,
    required this.price,
    this.description,
    this.image,
    this.category,
    this.isActive = true,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String venueId;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final String? category;
  final bool isActive;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Menu.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['menu', 'data']) ?? json;

    return Menu(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
      ]),
      price: JsonFieldHelper.readDecimal(source, ['price', 'amount']),
      image: JsonFieldHelper.readString(source, [
        'image',
        'imageUrl',
        'image_url',
      ]),
      category: JsonFieldHelper.readString(source, ['category', 'categoryName']),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ], fallback: false),
      sortOrder: JsonFieldHelper.readInt(source, [
        'sortOrder',
        'sort_order',
        'order',
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
        'description': description,
        'price': price,
        'image': image,
        'category': category,
        'isActive': isActive,
        'sortOrder': sortOrder,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
