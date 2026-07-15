class PostEntity {
  const PostEntity({
    required this.id,
    required this.authorName,
    required this.content,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  final String id;
  final String authorName;
  final String content;
  final int likes;
  final int comments;
  final DateTime createdAt;
}
