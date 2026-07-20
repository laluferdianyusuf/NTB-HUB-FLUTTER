import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';
import '../logger/app_logger.dart';
import '../storage/local_storage.dart';
import '../storage/storage_provider.dart';
import 'api_response.dart';
import 'dio_interceptor.dart';
import 'session_expired_handler.dart';

class DioClient {
  DioClient({
    Dio? dio,
    required LocalStorage storage,
  }) : _storage = storage {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.connectTimeout,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

    _refreshInterceptor = RefreshInterceptor(
      dio: _dio,
      storage: _storage,
      onSessionExpired: notifySessionExpired,
    );

    _dio.interceptors.addAll([
      AuthInterceptor(storage: _storage),
      _refreshInterceptor,
      LoggingInterceptor(),
    ]);
  }

  late final Dio _dio;
  late final RefreshInterceptor _refreshInterceptor;
  final LocalStorage _storage;

  Dio get instance => _dio;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _mapResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _mapResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _mapResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _mapResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _mapResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> upload<T>(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options ??
            Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return _mapResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<File> download(
    String url,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
      return File(savePath);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      );
      return _mapResponse(response, fromJson);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiResponse<T> _mapResponse<T>(
    Response<dynamic> response,
    T Function(dynamic json)? fromJson,
  ) {
    final statusCode = response.statusCode ?? 0;
    final rawData = response.data;

    if (fromJson == null) {
      return ApiResponse(
        data: rawData as T,
        statusCode: statusCode,
        message: response.statusMessage,
      );
    }

    if (rawData is Map<String, dynamic>) {
      final payload = rawData.containsKey('data') ? rawData['data'] : rawData;
      return ApiResponse(
        data: fromJson(payload),
        statusCode: statusCode,
        message: rawData['message'] as String? ?? response.statusMessage,
      );
    }

    if (rawData is List) {
      return ApiResponse(
        data: fromJson(rawData),
        statusCode: statusCode,
        message: response.statusMessage,
      );
    }

    return ApiResponse(
      data: fromJson(rawData),
      statusCode: statusCode,
      message: response.statusMessage,
    );
  }

  AppException _handleError(DioException error) {
    AppLogger.error('DioException', error.message);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException('Koneksi timeout atau tidak tersedia');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data);
        if (statusCode == 404) {
          return NotFoundException(message);
        }
        if (statusCode == 401) {
          return UnauthorizedException(message);
        }
        return ServerException(message);
      case DioExceptionType.cancel:
        return const NetworkException('Request dibatalkan');
      default:
        return NetworkException(error.message ?? 'Koneksi jaringan bermasalah');
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return (data['message'] as String?) ??
          (data['error'] as String?) ??
          'Server mengalami gangguan';
    }
    return 'Server mengalami gangguan';
  }
}

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(storage: ref.watch(localStorageProvider));
});
