sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Koneksi jaringan bermasalah']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Gagal mengakses data lokal']);
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server mengalami gangguan']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Data tidak ditemukan']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Sesi tidak valid']);
}
