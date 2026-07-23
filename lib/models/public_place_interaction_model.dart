import '../core/helpers/json_field_helper.dart';

class ReviewPublicPlace {
  const ReviewPublicPlace({
    required this.id,
    required this.userId,
    required this.publicPlaceId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String publicPlaceId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ReviewPublicPlace.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'reviewPublicPlace',
          'data',
        ]) ??
        json;

    return ReviewPublicPlace(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      publicPlaceId: JsonFieldHelper.readString(source, [
            'publicPlaceId',
            'public_place_id',
            'placeId',
            'place_id',
          ]) ??
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
        'publicPlaceId': publicPlaceId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class LikePublicPlace {
  const LikePublicPlace({
    required this.id,
    required this.userId,
    required this.publicPlaceId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String publicPlaceId;
  final DateTime? createdAt;

  factory LikePublicPlace.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['likePublicPlace', 'data']) ?? json;

    return LikePublicPlace(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      publicPlaceId: JsonFieldHelper.readString(source, [
            'publicPlaceId',
            'public_place_id',
            'placeId',
            'place_id',
          ]) ??
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
        'publicPlaceId': publicPlaceId,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class PublicPlaceImpression {
  const PublicPlaceImpression({
    required this.id,
    required this.publicPlaceId,
    this.userId,
    this.viewedAt,
  });

  final String id;
  final String? userId;
  final String publicPlaceId;
  final DateTime? viewedAt;

  factory PublicPlaceImpression.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'publicPlaceImpression',
          'data',
        ]) ??
        json;

    return PublicPlaceImpression(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      publicPlaceId: JsonFieldHelper.readString(source, [
            'publicPlaceId',
            'public_place_id',
            'placeId',
            'place_id',
          ]) ??
          '',
      viewedAt: JsonFieldHelper.readDateTime(source, [
        'viewedAt',
        'viewed_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'publicPlaceId': publicPlaceId,
        'viewedAt': viewedAt?.toIso8601String(),
      };
}
