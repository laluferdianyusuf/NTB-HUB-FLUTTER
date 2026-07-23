import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class PromotionBanner {
  const PromotionBanner({
    required this.id,
    required this.imageUrl,
    required this.type,
    required this.entityType,
    this.title,
    this.subtitle,
    this.linkUrl,
    this.entityId,
    this.sortOrder,
    this.isActive = true,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? title;
  final String? subtitle;
  final String imageUrl;
  final String? linkUrl;
  final PromotionBannerType type;
  final PromotionEntityType entityType;
  final String? entityId;
  final int? sortOrder;
  final bool isActive;
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PromotionBanner.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['promotionBanner', 'banner', 'data']) ??
            json;

    return PromotionBanner(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      title: JsonFieldHelper.readString(source, ['title', 'name']),
      subtitle: JsonFieldHelper.readString(source, ['subtitle', 'desc']),
      imageUrl: JsonFieldHelper.readString(source, [
            'imageUrl',
            'image_url',
            'image',
          ]) ??
          '',
      linkUrl: JsonFieldHelper.readString(source, [
        'linkUrl',
        'link_url',
        'url',
      ]),
      type: PromotionBannerType.fromJson(
            JsonFieldHelper.readString(source, ['type']),
          ) ??
          PromotionBannerType.internal,
      entityType: PromotionEntityType.fromJson(
            JsonFieldHelper.readString(source, [
              'entityType',
              'entity_type',
            ]),
          ) ??
          PromotionEntityType.none,
      entityId: JsonFieldHelper.readString(source, [
        'entityId',
        'entity_id',
      ]),
      sortOrder: JsonFieldHelper.readInt(source, [
        'sortOrder',
        'sort_order',
        'order',
      ]),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ], fallback: false),
      startAt: JsonFieldHelper.readDateTime(source, [
        'startAt',
        'start_at',
      ]),
      endAt: JsonFieldHelper.readDateTime(source, [
        'endAt',
        'end_at',
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
        'title': title,
        'subtitle': subtitle,
        'imageUrl': imageUrl,
        'linkUrl': linkUrl,
        'type': type.value,
        'entityType': entityType.value,
        'entityId': entityId,
        'sortOrder': sortOrder,
        'isActive': isActive,
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class PromotionImpression {
  const PromotionImpression({
    required this.id,
    required this.bannerId,
    this.userId,
    this.viewedAt,
  });

  final String id;
  final String bannerId;
  final String? userId;
  final DateTime? viewedAt;

  factory PromotionImpression.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'promotionImpression',
          'data',
        ]) ??
        json;

    return PromotionImpression(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      bannerId: JsonFieldHelper.readString(source, [
            'bannerId',
            'banner_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      viewedAt: JsonFieldHelper.readDateTime(source, [
        'viewedAt',
        'viewed_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bannerId': bannerId,
        'userId': userId,
        'viewedAt': viewedAt?.toIso8601String(),
      };
}

class PromotionClick {
  const PromotionClick({
    required this.id,
    required this.bannerId,
    this.userId,
    this.clickedAt,
  });

  final String id;
  final String bannerId;
  final String? userId;
  final DateTime? clickedAt;

  factory PromotionClick.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['promotionClick', 'data']) ?? json;

    return PromotionClick(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      bannerId: JsonFieldHelper.readString(source, [
            'bannerId',
            'banner_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      clickedAt: JsonFieldHelper.readDateTime(source, [
        'clickedAt',
        'clicked_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bannerId': bannerId,
        'userId': userId,
        'clickedAt': clickedAt?.toIso8601String(),
      };
}
