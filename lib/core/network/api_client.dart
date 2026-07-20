import 'dio_client.dart';

/// Legacy wrapper — gunakan [DioClient] untuk semua HTTP request.
@Deprecated('Use DioClient instead')
class ApiClient {
  ApiClient({required DioClient client}) : _client = client;

  final DioClient _client;

  DioClient get dio => _client;
}
