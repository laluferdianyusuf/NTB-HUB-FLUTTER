import '../core/helpers/json_field_helper.dart';
import 'auth_model.dart';
import 'user_role_model.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.address,
    this.phone,
    this.photo,
    this.googleId,
    this.isVerified = false,
    this.biometricEnabled = false,
    this.profileViewCount = 0,
    this.profileLikeCount = 0,
    this.roles = const [],
    this.createdAt,
    this.updatedAt,
    this.location,
    this.bio,
    this.joinedAt,
  });

  final String id;
  final String name;
  final String? username;
  final String email;
  final String? address;
  final String? phone;
  final String? photo;
  final String? googleId;
  final bool isVerified;
  final bool biometricEnabled;
  final int profileViewCount;
  final int profileLikeCount;
  final List<UserRole> roles;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Legacy UI fields kept for backward compatibility.
  final String? location;
  final String? bio;
  final DateTime? joinedAt;

  String? get avatarUrl => photo;

  DateTime get displayJoinedAt =>
      joinedAt ?? createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['user', 'data', 'result']) ??
        json;

    final rolesRaw = source['roles'];
    final roles = rolesRaw is List
        ? rolesRaw
            .whereType<Map<String, dynamic>>()
            .map(UserRole.fromJson)
            .toList()
        : const <UserRole>[];

    return UserModel(
      id: JsonFieldHelper.readString(source, ['id', 'userId', 'user_id']) ?? '',
      name: JsonFieldHelper.readString(source, [
            'name',
            'fullName',
            'full_name',
          ]) ??
          '',
      username: JsonFieldHelper.readString(source, ['username']),
      email: JsonFieldHelper.readString(source, ['email']) ?? '',
      address: JsonFieldHelper.readString(source, ['address']),
      phone: JsonFieldHelper.readString(source, ['phone', 'phoneNumber']),
      photo: JsonFieldHelper.readString(source, [
        'photo',
        'avatar',
        'avatarUrl',
        'avatar_url',
        'photoUrl',
        'photo_url',
      ]),
      googleId: JsonFieldHelper.readString(source, ['googleId', 'google_id']),
      isVerified: JsonFieldHelper.readBool(source, [
        'isVerified',
        'is_verified',
        'emailVerified',
        'email_verified',
      ], fallback: false),
      biometricEnabled: JsonFieldHelper.readBool(source, [
        'biometricEnabled',
        'biometric_enabled',
      ], fallback: false),
      profileViewCount: JsonFieldHelper.readInt(source, [
            'profileViewCount',
            'profile_view_count',
          ]) ??
          0,
      profileLikeCount: JsonFieldHelper.readInt(source, [
            'profileLikeCount',
            'profile_like_count',
          ]) ??
          0,
      roles: roles,
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
      location: JsonFieldHelper.readString(source, ['location', 'city']),
      bio: JsonFieldHelper.readString(source, ['bio', 'about']),
      joinedAt: JsonFieldHelper.readDateTime(source, [
        'joinedAt',
        'joined_at',
        'createdAt',
        'created_at',
      ]),
    );
  }

  factory UserModel.fromAuth(AuthModel auth) {
    return UserModel(
      id: auth.userId,
      name: auth.name,
      email: auth.email,
      username: auth.username,
      photo: auth.avatarUrl,
      isVerified: auth.emailVerified,
      joinedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'address': address,
        'phone': phone,
        'photo': photo,
        'google_id': googleId,
        'is_verified': isVerified,
        'biometric_enabled': biometricEnabled,
        'profile_view_count': profileViewCount,
        'profile_like_count': profileLikeCount,
        'roles': roles.map((role) => role.toJson()).toList(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'location': location,
        'bio': bio,
        'joined_at': displayJoinedAt.toIso8601String(),
      };
}
