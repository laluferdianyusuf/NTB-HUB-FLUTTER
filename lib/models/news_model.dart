import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class NewsModel {
  const NewsModel({
    required this.id,
    required this.sourceUrl,
    required this.title,
    required this.description,
    required this.source,
    required this.status,
    this.image,
    this.totalViews = 0,
    this.createdAt,
    this.updatedAt,
    this.summary,
    this.category,
    this.publishedAt,
    this.author,
    this.content,
  });

  final String id;
  final String sourceUrl;
  final String title;
  final String description;
  final String? image;
  final String source;
  final NewsStatus status;
  final int totalViews;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Legacy UI fields.
  final String? summary;
  final String? category;
  final DateTime? publishedAt;
  final String? author;
  final String? content;

  String get displaySummary => summary ?? description;
  String get displayCategory => category ?? source;
  DateTime get displayPublishedAt =>
      publishedAt ?? createdAt ?? DateTime.now();
  String get displayAuthor => author ?? source;
  String? get imageUrl => image;

  bool get hasExternalUrl => webViewUrl != null;
  bool get hasValidExternalUrl => hasExternalUrl;
  String? get webViewUrl => normalizeWebsiteUrl(sourceUrl);

  bool get hasRichContent {
    final value = content?.trim();
    return value != null && value.isNotEmpty;
  }

  String get displayBody {
    if (hasRichContent) return content!.trim();
    return displaySummary.trim();
  }

  NewsModel mergeWith(NewsModel? other) {
    if (other == null) return this;

    return NewsModel(
      id: id.isNotEmpty ? id : other.id,
      sourceUrl: sourceUrl.isNotEmpty ? sourceUrl : other.sourceUrl,
      title: title.isNotEmpty ? title : other.title,
      description: description.isNotEmpty ? description : other.description,
      source: source.isNotEmpty ? source : other.source,
      status: status,
      image: image ?? other.image,
      totalViews: totalViews > 0 ? totalViews : other.totalViews,
      createdAt: createdAt ?? other.createdAt,
      updatedAt: updatedAt ?? other.updatedAt,
      summary: summary ?? other.summary,
      category: category ?? other.category,
      publishedAt: publishedAt ?? other.publishedAt,
      author: author ?? other.author,
      content: content ?? other.content,
    );
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['news', 'data', 'result']) ??
        json;

    final content = JsonFieldHelper.readString(source, [
      'content',
      'body',
      'html',
      'htmlContent',
      'html_content',
      'detail',
      'fullContent',
      'full_content',
      'article',
    ]);

    final description = JsonFieldHelper.readString(source, [
          'description',
          'summary',
          'excerpt',
        ]) ??
        (content != null && !content.contains('<') ? content : '');

    return NewsModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      sourceUrl: JsonFieldHelper.readString(source, [
            'sourceUrl',
            'source_url',
            'url',
            'link',
          ]) ??
          '',
      title: JsonFieldHelper.readString(source, [
            'title',
            'headline',
            'name',
          ]) ??
          'Tanpa judul',
      description: description,
      source: JsonFieldHelper.readString(source, [
            'source',
            'publisher',
            'provider',
          ]) ??
          'NTB Hub',
      status: NewsStatus.fromJson(JsonFieldHelper.readString(source, [
            'status',
          ])) ??
          NewsStatus.manual,
      image: JsonFieldHelper.readString(source, [
        'image',
        'imageUrl',
        'image_url',
        'thumbnail',
        'coverImage',
        'cover_image',
        'photo',
      ]),
      totalViews: JsonFieldHelper.readInt(source, [
            'totalViews',
            'total_views',
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
      summary: JsonFieldHelper.readString(source, ['summary', 'excerpt']),
      category: JsonFieldHelper.readString(source, [
        'category',
        'categoryName',
        'newsCategory',
        'type',
      ]),
      publishedAt: JsonFieldHelper.readDateTime(source, [
        'publishedAt',
        'published_at',
        'createdAt',
        'created_at',
      ]),
      author: JsonFieldHelper.readString(source, [
        'author',
        'authorName',
        'createdBy',
        'writer',
      ]),
      content: content,
    );
  }

  static String? normalizeWebsiteUrl(String? raw) {
    if (raw == null) return null;

    var value = raw.trim();
    if (value.isEmpty) return null;
    if (value.contains('{id}') || value.contains('%7Bid%7D')) return null;

    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      value = 'https://$value';
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;

    return uri.toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'source_url': sourceUrl,
        'title': title,
        'description': description,
        'source': source,
        'status': status.value,
        'image': image,
        'total_views': totalViews,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'summary': summary,
        'category': category,
        'published_at': displayPublishedAt.toIso8601String(),
        'author': author,
        'content': content,
      };
}
