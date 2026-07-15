import '../core/api/api_endpoints.dart';
import '../core/errors/failure.dart';
import '../core/network/dio_client.dart';
import '../core/services/mock_data_service.dart';
import '../core/storage/local_storage.dart';
import '../core/utils/result.dart';
import '../models/auth_model.dart';

class AuthRepository {
  AuthRepository({
    DioClient? client,
    LocalStorage? storage,
  }) : _storage = storage ?? LocalStorage() {
    _client = client ?? DioClient(storage: _storage);
  }

  late final DioClient _client;
  final LocalStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  Future<Result<AuthModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final auth = AuthModel.fromJson(response.data);
      await _saveSession(auth);
      return Success(auth);
    } catch (_) {
      return _demoLogin(email, password);
    }
  }

  Future<Result<AuthModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final auth = AuthModel.fromJson(response.data);
      await _saveSession(auth);
      return Success(auth);
    } catch (_) {
      return _demoRegister(name, email, password);
    }
  }

  Future<Result<AuthModel>> loginWithGoogle({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.googleLogin,
        data: payload,
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final auth = AuthModel.fromJson(response.data);
      await _saveSession(auth);
      return Success(auth);
    } catch (_) {
      return _demoGoogleLogin(payload);
    }
  }

  Future<Result<void>> saveUserInterests(List<String> interests) async {
    try {
      await _client.post<void>(
        ApiEndpoints.userInterests,
        data: {'interests': interests},
      );
      return const Success(null);
    } catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return const Success(null);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _client.post<void>(ApiEndpoints.logout);
    } catch (_) {
      // Lanjut clear session lokal meski API gagal
    }

    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);
    return const Success(null);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read<String>(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<AuthModel?> getCurrentAuth() async {
    final data = await _storage.read<Map<String, dynamic>>(_userKey);
    if (data == null) return null;
    return AuthModel.fromJson(data);
  }

  Future<void> _saveSession(AuthModel auth) async {
    await _storage.save(_tokenKey, auth.token);
    await _storage.save(_userKey, auth.toJson());
  }

  Future<Result<AuthModel>> _demoLogin(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (email.isEmpty || password.length < 6) {
      return const Error(
        UnknownFailure('Email atau password tidak valid (min. 6 karakter)'),
      );
    }

    final auth = AuthModel(
      token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
      userId: MockDataService.currentUser.id,
      name: MockDataService.currentUser.name,
      email: email,
    );
    await _saveSession(auth);
    return Success(auth);
  }

  Future<Result<AuthModel>> _demoRegister(
    String name,
    String email,
    String password,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (name.isEmpty || email.isEmpty || password.length < 6) {
      return const Error(
        UnknownFailure('Lengkapi semua field (password min. 6 karakter)'),
      );
    }

    final auth = AuthModel(
      token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
      userId: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
    );
    await _saveSession(auth);
    return Success(auth);
  }

  Future<Result<AuthModel>> _demoGoogleLogin(
    Map<String, dynamic> payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final email = payload['email'] as String? ?? '';
    final name = payload['name'] as String? ?? 'Google User';

    if (email.isEmpty) {
      return const Error(
        UnknownFailure('Data akun Google tidak valid'),
      );
    }

    final auth = AuthModel(
      token: 'demo_google_token_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'google_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
    );
    await _saveSession(auth);
    return Success(auth);
  }
}
