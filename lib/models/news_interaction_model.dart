import '../core/helpers/json_field_helper.dart';

class NewsImpression {
  const NewsImpression({
    required this.id,
    required this.newsId,
    this.userId,
    this.viewedAt,
  });

  final String id;
  final String? userId;
  final String newsId;
  final DateTime? viewedAt;

  factory NewsImpression.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['newsImpression', 'data']) ?? json;

    return NewsImpression(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
      newsId: JsonFieldHelper.readString(source, ['newsId', 'news_id']) ?? '',
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
        'newsId': newsId,
        'viewedAt': viewedAt?.toIso8601String(),
      };
}

class NewsComment {
  const NewsComment({
    required this.id,
    required this.userId,
    required this.newsId,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String newsId;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory NewsComment.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['newsComment', 'data']) ?? json;

    return NewsComment(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      newsId: JsonFieldHelper.readString(source, ['newsId', 'news_id']) ?? '',
      content: JsonFieldHelper.readString(source, [
            'content',
            'comment',
            'text',
          ]) ??
          '',
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
        'newsId': newsId,
        'content': content,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
