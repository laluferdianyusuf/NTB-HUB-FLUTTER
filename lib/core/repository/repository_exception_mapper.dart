import '../errors/app_exception.dart';
import '../errors/failure.dart';

Failure mapRepositoryException(AppException error) {
  return switch (error) {
    NetworkException() => NetworkFailure(error.message),
    ServerException() => ServerFailure(error.message),
    NotFoundException() => ServerFailure(error.message),
    UnauthorizedException() => UnauthorizedFailure(error.message),
    _ => UnknownFailure(error.message),
  };
}
