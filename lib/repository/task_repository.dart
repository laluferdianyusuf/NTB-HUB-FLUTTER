import '../core/api/api_endpoints.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/utils/result.dart';
import '../models/task_model.dart';

class TaskRepository {
  TaskRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<List<TaskModel>>> getTasks() async {
    try {
      final response = await _client.get<List<TaskModel>>(
        ApiEndpoints.listTasks,
        fromJson: _parseTaskList,
      );

      return Success(response.data);
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  List<TaskModel> _parseTaskList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(TaskModel.fromJson)
        .where((task) => task.id.isNotEmpty)
        .toList();
  }
}
