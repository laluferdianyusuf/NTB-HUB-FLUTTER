import '../core/helpers/json_field_helper.dart';

class NewsModel {
  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.publishedAt,
    required this.author,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String category;
  final DateTime publishedAt;
  final String author;
  final String? imageUrl;

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: JsonFieldHelper.readString(json, ['id', '_id']) ?? '',
      title: JsonFieldHelper.readString(json, ['title', 'headline', 'name']) ??
          'Tanpa judul',
      summary: JsonFieldHelper.readString(json, [
            'summary',
            'content',
            'description',
            'excerpt',
            'body',
          ]) ??
          '',
      category: JsonFieldHelper.readString(json, [
            'category',
            'categoryName',
            'newsCategory',
            'type',
          ]) ??
          'Umum',
      publishedAt: JsonFieldHelper.readDateTime(json, [
            'publishedAt',
            'published_at',
            'createdAt',
            'created_at',
            'updatedAt',
            'updated_at',
          ]) ??
          DateTime.now(),
      author: JsonFieldHelper.readString(json, [
            'author',
            'authorName',
            'createdBy',
            'writer',
            'source',
          ]) ??
          'NTB Hub',
      imageUrl: JsonFieldHelper.readString(json, [
        'imageUrl',
        'image_url',
        'thumbnail',
        'coverImage',
        'cover_image',
        'image',
        'photo',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'summary': summary,
    'category': category,
    'published_at': publishedAt.toIso8601String(),
    'author': author,
    'image_url': imageUrl,
  };
}
