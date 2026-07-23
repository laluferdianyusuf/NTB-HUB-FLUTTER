import '../core/helpers/json_field_helper.dart';

class ReviewEvent {
  const ReviewEvent({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String eventId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ReviewEvent.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['reviewEvent', 'data']) ?? json;

    return ReviewEvent(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']) ??
          '',
      rating: JsonFieldHelper.readDouble(source, ['rating', 'score']) ?? 0,
      comment: JsonFieldHelper.readString(source, [
        'comment',
        'content',
        'review',
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
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class LikeEvent {
  const LikeEvent({
    required this.id,
    required this.userId,
    required this.eventId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String eventId;
  final DateTime? createdAt;

  factory LikeEvent.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['likeEvent', 'data']) ?? json;

    return LikeEvent(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']) ??
          '',
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
        'likedAt',
        'liked_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'eventId': eventId,
        'createdAt': createdAt?.toIso8601String(),
      };
}
