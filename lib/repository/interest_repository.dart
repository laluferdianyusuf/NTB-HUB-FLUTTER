import '../core/api/api_endpoints.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/utils/result.dart';
import '../models/interest_model.dart';

class InterestRepository {
  InterestRepository({DioClient? client}) : _client = client ?? DioClient();

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
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  List<InterestModel> _parseInterestList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(InterestModel.fromJson)
        .toList();
  }
}
