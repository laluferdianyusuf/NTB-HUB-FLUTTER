import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Promotion {
  const Promotion({
    required this.id,
    required this.venueId,
    required this.name,
    required this.type,
    required this.status,
    required this.discountType,
    required this.discountValue,
    required this.startAt,
    required this.endAt,
    this.description,
    this.minOrderAmount,
    this.maxDiscount,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String venueId;
  final String name;
  final String? description;
  final PromotionType type;
  final PromotionStatus status;
  final DiscountType discountType;
  final double discountValue;
  final double? minOrderAmount;
  final double? maxDiscount;
  final DateTime startAt;
  final DateTime endAt;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Promotion.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['promotion', 'data']) ?? json;

    return Promotion(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
      ]),
      type: PromotionType.fromJson(
            JsonFieldHelper.readString(source, ['type']),
          ) ??
          PromotionType.orderDiscount,
      status: PromotionStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          PromotionStatus.pending,
      discountType: DiscountType.fromJson(
            JsonFieldHelper.readString(source, [
              'discountType',
              'discount_type',
            ]),
          ) ??
          DiscountType.percent,
      discountValue: JsonFieldHelper.readDecimal(source, [
        'discountValue',
        'discount_value',
        'value',
      ]),
      minOrderAmount: JsonFieldHelper.readDouble(source, [
        'minOrderAmount',
        'min_order_amount',
      ]),
      maxDiscount: JsonFieldHelper.readDouble(source, [
        'maxDiscount',
        'max_discount',
      ]),
      startAt: JsonFieldHelper.readDateTime(source, [
            'startAt',
            'start_at',
          ]) ??
          DateTime.now(),
      endAt: JsonFieldHelper.readDateTime(source, [
            'endAt',
            'end_at',
          ]) ??
          DateTime.now(),
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
        'name': name,
        'description': description,
        'type': type.value,
        'status': status.value,
        'discountType': discountType.value,
        'discountValue': discountValue,
        'minOrderAmount': minOrderAmount,
        'maxDiscount': maxDiscount,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class PromotionItem {
  const PromotionItem({
    required this.id,
    required this.promotionId,
    required this.menuId,
    this.requiredQty,
    this.freeQty,
  });

  final String id;
  final String promotionId;
  final String menuId;
  final int? requiredQty;
  final int? freeQty;

  factory PromotionItem.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['promotionItem', 'data']) ?? json;

    return PromotionItem(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      promotionId: JsonFieldHelper.readString(source, [
            'promotionId',
            'promotion_id',
          ]) ??
          '',
      menuId: JsonFieldHelper.readString(source, ['menuId', 'menu_id']) ?? '',
      requiredQty: JsonFieldHelper.readInt(source, [
        'requiredQty',
        'required_qty',
      ]),
      freeQty: JsonFieldHelper.readInt(source, ['freeQty', 'free_qty']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'promotionId': promotionId,
        'menuId': menuId,
        'requiredQty': requiredQty,
        'freeQty': freeQty,
      };
}

class PromotionUsage {
  const PromotionUsage({
    required this.id,
    required this.promotionId,
    required this.userId,
    this.orderId,
    this.usedAt,
  });

  final String id;
  final String promotionId;
  final String userId;
  final String? orderId;
  final DateTime? usedAt;

  factory PromotionUsage.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['promotionUsage', 'data']) ?? json;

    return PromotionUsage(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      promotionId: JsonFieldHelper.readString(source, [
            'promotionId',
            'promotion_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      orderId: JsonFieldHelper.readString(source, ['orderId', 'order_id']),
      usedAt: JsonFieldHelper.readDateTime(source, [
        'usedAt',
        'used_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'promotionId': promotionId,
        'userId': userId,
        'orderId': orderId,
        'usedAt': usedAt?.toIso8601String(),
      };
}

class PromotionSchedule {
  const PromotionSchedule({
    required this.id,
    required this.promotionId,
    required this.dayOfWeek,
    required this.startMinutes,
    required this.endMinutes,
  });

  final String id;
  final String promotionId;
  final int dayOfWeek;
  final int startMinutes;
  final int endMinutes;

  factory PromotionSchedule.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['promotionSchedule', 'data']) ?? json;

    return PromotionSchedule(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      promotionId: JsonFieldHelper.readString(source, [
            'promotionId',
            'promotion_id',
          ]) ??
          '',
      dayOfWeek: JsonFieldHelper.readInt(source, [
            'dayOfWeek',
            'day_of_week',
          ]) ??
          0,
      startMinutes: JsonFieldHelper.readInt(source, [
            'startMinutes',
            'start_minutes',
            'opensAt',
            'opens_at',
          ]) ??
          0,
      endMinutes: JsonFieldHelper.readInt(source, [
            'endMinutes',
            'end_minutes',
            'closesAt',
            'closes_at',
          ]) ??
          0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'promotionId': promotionId,
        'dayOfWeek': dayOfWeek,
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
      };
}
