sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Koneksi jaringan bermasalah']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal mengakses data lokal']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server mengalami gangguan']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Terjadi kesalahan tidak terduga']);
}
