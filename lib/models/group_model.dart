class GroupModel {
  const GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.category,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final int memberCount;
  final String category;
  final String? imageUrl;

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      memberCount: json['member_count'] as int,
      category: json['category'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'member_count': memberCount,
    'category': category,
    'image_url': imageUrl,
  };
}
