import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/repository/repository_exception_mapper.dart';
import '../core/utils/result.dart';
import '../models/venue_model.dart';
import '../models/venue_service_model.dart';

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

      return Success(
        venues.where((venue) => venue.isActive).toList(),
      );
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

  Future<Result<List<VenueServiceModel>>> getVenueServices(
    String venueId, {
    VenueServiceQuery query = const VenueServiceQuery(isActive: true),
  }) async {
    try {
      final response = await _client.get<List<VenueServiceModel>>(
        ApiEndpoints.venueServices(venueId),
        queryParameters: query.toQueryParameters(),
        fromJson: _parseVenueServiceList,
      );

      final services = response.data
          .where((service) => service.isActive && service.id.isNotEmpty)
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });

      return Success(services);
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

  List<VenueServiceModel> _parseVenueServiceList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(VenueServiceModel.fromJson)
        .where((service) => service.id.isNotEmpty)
        .toList();
  }
}
