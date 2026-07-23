import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Delivery {
  const Delivery({
    required this.id,
    required this.userId,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.fee,
    this.orderId,
    this.courierId,
    this.status = DeliveryStatus.pending,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.distance,
    this.estimatedAt,
    this.deliveredAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? orderId;
  final String userId;
  final String? courierId;
  final DeliveryStatus status;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final String pickupAddress;
  final String dropoffAddress;
  final double fee;
  final double? distance;
  final DateTime? estimatedAt;
  final DateTime? deliveredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Delivery.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['delivery', 'data']) ?? json;

    return Delivery(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      orderId: JsonFieldHelper.readString(source, ['orderId', 'order_id']),
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      courierId: JsonFieldHelper.readString(source, [
        'courierId',
        'courier_id',
      ]),
      status: DeliveryStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          DeliveryStatus.pending,
      pickupLat: JsonFieldHelper.readDouble(source, [
        'pickupLat',
        'pickup_lat',
      ]),
      pickupLng: JsonFieldHelper.readDouble(source, [
        'pickupLng',
        'pickup_lng',
      ]),
      dropoffLat: JsonFieldHelper.readDouble(source, [
        'dropoffLat',
        'dropoff_lat',
      ]),
      dropoffLng: JsonFieldHelper.readDouble(source, [
        'dropoffLng',
        'dropoff_lng',
      ]),
      pickupAddress: JsonFieldHelper.readString(source, [
            'pickupAddress',
            'pickup_address',
          ]) ??
          '',
      dropoffAddress: JsonFieldHelper.readString(source, [
            'dropoffAddress',
            'dropoff_address',
          ]) ??
          '',
      fee: JsonFieldHelper.readDecimal(source, ['fee', 'amount', 'price']),
      distance: JsonFieldHelper.readDouble(source, ['distance']),
      estimatedAt: JsonFieldHelper.readDateTime(source, [
        'estimatedAt',
        'estimated_at',
      ]),
      deliveredAt: JsonFieldHelper.readDateTime(source, [
        'deliveredAt',
        'delivered_at',
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
        'orderId': orderId,
        'userId': userId,
        'courierId': courierId,
        'status': status.value,
        'pickupLat': pickupLat,
        'pickupLng': pickupLng,
        'dropoffLat': dropoffLat,
        'dropoffLng': dropoffLng,
        'pickupAddress': pickupAddress,
        'dropoffAddress': dropoffAddress,
        'fee': fee,
        'distance': distance,
        'estimatedAt': estimatedAt?.toIso8601String(),
        'deliveredAt': deliveredAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class DeliveryAssignmentLog {
  const DeliveryAssignmentLog({
    required this.id,
    required this.deliveryId,
    required this.courierId,
    required this.status,
    this.assignedAt,
    this.respondedAt,
  });

  final String id;
  final String deliveryId;
  final String courierId;
  final DeliveryStatus status;
  final DateTime? assignedAt;
  final DateTime? respondedAt;

  factory DeliveryAssignmentLog.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'deliveryAssignmentLog',
          'data',
        ]) ??
        json;

    return DeliveryAssignmentLog(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      deliveryId: JsonFieldHelper.readString(source, [
            'deliveryId',
            'delivery_id',
          ]) ??
          '',
      courierId: JsonFieldHelper.readString(source, [
            'courierId',
            'courier_id',
          ]) ??
          '',
      status: DeliveryStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          DeliveryStatus.pending,
      assignedAt: JsonFieldHelper.readDateTime(source, [
        'assignedAt',
        'assigned_at',
      ]),
      respondedAt: JsonFieldHelper.readDateTime(source, [
        'respondedAt',
        'responded_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'deliveryId': deliveryId,
        'courierId': courierId,
        'status': status.value,
        'assignedAt': assignedAt?.toIso8601String(),
        'respondedAt': respondedAt?.toIso8601String(),
      };
}

class DeliveryRejectedCourier {
  const DeliveryRejectedCourier({
    required this.id,
    required this.deliveryId,
    required this.courierId,
    this.reason,
    this.rejectedAt,
  });

  final String id;
  final String deliveryId;
  final String courierId;
  final String? reason;
  final DateTime? rejectedAt;

  factory DeliveryRejectedCourier.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'deliveryRejectedCourier',
          'data',
        ]) ??
        json;

    return DeliveryRejectedCourier(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      deliveryId: JsonFieldHelper.readString(source, [
            'deliveryId',
            'delivery_id',
          ]) ??
          '',
      courierId: JsonFieldHelper.readString(source, [
            'courierId',
            'courier_id',
          ]) ??
          '',
      reason: JsonFieldHelper.readString(source, ['reason', 'note']),
      rejectedAt: JsonFieldHelper.readDateTime(source, [
        'rejectedAt',
        'rejected_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'deliveryId': deliveryId,
        'courierId': courierId,
        'reason': reason,
        'rejectedAt': rejectedAt?.toIso8601String(),
      };
}
