class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.location,
    this.bio,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? location;
  final String? bio;
  final DateTime joinedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar_url': avatarUrl,
    'location': location,
    'bio': bio,
    'joined_at': joinedAt.toIso8601String(),
  };
}
