import 'package:dio/dio.dart';

import '../logger/app_logger.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({LocalStorage? storage})
      : _storage = storage ?? LocalStorage();

  final LocalStorage _storage;
  static const _tokenKey = 'auth_token';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read<String>(_tokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
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
