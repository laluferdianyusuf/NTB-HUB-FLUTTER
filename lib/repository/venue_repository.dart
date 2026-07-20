import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/repository/repository_exception_mapper.dart';
import '../core/utils/result.dart';
import '../models/venue_model.dart';

class VenueRepository {
  VenueRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<List<VenueModel>>> getAllVenues() async {
    try {
      final response = await _client.get<List<VenueModel>>(
        ApiEndpoints.allVenues,
        fromJson: _parseVenueList,
      );

      final venues = response.data
        ..sort((a, b) => a.name.compareTo(b.name));

      return Success(venues);
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<VenueModel>> getVenueDetail(String id) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.venueDetail(id),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Success(VenueModel.fromJson(response.data));
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<VenueModel>> getVenueById(String id) async {
    final detailResult = await getVenueDetail(id);
    if (detailResult case Success()) {
      return detailResult;
    }

    final listResult = await getAllVenues();
    if (listResult case Success(:final data)) {
      try {
        return Success(data.firstWhere((venue) => venue.id == id));
      } catch (_) {
        return const Error(UnknownFailure('Venue tidak ditemukan'));
      }
    }

    if (listResult case Error(:final failure)) {
      return Error(failure);
    }

    return const Error(UnknownFailure('Venue tidak ditemukan'));
  }

  List<VenueModel> _parseVenueList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(VenueModel.fromJson)
        .where((venue) => venue.id.isNotEmpty)
        .toList();
  }
}
