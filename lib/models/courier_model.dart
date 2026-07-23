import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Courier {
  const Courier({
    required this.id,
    required this.userId,
    this.status = CourierStatus.offline,
    this.vehicleType = VehicleType.motorcycle,
    this.rating = 0,
    this.totalDeliveries = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final CourierStatus status;
  final VehicleType vehicleType;
  final double rating;
  final int totalDeliveries;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Courier.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['courier', 'data']) ?? json;

    return Courier(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      status: CourierStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          CourierStatus.offline,
      vehicleType: VehicleType.fromJson(
            JsonFieldHelper.readString(source, [
              'vehicleType',
              'vehicle_type',
            ]),
          ) ??
          VehicleType.motorcycle,
      rating: JsonFieldHelper.readDouble(source, ['rating', 'score']) ?? 0,
      totalDeliveries: JsonFieldHelper.readInt(source, [
            'totalDeliveries',
            'total_deliveries',
          ]) ??
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
        'userId': userId,
        'status': status.value,
        'vehicleType': vehicleType.value,
        'rating': rating,
        'totalDeliveries': totalDeliveries,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CourierLocation {
  const CourierLocation({
    required this.id,
    required this.courierId,
    required this.latitude,
    required this.longitude,
    this.updatedAt,
  });

  final String id;
  final String courierId;
  final double latitude;
  final double longitude;
  final DateTime? updatedAt;

  factory CourierLocation.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['courierLocation', 'data']) ?? json;

    return CourierLocation(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      courierId: JsonFieldHelper.readString(source, [
            'courierId',
            'courier_id',
          ]) ??
          '',
      latitude: JsonFieldHelper.readDouble(source, ['latitude', 'lat']) ?? 0,
      longitude: JsonFieldHelper.readDouble(source, [
            'longitude',
            'lng',
            'long',
          ]) ??
          0,
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courierId': courierId,
        'latitude': latitude,
        'longitude': longitude,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CourierRating {
  const CourierRating({
    required this.id,
    required this.courierId,
    required this.userId,
    required this.rating,
    this.deliveryId,
    this.comment,
    this.createdAt,
  });

  final String id;
  final String courierId;
  final String userId;
  final String? deliveryId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;

  factory CourierRating.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['courierRating', 'data']) ?? json;

    return CourierRating(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      courierId: JsonFieldHelper.readString(source, [
            'courierId',
            'courier_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      deliveryId: JsonFieldHelper.readString(source, [
        'deliveryId',
        'delivery_id',
      ]),
      rating: JsonFieldHelper.readDouble(source, ['rating', 'score']) ?? 0,
      comment: JsonFieldHelper.readString(source, ['comment', 'content']),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courierId': courierId,
        'userId': userId,
        'deliveryId': deliveryId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class CourierAvailabilityLog {
  const CourierAvailabilityLog({
    required this.id,
    required this.courierId,
    required this.status,
    this.changedAt,
  });

  final String id;
  final String courierId;
  final CourierStatus status;
  final DateTime? changedAt;

  factory CourierAvailabilityLog.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'courierAvailabilityLog',
          'data',
        ]) ??
        json;

    return CourierAvailabilityLog(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      courierId: JsonFieldHelper.readString(source, [
            'courierId',
            'courier_id',
          ]) ??
          '',
      status: CourierStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          CourierStatus.offline,
      changedAt: JsonFieldHelper.readDateTime(source, [
        'changedAt',
        'changed_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courierId': courierId,
        'status': status.value,
        'changedAt': changedAt?.toIso8601String(),
      };
}

class CourierEarnings {
  const CourierEarnings({
    required this.id,
    required this.courierId,
    required this.amount,
    this.deliveryId,
    this.description,
    this.createdAt,
  });

  final String id;
  final String courierId;
  final double amount;
  final String? deliveryId;
  final String? description;
  final DateTime? createdAt;

  factory CourierEarnings.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['courierEarnings', 'data']) ?? json;

    return CourierEarnings(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      courierId: JsonFieldHelper.readString(source, [
            'courierId',
            'courier_id',
          ]) ??
          '',
      amount: JsonFieldHelper.readDecimal(source, ['amount', 'earning']),
      deliveryId: JsonFieldHelper.readString(source, [
        'deliveryId',
        'delivery_id',
      ]),
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
        'note',
      ]),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courierId': courierId,
        'amount': amount,
        'deliveryId': deliveryId,
        'description': description,
        'createdAt': createdAt?.toIso8601String(),
      };
}
