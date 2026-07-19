class VenueSubCategoryModel {
  const VenueSubCategoryModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.code,
    this.description,
    required this.isActive,
  });

  final String id;
  final String categoryId;
  final String name;
  final String code;
  final String? description;
  final bool isActive;

  factory VenueSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return VenueSubCategoryModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class VenueCategoryModel {
  const VenueCategoryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.icon,
    required this.isActive,
    this.subCategories = const [],
  });

  final String id;
  final String name;
  final String code;
  final String icon;
  final bool isActive;
  final List<VenueSubCategoryModel> subCategories;

  factory VenueCategoryModel.fromJson(Map<String, dynamic> json) {
    final subCategoriesRaw = json['subCategories'] as List<dynamic>?;

    return VenueCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      icon: json['icon'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      subCategories: subCategoriesRaw
              ?.map(
                (item) => VenueSubCategoryModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );
  }
}
