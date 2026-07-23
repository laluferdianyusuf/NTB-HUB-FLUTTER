import '../core/helpers/json_field_helper.dart';

class UserBalance {
  const UserBalance({
    required this.id,
    required this.userId,
    this.balance = 0,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final double balance;
  final DateTime? updatedAt;

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['userBalance', 'balance', 'data']) ??
            json;

    return UserBalance(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      balance: JsonFieldHelper.readDecimal(source, ['balance', 'amount']),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'balance': balance,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class VenueBalance {
  const VenueBalance({
    required this.id,
    required this.venueId,
    this.balance = 0,
    this.updatedAt,
  });

  final String id;
  final String venueId;
  final double balance;
  final DateTime? updatedAt;

  factory VenueBalance.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['venueBalance', 'balance', 'data']) ??
            json;

    return VenueBalance(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      balance: JsonFieldHelper.readDecimal(source, ['balance', 'amount']),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'balance': balance,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class EventBalance {
  const EventBalance({
    required this.id,
    required this.eventId,
    this.balance = 0,
    this.updatedAt,
  });

  final String id;
  final String eventId;
  final double balance;
  final DateTime? updatedAt;

  factory EventBalance.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['eventBalance', 'balance', 'data']) ??
            json;

    return EventBalance(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']) ??
          '',
      balance: JsonFieldHelper.readDecimal(source, ['balance', 'amount']),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'balance': balance,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityBalance {
  const CommunityBalance({
    required this.id,
    required this.communityId,
    this.balance = 0,
    this.updatedAt,
  });

  final String id;
  final String communityId;
  final double balance;
  final DateTime? updatedAt;

  factory CommunityBalance.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(
          json,
          ['communityBalance', 'balance', 'data'],
        ) ??
        json;

    return CommunityBalance(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityId: JsonFieldHelper.readString(
            source,
            ['communityId', 'community_id'],
          ) ??
          '',
      balance: JsonFieldHelper.readDecimal(source, ['balance', 'amount']),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'communityId': communityId,
        'balance': balance,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class PlatformBalance {
  const PlatformBalance({
    required this.id,
    this.balance = 0,
    this.updatedAt,
  });

  final String id;
  final double balance;
  final DateTime? updatedAt;

  factory PlatformBalance.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(
          json,
          ['platformBalance', 'balance', 'data'],
        ) ??
        json;

    return PlatformBalance(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      balance: JsonFieldHelper.readDecimal(source, ['balance', 'amount']),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'balance': balance,
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
