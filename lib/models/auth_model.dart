class AuthModel {
  const AuthModel({
    this.token,
    this.refreshToken,
    required this.userId,
    required this.name,
    required this.email,
    this.username,
    this.avatarUrl,
    this.emailVerified = false,
    this.requiresEmailVerification = false,
  });

  final String? token;
  final String? refreshToken;
  final String userId;
  final String name;
  final String email;
  final String? username;
  final String? avatarUrl;
  final bool emailVerified;
  final bool requiresEmailVerification;
  bool get isAuthenticated =>
      token != null && token!.isNotEmpty && !requiresEmailVerification;

  AuthModel copyWith({
    String? token,
    String? refreshToken,
    String? userId,
    String? name,
    String? email,
    String? username,
    String? avatarUrl,
    bool? emailVerified,
    bool? requiresEmailVerification,
  }) {
    return AuthModel(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      requiresEmailVerification:
          requiresEmailVerification ?? this.requiresEmailVerification,
    );
  }
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;
    final source = user ?? json;

    final accessToken = _readString(json, const [
      'accessToken',
      'access_token',
      'token',
    ]) ??
        _readString(source, const ['accessToken', 'access_token', 'token']);

    final refreshToken = _readString(json, const [
      'refreshToken',
      'refresh_token',
    ]) ??
        _readString(source, const ['refreshToken', 'refresh_token']);

    final userId = _readString(source, const ['userId', 'user_id', 'id']) ??
        _readString(json, const ['userId', 'user_id', 'id']) ??
        '';

    final emailVerified = source['emailVerified'] == true ||
        source['email_verified'] == true ||
        source['isEmailVerified'] == true ||
        json['emailVerified'] == true;

    final requiresEmailVerification = json['requiresEmailVerification'] == true ||
        json['requires_email_verification'] == true ||
        (accessToken == null && userId.isNotEmpty && !emailVerified);

    return AuthModel(
      token: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      name: _readString(source, const ['name', 'fullName', 'full_name']) ??
          _readString(json, const ['name', 'fullName', 'full_name']) ??
          '',
      email: _readString(source, const ['email']) ??
          _readString(json, const ['email']) ??
          '',
      username: _readString(source, const ['username']) ??
          _readString(json, const ['username']),
      avatarUrl: _readString(source, const [
            'avatar_url',
            'avatarUrl',
            'photoUrl',
            'photo_url',
            'avatar',
          ]) ??
          _readString(json, const [
            'avatar_url',
            'avatarUrl',
            'photoUrl',
            'photo_url',
            'avatar',
          ]),
      emailVerified: emailVerified,      requiresEmailVerification: requiresEmailVerification,
    );
  }

  Map<String, dynamic> toJson() => {
        if (token != null) 'token': token,
        if (refreshToken != null) 'refresh_token': refreshToken,
        'user_id': userId,
        'name': name,
        'email': email,
        if (username != null) 'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'email_verified': emailVerified,        'requires_email_verification': requiresEmailVerification,
      };

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value.toString();
    }
    return null;
  }
}
