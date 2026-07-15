import '../network/dio_client.dart';

/// Legacy wrapper — gunakan [DioClient] untuk semua HTTP request.
@Deprecated('Use DioClient instead')
class ApiClient {
  ApiClient({DioClient? client}) : _client = client ?? DioClient();

  final DioClient _client;

  DioClient get dio => _client;
}
