import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Booking {
  const Booking({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.serviceId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    this.unitId,
    this.status = BookingStatus.pending,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String venueId;
  final String serviceId;
  final String? unitId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final BookingStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Booking.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['booking', 'data']) ?? json;

    return Booking(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      serviceId: JsonFieldHelper.readString(source, [
            'serviceId',
            'service_id',
          ]) ??
          '',
      unitId: JsonFieldHelper.readString(source, ['unitId', 'unit_id']),
      startTime: JsonFieldHelper.readDateTime(source, [
            'startTime',
            'start_time',
          ]) ??
          DateTime.now(),
      endTime: JsonFieldHelper.readDateTime(source, [
            'endTime',
            'end_time',
          ]) ??
          DateTime.now(),
      totalPrice: JsonFieldHelper.readDecimal(source, [
        'totalPrice',
        'total_price',
        'price',
        'amount',
      ]),
      status: BookingStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          BookingStatus.pending,
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
        'venueId': venueId,
        'serviceId': serviceId,
        'unitId': unitId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'totalPrice': totalPrice,
        'status': status.value,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
