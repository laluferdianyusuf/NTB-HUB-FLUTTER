import '../core/helpers/json_field_helper.dart';
import 'venue_model.dart';

class VenueLikeResult {
  const VenueLikeResult({
    required this.isLiked,
    this.totalLikes,
  });

  final bool isLiked;
  final int? totalLikes;

  factory VenueLikeResult.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['likeVenue', 'venue', 'data', 'result']) ??
            json;

    for (final key in ['isLiked', 'is_liked', 'liked']) {
      final value = source[key];
      if (value is bool) {
        return VenueLikeResult(
          isLiked: value,
          totalLikes: JsonFieldHelper.readInt(source, [
            'totalLikes',
            'total_likes',
            'likeCount',
            'like_count',
          ]),
        );
      }
    }

    final like = LikeVenue.fromJson(source);
    if (like.id.isNotEmpty) {
      return const VenueLikeResult(isLiked: true);
    }

    final venue = VenueModel.fromJson(source);
    if (venue.id.isNotEmpty) {
      return VenueLikeResult(
        isLiked: venue.isLiked,
        totalLikes: venue.totalLikes,
      );
    }

    final action = JsonFieldHelper.readString(source, ['action', 'status']);
    if (action != null) {
      final normalized = action.toLowerCase();
      if (normalized.contains('unlike') || normalized.contains('removed')) {
        return const VenueLikeResult(isLiked: false);
      }
      if (normalized.contains('like') || normalized.contains('added')) {
        return const VenueLikeResult(isLiked: true);
      }
    }

    return const VenueLikeResult(isLiked: true);
  }
}

class LikeVenue {
  const LikeVenue({
    required this.id,
    required this.userId,
    required this.venueId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String venueId;
  final DateTime? createdAt;

  factory LikeVenue.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['likeVenue', 'data']) ?? json;

    return LikeVenue(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
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
        'venueId': venueId,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class VenueImpression {
  const VenueImpression({
    required this.id,
    required this.venueId,
    this.userId,
    this.viewedAt,
  });

  final String id;
  final String? userId;
  final String venueId;
  final DateTime? viewedAt;

  factory VenueImpression.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['venueImpression', 'data']) ?? json;

    return VenueImpression(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
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
        'venueId': venueId,
        'viewedAt': viewedAt?.toIso8601String(),
      };
}
