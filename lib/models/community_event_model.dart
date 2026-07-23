import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class CommunityEvent {
  const CommunityEvent({
    required this.id,
    required this.communityId,
    required this.name,
    required this.type,
    required this.status,
    required this.startAt,
    required this.endAt,
    required this.location,
    this.description,
    this.image,
    this.latitude,
    this.longitude,
    this.capacity,
    this.includeTicket = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String communityId;
  final String name;
  final String? description;
  final String? image;
  final CommunityEventType type;
  final CommunityEventStatus status;
  final DateTime startAt;
  final DateTime endAt;
  final String location;
  final double? latitude;
  final double? longitude;
  final int? capacity;
  final bool includeTicket;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommunityEvent.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['communityEvent', 'data']) ?? json;

    return CommunityEvent(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityId: JsonFieldHelper.readString(source, [
            'communityId',
            'community_id',
          ]) ??
          '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
      ]),
      image: JsonFieldHelper.readString(source, [
        'image',
        'imageUrl',
        'image_url',
      ]),
      type: CommunityEventType.fromJson(
            JsonFieldHelper.readString(source, ['type']),
          ) ??
          CommunityEventType.other,
      status: CommunityEventStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          CommunityEventStatus.upcoming,
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
      location: JsonFieldHelper.readString(source, [
            'location',
            'address',
          ]) ??
          '',
      latitude: JsonFieldHelper.readDouble(source, ['latitude', 'lat']),
      longitude: JsonFieldHelper.readDouble(source, [
        'longitude',
        'lng',
        'long',
      ]),
      capacity: JsonFieldHelper.readInt(source, ['capacity']),
      includeTicket: JsonFieldHelper.readBool(source, [
        'includeTicket',
        'include_ticket',
      ], fallback: false),
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
        'communityId': communityId,
        'name': name,
        'description': description,
        'image': image,
        'type': type.value,
        'status': status.value,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'capacity': capacity,
        'includeTicket': includeTicket,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityEventTicketType {
  const CommunityEventTicketType({
    required this.id,
    required this.communityEventId,
    required this.name,
    required this.price,
    this.quota,
    this.sold = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String communityEventId;
  final String name;
  final double price;
  final int? quota;
  final int sold;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommunityEventTicketType.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'communityEventTicketType',
          'data',
        ]) ??
        json;

    return CommunityEventTicketType(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityEventId: JsonFieldHelper.readString(source, [
            'communityEventId',
            'community_event_id',
          ]) ??
          '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      price: JsonFieldHelper.readDecimal(source, ['price', 'amount']),
      quota: JsonFieldHelper.readInt(source, ['quota', 'capacity']),
      sold: JsonFieldHelper.readInt(source, ['sold', 'soldCount']) ?? 0,
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
        'communityEventId': communityEventId,
        'name': name,
        'price': price,
        'quota': quota,
        'sold': sold,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityEventOrder {
  const CommunityEventOrder({
    required this.id,
    required this.userId,
    required this.communityEventId,
    required this.totalPrice,
    this.status = EventOrderStatus.pending,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String communityEventId;
  final double totalPrice;
  final EventOrderStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommunityEventOrder.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'communityEventOrder',
          'data',
        ]) ??
        json;

    return CommunityEventOrder(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      communityEventId: JsonFieldHelper.readString(source, [
            'communityEventId',
            'community_event_id',
          ]) ??
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
        'communityEventId': communityEventId,
        'totalPrice': totalPrice,
        'status': status.value,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityEventTicket {
  const CommunityEventTicket({
    required this.id,
    required this.orderId,
    required this.ticketTypeId,
    required this.userId,
    required this.code,
    this.status = TicketStatus.active,
    this.usedAt,
    this.createdAt,
  });

  final String id;
  final String orderId;
  final String ticketTypeId;
  final String userId;
  final String code;
  final TicketStatus status;
  final DateTime? usedAt;
  final DateTime? createdAt;

  factory CommunityEventTicket.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'communityEventTicket',
          'ticket',
          'data',
        ]) ??
        json;

    return CommunityEventTicket(
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
        'usedAt': usedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}

class CommunityEventAttendance {
  const CommunityEventAttendance({
    required this.id,
    required this.communityEventId,
    required this.userId,
    this.ticketId,
    this.checkInMethod = CheckInMethod.manual,
    this.checkedInAt,
    this.createdAt,
  });

  final String id;
  final String communityEventId;
  final String userId;
  final String? ticketId;
  final CheckInMethod checkInMethod;
  final DateTime? checkedInAt;
  final DateTime? createdAt;

  factory CommunityEventAttendance.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'communityEventAttendance',
          'data',
        ]) ??
        json;

    return CommunityEventAttendance(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityEventId: JsonFieldHelper.readString(source, [
            'communityEventId',
            'community_event_id',
          ]) ??
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
        'communityEventId': communityEventId,
        'userId': userId,
        'ticketId': ticketId,
        'checkInMethod': checkInMethod.value,
        'checkedInAt': checkedInAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}
