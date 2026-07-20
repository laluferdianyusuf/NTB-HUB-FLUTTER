import 'auth_model.dart';

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
    final source = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    return UserModel(
      id: _readString(source, const ['id', 'userId', 'user_id']) ?? '',
      name: _readString(source, const ['name', 'fullName', 'full_name']) ?? '',
      email: _readString(source, const ['email']) ?? '',
      avatarUrl: _readString(source, const [
        'avatar_url',
        'avatarUrl',
        'photoUrl',
        'photo_url',
        'avatar',
      ]),
      location: _readString(source, const ['location', 'address']),
      bio: _readString(source, const ['bio', 'about']),
      joinedAt: _parseDate(
            _readString(source, const [
              'joined_at',
              'joinedAt',
              'createdAt',
              'created_at',
            ]),
          ) ??
          DateTime.now(),
    );
  }

  factory UserModel.fromAuth(AuthModel auth) {
    return UserModel(
      id: auth.userId,
      name: auth.name,
      email: auth.email,
      avatarUrl: auth.avatarUrl,
      joinedAt: DateTime.now(),
    );
  }
  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value.toString();
    }
    return null;
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
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
