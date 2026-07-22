import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/repository/repository_exception_mapper.dart';
import '../core/utils/result.dart';
import '../models/operational_hours_model.dart';
import '../models/venue_service_model.dart';

class BookingRepository {
  BookingRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<VenueServiceModel>> getServiceDetail(String serviceId) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.venueServiceDetail(serviceId),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Success(VenueServiceModel.fromJson(response.data));
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<OperationalScheduleModel>> getOperationalHours(
    String venueId,
  ) async {
    try {
      final response = await _client.get<OperationalScheduleModel>(
        ApiEndpoints.operationalHoursByVenue(venueId),
        fromJson: (json) => OperationalScheduleModel.fromJson(json),
      );

      return Success(response.data);
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<List<VenueServiceUnitModel>>> getUnitsByService(
    String serviceId,
  ) async {
    try {
      final response = await _client.get<List<VenueServiceUnitModel>>(
        ApiEndpoints.venueUnitsByService(serviceId),
        fromJson: _parseUnitList,
      );

      final units = response.data.where((unit) => unit.isActive).toList();
      return Success(units);
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  List<VenueServiceUnitModel> _parseUnitList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(VenueServiceUnitModel.fromJson)
        .where((unit) => unit.id.isNotEmpty)
        .toList();
  }
}
