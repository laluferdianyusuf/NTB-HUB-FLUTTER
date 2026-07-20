import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/utils/result.dart';
import '../models/interest_model.dart';

class InterestRepository {
  InterestRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<List<InterestModel>>> getInterests() async {
    try {
      final response = await _client.get<List<InterestModel>>(
        ApiEndpoints.interests,
        fromJson: _parseInterestList,
      );

      final interests = response.data
          .where((interest) => interest.id.isNotEmpty)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      return Success(interests);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<void>> updateMyInterests(List<String> interestIds) async {
    try {
      await _client.put<void>(
        ApiEndpoints.updateMyInterests,
        data: {'interests': interestIds},
      );
      return const Success(null);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  List<InterestModel> _parseInterestList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(InterestModel.fromJson)
        .toList();
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