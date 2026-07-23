import '../core/helpers/json_field_helper.dart';

class ProfileView {
  const ProfileView({
    required this.id,
    required this.viewerId,
    required this.profileUserId,
    this.viewedAt,
  });

  final String id;
  final String viewerId;
  final String profileUserId;
  final DateTime? viewedAt;

  factory ProfileView.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['profileView', 'data']) ?? json;

    return ProfileView(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      viewerId: JsonFieldHelper.readString(source, [
            'viewerId',
            'viewer_id',
          ]) ??
          '',
      profileUserId: JsonFieldHelper.readString(source, [
            'profileUserId',
            'profile_user_id',
            'profileId',
            'profile_id',
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
        'viewerId': viewerId,
        'profileUserId': profileUserId,
        'viewedAt': viewedAt?.toIso8601String(),
      };
}

class ProfileLike {
  const ProfileLike({
    required this.id,
    required this.likerId,
    required this.profileUserId,
    this.likedAt,
  });

  final String id;
  final String likerId;
  final String profileUserId;
  final DateTime? likedAt;

  factory ProfileLike.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['profileLike', 'data']) ?? json;

    return ProfileLike(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      likerId: JsonFieldHelper.readString(source, ['likerId', 'liker_id']) ??
          '',
      profileUserId: JsonFieldHelper.readString(source, [
            'profileUserId',
            'profile_user_id',
            'profileId',
            'profile_id',
          ]) ??
          '',
      likedAt: JsonFieldHelper.readDateTime(source, [
        'likedAt',
        'liked_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'likerId': likerId,
        'profileUserId': profileUserId,
        'likedAt': likedAt?.toIso8601String(),
      };
}
