import '../core/helpers/json_field_helper.dart';

class Review {
  const Review({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.rating,
    this.bookingId,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String venueId;
  final String? bookingId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['review', 'data']) ?? json;

    return Review(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      bookingId: JsonFieldHelper.readString(source, [
        'bookingId',
        'booking_id',
      ]),
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
        'venueId': venueId,
        'bookingId': bookingId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
