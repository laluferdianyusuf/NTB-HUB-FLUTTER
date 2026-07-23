import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Event {
  const Event({
    required this.id,
    required this.name,
    required this.description,
    required this.startAt,
    required this.endAt,
    required this.location,
    this.venueId,
    this.communityId,
    this.ownerId,
    this.userId,
    this.image,
    this.capacity,
    this.latitude,
    this.longitude,
    this.status = EventStatus.upcoming,
    this.isActive = true,
    this.includeTicket = false,
    this.averageRating = 0,
    this.totalReviews = 0,
    this.totalLikes = 0,
    this.totalViews = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? venueId;
  final String? communityId;
  final String? ownerId;
  final String? userId;
  final String name;
  final String description;
  final String? image;
  final DateTime startAt;
  final DateTime endAt;
  final int? capacity;
  final String location;
  final double? latitude;
  final double? longitude;
  final EventStatus status;
  final bool isActive;
  final bool includeTicket;
  final double averageRating;
  final int totalReviews;
  final int totalLikes;
  final int totalViews;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Event.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['event', 'data']) ?? json;

    return Event(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']),
      communityId:
          JsonFieldHelper.readString(source, ['communityId', 'community_id']),
      ownerId: JsonFieldHelper.readString(source, ['ownerId', 'owner_id']),
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      description: JsonFieldHelper.readString(source, [
            'description',
            'desc',
          ]) ??
          '',
      image: JsonFieldHelper.readString(source, [
        'image',
        'imageUrl',
        'image_url',
      ]),
      startAt: JsonFieldHelper.readDateTime(source, [
            'startAt',
            'start_at',
            'startDate',
            'start_date',
          ]) ??
          DateTime.now(),
      endAt: JsonFieldHelper.readDateTime(source, [
            'endAt',
            'end_at',
            'endDate',
            'end_date',
          ]) ??
          DateTime.now(),
      capacity: JsonFieldHelper.readInt(source, ['capacity', 'maxCapacity']),
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
      status: EventStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          EventStatus.upcoming,
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      includeTicket: JsonFieldHelper.readBool(source, [
        'includeTicket',
        'include_ticket',
      ], fallback: false),
      averageRating: JsonFieldHelper.readDouble(source, [
            'averageRating',
            'average_rating',
            'rating',
          ]) ??
          0,
      totalReviews: JsonFieldHelper.readInt(source, [
            'totalReviews',
            'total_reviews',
          ]) ??
          0,
      totalLikes: JsonFieldHelper.readInt(source, [
            'totalLikes',
            'total_likes',
          ]) ??
          0,
      totalViews: JsonFieldHelper.readInt(source, [
            'totalViews',
            'total_views',
          ]) ??
          0,
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
        'communityId': communityId,
        'ownerId': ownerId,
        'userId': userId,
        'name': name,
        'description': description,
        'image': image,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'capacity': capacity,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'status': status.value,
        'isActive': isActive,
        'includeTicket': includeTicket,
        'averageRating': averageRating,
        'totalReviews': totalReviews,
        'totalLikes': totalLikes,
        'totalViews': totalViews,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
