class PostModel {
  const PostModel({
    required this.id,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  final String id;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final DateTime createdAt;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      authorName: json['author_name'] as String,
      authorAvatar: json['author_avatar'] as String?,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'author_name': authorName,
    'author_avatar': authorAvatar,
    'content': content,
    'image_url': imageUrl,
    'likes': likes,
    'comments': comments,
    'created_at': createdAt.toIso8601String(),
  };
}
