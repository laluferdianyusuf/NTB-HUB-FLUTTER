import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class HomeEventModel {
  const HomeEventModel({
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

  /// Legacy UI aliases.
  String get title => name;
  DateTime get date => startAt;
  int get attendees => capacity ?? 0;
  String get category => status.value;
  String? get imageUrl => image;
  double get rating => averageRating;

  String get displayDescription {
    final value = description.trim();
    if (value.isNotEmpty) return value;
    return '$name akan diselenggarakan di $location. Bergabunglah dengan '
        'komunitas NTB Hub dan jangan lewatkan event ini.';
  }

  HomeEventModel mergeWith(HomeEventModel? other) {
    if (other == null) return this;

    return HomeEventModel(
      id: id.isNotEmpty ? id : other.id,
      name: name.isNotEmpty ? name : other.name,
      description: description.isNotEmpty ? description : other.description,
      startAt: startAt,
      endAt: endAt,
      location: location.isNotEmpty ? location : other.location,
      venueId: venueId ?? other.venueId,
      communityId: communityId ?? other.communityId,
      ownerId: ownerId ?? other.ownerId,
      userId: userId ?? other.userId,
      image: image ?? other.image,
      capacity: capacity ?? other.capacity,
      latitude: latitude ?? other.latitude,
      longitude: longitude ?? other.longitude,
      status: status,
      isActive: isActive || other.isActive,
      includeTicket: includeTicket || other.includeTicket,
      averageRating:
          averageRating > 0 ? averageRating : other.averageRating,
      totalReviews: totalReviews > 0 ? totalReviews : other.totalReviews,
      totalLikes: totalLikes > 0 ? totalLikes : other.totalLikes,
      totalViews: totalViews > 0 ? totalViews : other.totalViews,
      createdAt: createdAt ?? other.createdAt,
      updatedAt: updatedAt ?? other.updatedAt,
    );
  }

  factory HomeEventModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'event',
          'data',
          'result',
        ]) ??
        json;

    return HomeEventModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']),
      communityId:
          JsonFieldHelper.readString(source, ['communityId', 'community_id']),
      ownerId: JsonFieldHelper.readString(source, ['ownerId', 'owner_id']),
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      name: JsonFieldHelper.readString(source, [
            'name',
            'title',
            'eventName',
            'event_name',
          ]) ??
          'Event',
      description: JsonFieldHelper.readString(source, [
            'description',
            'desc',
            'about',
            'overview',
          ]) ??
          '',
      image: JsonFieldHelper.readString(source, [
        'image',
        'imageUrl',
        'image_url',
        'thumbnail',
        'coverImage',
        'cover_image',
        'photo',
        'banner',
      ]),
      startAt: JsonFieldHelper.readDateTime(source, [
            'startAt',
            'start_at',
            'date',
            'startDate',
            'start_date',
            'eventDate',
            'event_date',
          ]) ??
          DateTime.now(),
      endAt: JsonFieldHelper.readDateTime(source, [
            'endAt',
            'end_at',
            'endDate',
            'end_date',
          ]) ??
          DateTime.now(),
      capacity: JsonFieldHelper.readInt(source, [
        'capacity',
        'attendees',
        'participants',
        'participantCount',
        'participant_count',
      ]),
      location: JsonFieldHelper.readString(source, [
            'location',
            'address',
            'venue',
            'city',
            'area',
          ]) ??
          '-',
      latitude: JsonFieldHelper.readDouble(source, ['latitude', 'lat']),
      longitude: JsonFieldHelper.readDouble(source, [
        'longitude',
        'lng',
        'long',
      ]),
      status: EventStatus.fromJson(JsonFieldHelper.readString(source, [
            'status',
          ])) ??
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
            'score',
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
        'venue_id': venueId,
        'community_id': communityId,
        'owner_id': ownerId,
        'user_id': userId,
        'name': name,
        'description': description,
        'image': image,
        'start_at': startAt.toIso8601String(),
        'end_at': endAt.toIso8601String(),
        'capacity': capacity,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'status': status.value,
        'is_active': isActive,
        'include_ticket': includeTicket,
        'average_rating': averageRating,
        'total_reviews': totalReviews,
        'total_likes': totalLikes,
        'total_views': totalViews,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
