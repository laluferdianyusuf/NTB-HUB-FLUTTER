import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class EventTicketType {
  const EventTicketType({
    required this.id,
    required this.eventId,
    required this.name,
    required this.price,
    this.description,
    this.quota,
    this.sold = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String eventId;
  final String name;
  final String? description;
  final double price;
  final int? quota;
  final int sold;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EventTicketType.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['eventTicketType', 'data']) ?? json;

    return EventTicketType(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']) ??
          '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
      ]),
      price: JsonFieldHelper.readDecimal(source, ['price', 'amount']),
      quota: JsonFieldHelper.readInt(source, ['quota', 'capacity', 'limit']),
      sold: JsonFieldHelper.readInt(source, ['sold', 'soldCount', 'sold_count']) ??
          0,
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
        'eventId': eventId,
        'name': name,
        'description': description,
        'price': price,
        'quota': quota,
        'sold': sold,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class EventOrder {
  const EventOrder({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.totalPrice,
    this.status = EventOrderStatus.pending,
    this.paymentId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String eventId;
  final double totalPrice;
  final EventOrderStatus status;
  final String? paymentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EventOrder.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['eventOrder', 'data']) ?? json;

    return EventOrder(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']) ??
          '',
      totalPrice: JsonFieldHelper.readDecimal(source, [
        'totalPrice',
        'total_price',
        'amount',
      ]),
      status: EventOrderStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          EventOrderStatus.pending,
      paymentId: JsonFieldHelper.readString(source, [
        'paymentId',
        'payment_id',
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
        'eventId': eventId,
        'totalPrice': totalPrice,
        'status': status.value,
        'paymentId': paymentId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class EventTicket {
  const EventTicket({
    required this.id,
    required this.orderId,
    required this.ticketTypeId,
    required this.userId,
    required this.code,
    this.status = TicketStatus.active,
    this.qrCode,
    this.usedAt,
    this.createdAt,
  });

  final String id;
  final String orderId;
  final String ticketTypeId;
  final String userId;
  final String code;
  final TicketStatus status;
  final String? qrCode;
  final DateTime? usedAt;
  final DateTime? createdAt;

  factory EventTicket.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['eventTicket', 'ticket', 'data']) ??
            json;

    return EventTicket(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      orderId: JsonFieldHelper.readString(source, ['orderId', 'order_id']) ??
          '',
      ticketTypeId: JsonFieldHelper.readString(source, [
            'ticketTypeId',
            'ticket_type_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      code: JsonFieldHelper.readString(source, ['code', 'ticketCode']) ?? '',
      status: TicketStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          TicketStatus.active,
      qrCode: JsonFieldHelper.readString(source, ['qrCode', 'qr_code']),
      usedAt: JsonFieldHelper.readDateTime(source, ['usedAt', 'used_at']),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'ticketTypeId': ticketTypeId,
        'userId': userId,
        'code': code,
        'status': status.value,
        'qrCode': qrCode,
        'usedAt': usedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}

class EventAttendance {
  const EventAttendance({
    required this.id,
    required this.eventId,
    required this.userId,
    this.ticketId,
    this.checkInMethod = CheckInMethod.manual,
    this.checkedInAt,
    this.createdAt,
  });

  final String id;
  final String eventId;
  final String userId;
  final String? ticketId;
  final CheckInMethod checkInMethod;
  final DateTime? checkedInAt;
  final DateTime? createdAt;

  factory EventAttendance.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['eventAttendance', 'data']) ?? json;

    return EventAttendance(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      ticketId: JsonFieldHelper.readString(source, ['ticketId', 'ticket_id']),
      checkInMethod: CheckInMethod.fromJson(
            JsonFieldHelper.readString(source, [
              'checkInMethod',
              'check_in_method',
            ]),
          ) ??
          CheckInMethod.manual,
      checkedInAt: JsonFieldHelper.readDateTime(source, [
        'checkedInAt',
        'checked_in_at',
      ]),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'userId': userId,
        'ticketId': ticketId,
        'checkInMethod': checkInMethod.value,
        'checkedInAt': checkedInAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}
