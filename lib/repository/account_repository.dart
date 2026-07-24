import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/network/dio_client.dart';
import '../core/repository/repository_exception_mapper.dart';
import '../core/utils/result.dart';
import '../models/financial_model.dart';
import '../models/wallet_model.dart';

class AccountRepository {
  AccountRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<Account>> ensureAccount(EnsureAccountPayload payload) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        ApiEndpoints.accountEnsure,
        data: payload.toJson(),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Success(Account.fromJson(response.data));
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }
}
