import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/repository/repository_exception_mapper.dart';
import '../core/utils/result.dart';
import '../models/public_place_model.dart';

class PublicPlaceRepository {
  PublicPlaceRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<List<PublicPlaceModel>>> getAllPublicPlaces() async {
    try {
      final response = await _client.get<List<PublicPlaceModel>>(
        ApiEndpoints.allPublicPlaces,
        fromJson: _parsePublicPlaceList,
      );

      final places = response.data
        ..sort((a, b) => a.name.compareTo(b.name));

      return Success(places);
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<PublicPlaceModel>> getPublicPlaceDetail(String id) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.publicPlaceDetail(id),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Success(PublicPlaceModel.fromJson(response.data));
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<PublicPlaceModel>> getPublicPlaceById(String id) async {
    final detailResult = await getPublicPlaceDetail(id);
    if (detailResult case Success()) {
      return detailResult;
    }

    final listResult = await getAllPublicPlaces();
    if (listResult case Success(:final data)) {
      try {
        return Success(data.firstWhere((place) => place.id == id));
      } catch (_) {
        return const Error(UnknownFailure('Public place tidak ditemukan'));
      }
    }

    if (listResult case Error(:final failure)) {
      return Error(failure);
    }

    return const Error(UnknownFailure('Public place tidak ditemukan'));
  }

  List<PublicPlaceModel> _parsePublicPlaceList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(PublicPlaceModel.fromJson)
        .where((place) => place.id.isNotEmpty)
        .toList();
  }
}
