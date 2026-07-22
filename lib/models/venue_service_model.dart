import '../core/helpers/json_field_helper.dart';

class VenueServiceUnitModel {
  const VenueServiceUnitModel({
    required this.id,
    required this.name,
    this.code,
    this.price,
    this.capacity,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? code;
  final double? price;
  final int? capacity;
  final bool isActive;

  factory VenueServiceUnitModel.fromJson(Map<String, dynamic> json) {
    return VenueServiceUnitModel(
      id: JsonFieldHelper.readString(json, ['id', '_id']) ?? '',
      name: JsonFieldHelper.readString(json, [
            'name',
            'title',
            'unitName',
            'unit_name',
            'label',
          ]) ??
          'Unit',
      code: JsonFieldHelper.readString(json, ['code', 'unitCode', 'unit_code']),
      price: JsonFieldHelper.readDouble(json, [
        'price',
        'amount',
        'unitPrice',
        'unit_price',
      ]),
      capacity: JsonFieldHelper.readInt(json, [
        'capacity',
        'maxCapacity',
        'max_capacity',
        'qty',
        'quantity',
      ]),
      isActive: JsonFieldHelper.readBool(json, [
        'isActive',
        'is_active',
        'active',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'price': price,
        'capacity': capacity,
        'is_active': isActive,
      };
}

class VenueServiceModel {
  const VenueServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.priceLabel,
    this.price,
    this.category,
    this.duration,
    this.isActive = true,
    this.imageUrl,
    this.venueId,
    this.bookingType,
    this.unitType,
    this.createdAt,
    this.subCategory,
    this.units = const [],
  });

  final String id;
  final String name;
  final String description;
  final String priceLabel;
  final double? price;
  final String? category;
  final String? duration;
  final bool isActive;
  final String? imageUrl;
  final String? venueId;
  final String? bookingType;
  final String? unitType;
  final DateTime? createdAt;
  final VenueServiceSubCategoryModel? subCategory;
  final List<VenueServiceUnitModel> units;

  String get displayName {
    if (name.trim().isNotEmpty) return name.trim();
    return subCategory?.name ?? 'Layanan';
  }

  String get displayCategory {
    if (subCategory != null) {
      final code = subCategory!.code.trim();
      if (code.isNotEmpty) return '${subCategory!.name} · $code';
      return subCategory!.name;
    }
    return category?.trim() ?? '';
  }

  String get displayPrice {
    if (priceLabel.isNotEmpty) return priceLabel;
    if (price != null) {
      final value = price!.round();
      return 'Rp ${value.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (match) => '${match[1]}.',
          )}';
    }
    if (units.isNotEmpty) {
      final unitPrices = units
          .where((unit) => unit.price != null)
          .map((unit) => unit.price!)
          .toList();
      if (unitPrices.isNotEmpty) {
        final minPrice = unitPrices.reduce((a, b) => a < b ? a : b);
        return 'Mulai Rp ${minPrice.round()}';
      }
    }
    return 'Hubungi venue';
  }

  factory VenueServiceModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'service',
          'venueService',
          'venue_service',
          'data',
        ]) ??
        json;

    final subCategoryMap = JsonFieldHelper.readMap(source, [
      'subCategory',
      'sub_category',
    ]);

    final unitsRaw = source['units'];
    final units = unitsRaw is List
        ? unitsRaw
            .whereType<Map<String, dynamic>>()
            .map(VenueServiceUnitModel.fromJson)
            .where((unit) => unit.id.isNotEmpty)
            .toList()
        : const <VenueServiceUnitModel>[];

    final price = JsonFieldHelper.readDouble(source, [
      'price',
      'amount',
      'servicePrice',
      'service_price',
      'cost',
    ]);

    final priceLabel = JsonFieldHelper.readString(source, [
          'priceLabel',
          'price_label',
          'priceRange',
          'price_range',
          'formattedPrice',
          'formatted_price',
        ]) ??
        '';

    final subCategory = subCategoryMap != null
        ? VenueServiceSubCategoryModel.fromJson(subCategoryMap)
        : null;

    return VenueServiceModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      name: JsonFieldHelper.readString(source, [
            'name',
            'title',
            'serviceName',
            'service_name',
          ]) ??
          subCategory?.name ??
          'Layanan',
      description: JsonFieldHelper.readString(source, [
            'description',
            'desc',
            'details',
            'overview',
          ]) ??
          subCategory?.description ??
          '',
      priceLabel: priceLabel,
      price: price,
      category: JsonFieldHelper.readString(source, [
        'category',
        'categoryName',
        'category_name',
        'type',
        'serviceType',
      ]),
      duration: JsonFieldHelper.readString(source, [
        'duration',
        'durationLabel',
        'duration_label',
        'time',
      ]),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
        'status',
      ]),
      imageUrl: JsonFieldHelper.readString(source, [
        'imageUrl',
        'image_url',
        'thumbnail',
        'image',
        'photo',
      ]),
      venueId: JsonFieldHelper.readString(source, [
        'venueId',
        'venue_id',
      ]),
      bookingType: JsonFieldHelper.readString(source, [
        'bookingType',
        'booking_type',
      ]),
      unitType: JsonFieldHelper.readString(source, [
        'unitType',
        'unit_type',
      ]),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
        'updatedAt',
        'updated_at',
      ]),
      subCategory: subCategory,
      units: units,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price_label': priceLabel,
        'price': price,
        'category': category,
        'duration': duration,
        'is_active': isActive,
        'image_url': imageUrl,
        'venue_id': venueId,
        'booking_type': bookingType,
        'unit_type': unitType,
        'created_at': createdAt?.toIso8601String(),
        'sub_category': subCategory?.toJson(),
        'units': units.map((unit) => unit.toJson()).toList(),
      };

  VenueServiceModel mergeWith(VenueServiceModel? other) {
    if (other == null) return this;

    return VenueServiceModel(
      id: id.isNotEmpty ? id : other.id,
      name: name.isNotEmpty ? name : other.name,
      description: description.isNotEmpty ? description : other.description,
      priceLabel: priceLabel.isNotEmpty ? priceLabel : other.priceLabel,
      price: price ?? other.price,
      category: category ?? other.category,
      duration: duration ?? other.duration,
      isActive: isActive,
      imageUrl: imageUrl ?? other.imageUrl,
      venueId: venueId ?? other.venueId,
      bookingType: bookingType ?? other.bookingType,
      unitType: unitType ?? other.unitType,
      createdAt: createdAt ?? other.createdAt,
      subCategory: subCategory ?? other.subCategory,
      units: units.isNotEmpty ? units : other.units,
    );
  }
}

class VenueServiceSubCategoryModel {
  const VenueServiceSubCategoryModel({
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

  factory VenueServiceSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return VenueServiceSubCategoryModel(
      id: JsonFieldHelper.readString(json, ['id', '_id']) ?? '',
      categoryId: JsonFieldHelper.readString(json, [
            'categoryId',
            'category_id',
          ]) ??
          '',
      name: JsonFieldHelper.readString(json, ['name', 'title']) ?? 'Sub Kategori',
      code: JsonFieldHelper.readString(json, ['code']) ?? '',
      description: JsonFieldHelper.readString(json, [
        'description',
        'desc',
      ]),
      isActive: JsonFieldHelper.readBool(json, [
        'isActive',
        'is_active',
        'active',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'code': code,
        'description': description,
        'is_active': isActive,
      };
}

class VenueServiceQuery {
  const VenueServiceQuery({
    this.search,
    this.isActive,
    this.bookingType,
    this.unitType,
    this.skip,
    this.take,
  });

  final String? search;
  final bool? isActive;
  final String? bookingType;
  final String? unitType;
  final int? skip;
  final int? take;

  Map<String, dynamic> toQueryParameters() {
    return {
      if (search != null && search!.trim().isNotEmpty) 'search': search,
      if (isActive != null) 'isActive': isActive,
      if (bookingType != null && bookingType!.trim().isNotEmpty)
        'bookingType': bookingType,
      if (unitType != null && unitType!.trim().isNotEmpty) 'unitType': unitType,
      if (skip != null) 'skip': skip,
      if (take != null) 'take': take,
    };
  }
}
