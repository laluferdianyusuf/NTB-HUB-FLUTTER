import 'package:dio/dio.dart';

import '../api/api_endpoints.dart';
import '../logger/app_logger.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required LocalStorage storage}) : _storage = storage;

  final LocalStorage _storage;
  static const tokenKey = 'auth_token';

  static const _publicPaths = {
    ApiEndpoints.login,
    ApiEndpoints.register,
    ApiEndpoints.verifyEmail,
    ApiEndpoints.resendVerification,
    ApiEndpoints.refresh,
    ApiEndpoints.googleLogin,
  };

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isPublicPath(options.path)) {
      handler.next(options);
      return;
    }

    final token = await _storage.read<String>(tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  bool _isPublicPath(String path) {
    return _publicPaths.any((endpoint) => path.endsWith(endpoint));
  }
}

class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor({
    required Dio dio,
    required LocalStorage storage,
    this.onSessionExpired,
  })  : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final LocalStorage _storage;
  final Future<void> Function()? onSessionExpired;

  static const tokenKey = 'auth_token';
  static const refreshTokenKey = 'refresh_token';
  static const userKey = 'auth_user';

  bool _isRefreshing = false;
  Future<String?>? _refreshFuture;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRefresh(err)) {
      handler.next(err);
      return;
    }

    if (err.requestOptions.path.endsWith(ApiEndpoints.refresh)) {
      await _clearSession();
      handler.next(err);
      return;
    }

    try {
      final newToken = await _refreshAccessToken();
      if (newToken == null) {
        await _clearSession();
        handler.next(err);
        return;
      }

      final response = await _retryRequest(err.requestOptions, newToken);
      handler.resolve(response);
    } catch (error) {
      if (error is DioException) {
        handler.next(error);
        return;
      }
      handler.next(err);
    }
  }

  bool _shouldRefresh(DioException err) {
    if (err.response?.statusCode != 401) return false;

    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final isExpired = data['isExpired'] == true;
      final message = data['message']?.toString().toLowerCase() ?? '';
      return isExpired ||
          message.contains('expired') ||
          message.contains('invalid token');
    }

    return true;
  }

  Future<String?> _refreshAccessToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture;
    }

    _refreshFuture = _performRefresh();
    try {
      return await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _performRefresh() async {
    if (_isRefreshing) return null;
    _isRefreshing = true;

    try {
      final refreshToken = await _storage.read<String>(refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      final response = await _dio.post<dynamic>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final payload = _extractPayload(response.data);
      if (payload == null) return null;

      final accessToken = _readToken(payload);
      final newRefreshToken = _readRefreshToken(payload) ?? refreshToken;

      if (accessToken == null || accessToken.isEmpty) return null;

      await _storage.save(tokenKey, accessToken);
      await _storage.save(refreshTokenKey, newRefreshToken);

      final userData = await _storage.read<Map<String, dynamic>>(userKey);
      if (userData != null) {
        userData['token'] = accessToken;
        userData['refresh_token'] = newRefreshToken;
        await _storage.save(userKey, userData);
      }

      return accessToken;
    } catch (error) {
      AppLogger.error('Refresh token failed', error);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String accessToken,
  ) {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $accessToken',
      },
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Map<String, dynamic>? _extractPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return null;
  }

  String? _readToken(Map<String, dynamic> json) {
    return json['accessToken'] as String? ??
        json['access_token'] as String? ??
        json['token'] as String?;
  }

  String? _readRefreshToken(Map<String, dynamic> json) {
    return json['refreshToken'] as String? ?? json['refresh_token'] as String?;
  }

  Future<void> _clearSession() async {
    await _storage.remove(tokenKey);
    await _storage.remove(refreshTokenKey);
    await _storage.remove(userKey);
    await onSessionExpired?.call();
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      '→ ${options.method} ${options.uri}',
      options.data,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info(
      '← ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '✕ ${err.requestOptions.method} ${err.requestOptions.uri}',
      err.message,
    );
    handler.next(err);
  }
}
