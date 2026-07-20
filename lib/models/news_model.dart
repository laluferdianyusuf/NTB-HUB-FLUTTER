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
    this.sourceUrl,
    this.content,
  });

  final String id;
  final String title;
  final String summary;
  final String category;
  final DateTime publishedAt;
  final String author;
  final String? imageUrl;
  final String? sourceUrl;
  final String? content;

  bool get hasExternalUrl => webViewUrl != null;

  bool get hasValidExternalUrl => hasExternalUrl;

  String? get webViewUrl => normalizeWebsiteUrl(sourceUrl);

  bool get hasRichContent {
    final value = content?.trim();
    return value != null && value.isNotEmpty;
  }

  String get displayBody {
    if (hasRichContent) return content!.trim();
    return summary.trim();
  }

  NewsModel mergeWith(NewsModel? other) {
    if (other == null) return this;

    return NewsModel(
      id: id.isNotEmpty ? id : other.id,
      title: title.isNotEmpty ? title : other.title,
      summary: summary.isNotEmpty ? summary : other.summary,
      category: category.isNotEmpty ? category : other.category,
      publishedAt: publishedAt,
      author: author.isNotEmpty ? author : other.author,
      imageUrl: imageUrl ?? other.imageUrl,
      sourceUrl: sourceUrl ?? other.sourceUrl,
      content: content ?? other.content,
    );
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final source = json['news'] is Map<String, dynamic>
        ? json['news'] as Map<String, dynamic>
        : json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json;

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

    return NewsModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      title: JsonFieldHelper.readString(source, ['title', 'headline', 'name']) ??
          'Tanpa judul',
      summary: JsonFieldHelper.readString(source, [
            'summary',
            'description',
            'excerpt',
          ]) ??
          (content != null && !content.contains('<') ? content : ''),
      category: JsonFieldHelper.readString(source, [
            'category',
            'categoryName',
            'newsCategory',
            'type',
          ]) ??
          'Umum',
      publishedAt: JsonFieldHelper.readDateTime(source, [
            'publishedAt',
            'published_at',
            'createdAt',
            'created_at',
            'updatedAt',
            'updated_at',
          ]) ??
          DateTime.now(),
      author: JsonFieldHelper.readString(source, [
            'author',
            'authorName',
            'createdBy',
            'writer',
          ]) ??
          'NTB Hub',
      imageUrl: JsonFieldHelper.readString(source, [
        'imageUrl',
        'image_url',
        'thumbnail',
        'coverImage',
        'cover_image',
        'image',
        'photo',
      ]),
      sourceUrl: _readWebsiteUrl(source),
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

  static String? _readWebsiteUrl(Map<String, dynamic> source) {
    const websiteKeys = [
      'website',
      'websiteUrl',
      'website_url',
      'webUrl',
      'web_url',
      'newsUrl',
      'news_url',
      'pageUrl',
      'page_url',
      'sourceUrl',
      'source_url',
      'url',
      'link',
      'articleUrl',
      'article_url',
      'externalUrl',
      'external_url',
    ];

    String? fallback;

    for (final key in websiteKeys) {
      final normalized = normalizeWebsiteUrl(source[key]?.toString());
      if (normalized == null) continue;

      if (_isApiEndpoint(normalized)) {
        fallback ??= normalized;
        continue;
      }

      return normalized;
    }

    return fallback;
  }

  static bool _isApiEndpoint(String url) {
    final lower = url.toLowerCase();
    return lower.contains('/api/') || lower.contains('api.ntbhub.com');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'category': category,
        'published_at': publishedAt.toIso8601String(),
        'author': author,
        'image_url': imageUrl,
        'source_url': sourceUrl,
        'content': content,
      };
}
