import '../core/helpers/json_field_helper.dart';

class Review {
  const Review({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.rating,
    this.bookingId,
    this.comment,
    this.userName,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String venueId;
  final String? bookingId;
  final double rating;
  final String? comment;
  final String? userName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayUserName {
    final value = userName?.trim();
    if (value != null && value.isNotEmpty) return value;
    return 'Pengguna';
  }

  String get displayComment {
    final value = comment?.trim();
    if (value != null && value.isNotEmpty) return value;
    return 'Tidak ada komentar.';
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['review', 'data']) ?? json;
    final user = JsonFieldHelper.readMap(source, ['user', 'profile', 'author']);

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
      userName: JsonFieldHelper.readString(source, [
        'userName',
        'user_name',
        'name',
        'username',
      ]) ??
          JsonFieldHelper.readString(user ?? {}, [
            'name',
            'username',
            'fullName',
            'full_name',
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
        'userName': userName,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
