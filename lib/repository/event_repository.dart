import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/repository/repository_exception_mapper.dart';
import '../core/utils/result.dart';
import '../models/home_event_model.dart';

class EventRepository {
  EventRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<List<HomeEventModel>>> getAllEvents() async {
    try {
      final response = await _client.get<List<HomeEventModel>>(
        ApiEndpoints.allEvents,
        fromJson: _parseEventList,
      );

      final events = response.data
        ..sort((a, b) => a.date.compareTo(b.date));

      return Success(events);
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<HomeEventModel>> getEventDetail(String id) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.eventDetail(id),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Success(HomeEventModel.fromJson(response.data));
    } on AppException catch (error) {
      return Error(mapRepositoryException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<HomeEventModel>> getEventById(String id) async {
    final detailResult = await getEventDetail(id);
    if (detailResult case Success()) {
      return detailResult;
    }

    final listResult = await getAllEvents();
    if (listResult case Success(:final data)) {
      try {
        return Success(data.firstWhere((event) => event.id == id));
      } catch (_) {
        return const Error(UnknownFailure('Event tidak ditemukan'));
      }
    }

    if (listResult case Error(:final failure)) {
      return Error(failure);
    }

    return const Error(UnknownFailure('Event tidak ditemukan'));
  }

  List<HomeEventModel> _parseEventList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(HomeEventModel.fromJson)
        .where((event) => event.id.isNotEmpty)
        .toList();
  }
}
