import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Comment {
  const Comment({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.content,
    this.parentId,
    this.likeCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final CommentEntityType entityType;
  final String entityId;
  final String content;
  final String? parentId;
  final int likeCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Comment.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['comment', 'data']) ?? json;

    return Comment(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      entityType: CommentEntityType.fromJson(
            JsonFieldHelper.readString(source, [
              'entityType',
              'entity_type',
            ]),
          ) ??
          CommentEntityType.community,
      entityId: JsonFieldHelper.readString(source, [
            'entityId',
            'entity_id',
          ]) ??
          '',
      content: JsonFieldHelper.readString(source, [
            'content',
            'text',
            'body',
          ]) ??
          '',
      parentId: JsonFieldHelper.readString(source, [
        'parentId',
        'parent_id',
      ]),
      likeCount: JsonFieldHelper.readInt(source, [
            'likeCount',
            'like_count',
            'likes',
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
        'userId': userId,
        'entityType': entityType.value,
        'entityId': entityId,
        'content': content,
        'parentId': parentId,
        'likeCount': likeCount,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class CommentLike {
  const CommentLike({
    required this.id,
    required this.commentId,
    required this.userId,
    this.createdAt,
  });

  final String id;
  final String commentId;
  final String userId;
  final DateTime? createdAt;

  factory CommentLike.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['commentLike', 'data']) ?? json;

    return CommentLike(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      commentId: JsonFieldHelper.readString(source, [
            'commentId',
            'comment_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
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
        'commentId': commentId,
        'userId': userId,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class CommentReport {
  const CommentReport({
    required this.id,
    required this.commentId,
    required this.userId,
    required this.reason,
    this.createdAt,
  });

  final String id;
  final String commentId;
  final String userId;
  final String reason;
  final DateTime? createdAt;

  factory CommentReport.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['commentReport', 'data']) ?? json;

    return CommentReport(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      commentId: JsonFieldHelper.readString(source, [
            'commentId',
            'comment_id',
          ]) ??
          '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      reason: JsonFieldHelper.readString(source, ['reason', 'note']) ?? '',
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'commentId': commentId,
        'userId': userId,
        'reason': reason,
        'createdAt': createdAt?.toIso8601String(),
      };
}
