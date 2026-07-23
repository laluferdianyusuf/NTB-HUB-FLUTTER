import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Community {
  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    this.image,
    this.coverImage,
    this.isActive = true,
    this.isPrivate = false,
    this.memberCount = 0,
    this.postCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String? image;
  final String? coverImage;
  final String ownerId;
  final bool isActive;
  final bool isPrivate;
  final int memberCount;
  final int postCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Community.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['community', 'data']) ?? json;

    return Community(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
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
      coverImage: JsonFieldHelper.readString(source, [
        'coverImage',
        'cover_image',
      ]),
      ownerId: JsonFieldHelper.readString(source, ['ownerId', 'owner_id']) ??
          '',
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ], fallback: false),
      isPrivate: JsonFieldHelper.readBool(source, [
        'isPrivate',
        'is_private',
        'private',
      ], fallback: false),
      memberCount: JsonFieldHelper.readInt(source, [
            'memberCount',
            'member_count',
          ]) ??
          0,
      postCount: JsonFieldHelper.readInt(source, [
            'postCount',
            'post_count',
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
        'name': name,
        'description': description,
        'image': image,
        'coverImage': coverImage,
        'ownerId': ownerId,
        'isActive': isActive,
        'isPrivate': isPrivate,
        'memberCount': memberCount,
        'postCount': postCount,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityMember {
  const CommunityMember({
    required this.id,
    required this.communityId,
    required this.userId,
    this.role = CommunityMemberRole.member,
    this.status = CommunityMemberStatus.pending,
    this.joinedAt,
    this.updatedAt,
  });

  final String id;
  final String communityId;
  final String userId;
  final CommunityMemberRole role;
  final CommunityMemberStatus status;
  final DateTime? joinedAt;
  final DateTime? updatedAt;

  factory CommunityMember.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['communityMember', 'data']) ?? json;

    return CommunityMember(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityId: JsonFieldHelper.readString(source, [
            'communityId',
            'community_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      role: CommunityMemberRole.fromJson(
            JsonFieldHelper.readString(source, ['role']),
          ) ??
          CommunityMemberRole.member,
      status: CommunityMemberStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          CommunityMemberStatus.pending,
      joinedAt: JsonFieldHelper.readDateTime(source, [
        'joinedAt',
        'joined_at',
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
        'userId': userId,
        'role': role.value,
        'status': status.value,
        'joinedAt': joinedAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.communityId,
    required this.userId,
    required this.content,
    this.image,
    this.isPinned = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String communityId;
  final String userId;
  final String content;
  final String? image;
  final bool isPinned;
  final int likeCount;
  final int commentCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['communityPost', 'post', 'data']) ??
            json;

    return CommunityPost(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityId: JsonFieldHelper.readString(source, [
            'communityId',
            'community_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      content: JsonFieldHelper.readString(source, [
            'content',
            'text',
            'body',
          ]) ??
          '',
      image: JsonFieldHelper.readString(source, [
        'image',
        'imageUrl',
        'image_url',
      ]),
      isPinned: JsonFieldHelper.readBool(source, [
        'isPinned',
        'is_pinned',
        'pinned',
      ], fallback: false),
      likeCount: JsonFieldHelper.readInt(source, [
            'likeCount',
            'like_count',
            'likes',
          ]) ??
          0,
      commentCount: JsonFieldHelper.readInt(source, [
            'commentCount',
            'comment_count',
            'comments',
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
        'communityId': communityId,
        'userId': userId,
        'content': content,
        'image': image,
        'isPinned': isPinned,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityPostMention {
  const CommunityPostMention({
    required this.id,
    required this.postId,
    required this.userId,
    this.createdAt,
  });

  final String id;
  final String postId;
  final String userId;
  final DateTime? createdAt;

  factory CommunityPostMention.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'communityPostMention',
          'data',
        ]) ??
        json;

    return CommunityPostMention(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      postId: JsonFieldHelper.readString(source, ['postId', 'post_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'userId': userId,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class CommunityReaction {
  const CommunityReaction({
    required this.id,
    required this.postId,
    required this.userId,
    required this.emoji,
    this.createdAt,
  });

  final String id;
  final String postId;
  final String userId;
  final String emoji;
  final DateTime? createdAt;

  factory CommunityReaction.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'communityReaction',
          'reaction',
          'data',
        ]) ??
        json;

    return CommunityReaction(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      postId: JsonFieldHelper.readString(source, ['postId', 'post_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      emoji: JsonFieldHelper.readString(source, ['emoji', 'reaction']) ?? '',
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'userId': userId,
        'emoji': emoji,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class CommunityTwibbon {
  const CommunityTwibbon({
    required this.id,
    required this.communityId,
    required this.name,
    required this.imageUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String communityId;
  final String name;
  final String imageUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CommunityTwibbon.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['communityTwibbon', 'data']) ?? json;

    return CommunityTwibbon(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityId: JsonFieldHelper.readString(source, [
            'communityId',
            'community_id',
          ]) ??
          '',
      name: JsonFieldHelper.readString(source, ['name', 'title']) ?? '',
      imageUrl: JsonFieldHelper.readString(source, [
            'imageUrl',
            'image_url',
            'image',
          ]) ??
          '',
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
        'communityId': communityId,
        'name': name,
        'imageUrl': imageUrl,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommunityEventCollaboration {
  const CommunityEventCollaboration({
    required this.id,
    required this.communityId,
    required this.eventId,
    this.createdAt,
  });

  final String id;
  final String communityId;
  final String eventId;
  final DateTime? createdAt;

  factory CommunityEventCollaboration.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'communityEventCollaboration',
          'data',
        ]) ??
        json;

    return CommunityEventCollaboration(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      communityId: JsonFieldHelper.readString(source, [
            'communityId',
            'community_id',
          ]) ??
          '',
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']) ??
          '',
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'communityId': communityId,
        'eventId': eventId,
        'createdAt': createdAt?.toIso8601String(),
      };
}
