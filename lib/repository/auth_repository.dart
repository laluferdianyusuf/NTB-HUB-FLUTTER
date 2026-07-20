import 'package:dio/dio.dart';

import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/network/dio_client.dart';
import '../core/storage/local_storage.dart';
import '../core/utils/result.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository({
    required DioClient client,
    required LocalStorage storage,
  })  : _client = client,
        _storage = storage;

  final DioClient _client;
  final LocalStorage _storage;

  static const tokenKey = 'auth_token';
  static const refreshTokenKey = 'refresh_token';
  static const userKey = 'auth_user';

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
      final pendingVerification = auth.requiresEmailVerification ||
          (!auth.emailVerified && auth.token == null);

      if (pendingVerification) {
        return Success(
          auth.copyWith(
            email: email,
            requiresEmailVerification: true,
          ),
        );
      }

      await _saveSession(auth);
      return _finalizeSession(auth);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
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
        data: {
          'username': _generateUsername(email, name),
          'name': name,
          'email': email,
          'password': password,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final auth = AuthModel.fromJson(response.data).copyWith(
        email: email,
        name: name,
        requiresEmailVerification: true,
      );

      return Success(auth);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<AuthModel>> verifyEmail({
    required String userId,
    required String pin,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.verifyEmail,
        data: {
          'userId': userId,
          'pin': pin,
        },
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final auth = AuthModel.fromJson(response.data).copyWith(
        userId: userId,
        emailVerified: true,
        requiresEmailVerification: false,
      );

      await _saveSession(auth);
      return _finalizeSession(auth);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<void>> resendVerification({required String email}) async {
    try {
      await _client.post<void>(
        ApiEndpoints.resendVerification,
        data: {'email': email},
      );
      return const Success(null);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<AuthModel>> getMe() async {
    try {
      final token = await _storage.read<String>(tokenKey);
      if (token == null || token.isEmpty) {
        return const Error(
          UnauthorizedFailure('Token tidak ditemukan. Silakan login ulang.'),
        );
      }

      final response = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.me,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final auth = AuthModel.fromJson(response.data);
      final currentAuth = await getCurrentAuth();
      final currentToken = await _storage.read<String>(tokenKey);
      final currentRefreshToken =
          await _storage.read<String>(refreshTokenKey);

      final hydrated = auth.copyWith(
        token: auth.token ?? currentToken,
        refreshToken: auth.refreshToken ?? currentRefreshToken,
        avatarUrl: auth.avatarUrl ?? currentAuth?.avatarUrl,
        emailVerified: true,
        requiresEmailVerification: false,
      );

      if (hydrated.isAuthenticated) {
        await _saveSession(hydrated);
      }

      return Success(hydrated);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<UserModel>> fetchMeUser() async {
    final meResult = await getMe();
    return switch (meResult) {
      Success(:final data) => Success(UserModel.fromAuth(data)),
      Error(:final failure) => Error(failure),
    };
  }

  Future<Result<AuthModel>> _finalizeSession(AuthModel auth) async {
    final token = auth.token ?? await _storage.read<String>(tokenKey);
    if (token == null || token.isEmpty) {
      return Success(auth);
    }

    final meResult = await getMe();
    if (meResult case Success(:final data)) {
      await _saveSession(data);
      return Success(data);
    }
    return Success(auth);
  }

  Future<Result<AuthModel>> refreshToken() async {
    try {
      final refreshToken = await _storage.read<String>(refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        return const Error(
          UnknownFailure('Refresh token tidak ditemukan'),
        );
      }

      final response = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      final currentAuth = await getCurrentAuth();
      final auth = AuthModel.fromJson(response.data).copyWith(
        userId: currentAuth?.userId ?? '',
        name: currentAuth?.name ?? '',
        email: currentAuth?.email ?? '',
        username: currentAuth?.username,
        emailVerified: true,
        requiresEmailVerification: false,
      );

      await _saveSession(auth);
      return Success(auth);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
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

      final auth = _googleAuthFromResponse(response.data, payload);
      await _saveSession(auth);
      return _finalizeSession(auth);
    } on AppException catch (error) {
      return _googleLoginFallback(payload, _mapException(error));
    } catch (error) {
      return _googleLoginFallback(payload, UnknownFailure(error.toString()));
    }
  }

  AuthModel _googleAuthFromResponse(
    Map<String, dynamic> data,
    Map<String, dynamic> payload,
  ) {
    final parsed = AuthModel.fromJson(data);
    return parsed.copyWith(
      email: payload['email'] as String? ?? parsed.email,
      name: payload['name'] as String? ?? parsed.name,
      userId: payload['googleId'] as String? ?? parsed.userId,
      emailVerified: true,
      requiresEmailVerification: false,
    );
  }

  Future<Result<AuthModel>> _googleLoginFallback(
    Map<String, dynamic> payload,
    Failure apiFailure,
  ) async {
    return Error(apiFailure);
  }

  Future<Result<void>> logout() async {
    try {
      await _client.post<void>(ApiEndpoints.logout);
    } catch (_) {
      // Lanjut clear session lokal meski API gagal
    }

    await _clearSession();
    return const Success(null);
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read<String>(tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<AuthModel?> getCurrentAuth() async {
    final data = await _storage.read<Map<String, dynamic>>(userKey);
    if (data == null) return null;
    return AuthModel.fromJson(data);
  }

  Future<void> _saveSession(AuthModel auth) async {
    final existingToken = await _storage.read<String>(tokenKey);
    final existingRefreshToken =
        await _storage.read<String>(refreshTokenKey);
    final existingAuth = await getCurrentAuth();

    final token = (auth.token != null && auth.token!.isNotEmpty)
        ? auth.token
        : existingToken;
    final refreshToken =
        (auth.refreshToken != null && auth.refreshToken!.isNotEmpty)
            ? auth.refreshToken
            : existingRefreshToken;
    final avatarUrl = (auth.avatarUrl != null && auth.avatarUrl!.isNotEmpty)
        ? auth.avatarUrl
        : existingAuth?.avatarUrl;

    if (token != null && token.isNotEmpty) {
      await _storage.save(tokenKey, token);
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _storage.save(refreshTokenKey, refreshToken);
    }

    final session = auth.copyWith(
      token: token,
      refreshToken: refreshToken,
      avatarUrl: avatarUrl,
    );
    await _storage.save(userKey, session.toJson());
  }

  Future<void> _clearSession() async {
    await _storage.remove(tokenKey);
    await _storage.remove(refreshTokenKey);
    await _storage.remove(userKey);
  }

  String _generateUsername(String email, String name) {
    final fromEmail = email.split('@').first.replaceAll(
          RegExp(r'[^a-zA-Z0-9_]'),
          '',
        );
    if (fromEmail.length >= 3) return fromEmail.toLowerCase();

    final fromName = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '')
        .replaceAll(RegExp(r'_+'), '_');

    if (fromName.length >= 3) return fromName;
    return 'user${DateTime.now().millisecondsSinceEpoch}';
  }

  Failure _mapException(AppException error) {
    return switch (error) {
      NetworkException() => NetworkFailure(error.message),
      ServerException() => ServerFailure(error.message),
      NotFoundException() => ServerFailure(error.message),
      UnauthorizedException() => UnauthorizedFailure(error.message),
      _ => UnknownFailure(error.message),
    };
  }
}
