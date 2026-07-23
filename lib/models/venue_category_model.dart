import '../core/helpers/json_field_helper.dart';

class VenueSubCategoryModel {
  const VenueSubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.code,
    this.description,
    this.defaultConfig = const {},
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String categoryId;
  final String name;
  final String code;
  final String? description;
  final Map<String, dynamic> defaultConfig;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VenueSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return VenueSubCategoryModel(
      id: JsonFieldHelper.readString(json, ['id', '_id']) ?? '',
      categoryId: JsonFieldHelper.readString(json, [
            'categoryId',
            'category_id',
          ]) ??
          '',
      name: JsonFieldHelper.readString(json, ['name', 'title']) ?? '',
      code: JsonFieldHelper.readString(json, ['code']) ?? '',
      description: JsonFieldHelper.readString(json, [
        'description',
        'desc',
      ]),
      defaultConfig: JsonFieldHelper.readJson(json, [
        'defaultConfig',
        'default_config',
      ]),
      isActive: JsonFieldHelper.readBool(json, [
        'isActive',
        'is_active',
        'active',
      ]),
      createdAt: JsonFieldHelper.readDateTime(json, [
        'createdAt',
        'created_at',
      ]),
      updatedAt: JsonFieldHelper.readDateTime(json, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'code': code,
        'description': description,
        'default_config': defaultConfig,
        'is_active': isActive,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}

class VenueCategoryModel {
  const VenueCategoryModel({
    required this.id,
    required this.name,
    required this.code,
    this.icon,
    this.isActive = true,
    this.subCategories = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String code;
  final String? icon;
  final bool isActive;
  final List<VenueSubCategoryModel> subCategories;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory VenueCategoryModel.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['category', 'data']) ?? json;
    final subCategoriesRaw = source['subCategories'] ?? source['sub_categories'];

    return VenueCategoryModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      code: JsonFieldHelper.readString(source, ['code']) ?? '',
      icon: JsonFieldHelper.readString(source, ['icon']),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      subCategories: subCategoriesRaw is List
          ? subCategoriesRaw
              .whereType<Map<String, dynamic>>()
              .map(VenueSubCategoryModel.fromJson)
              .toList()
          : const [],
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
        'name': name,
        'code': code,
        'icon': icon,
        'is_active': isActive,
        'sub_categories':
            subCategories.map((item) => item.toJson()).toList(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
