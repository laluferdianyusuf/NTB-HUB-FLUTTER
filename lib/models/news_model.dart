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
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      category: json['category'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String),
      author: json['author'] as String,
      imageUrl: json['image_url'] as String?,
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
