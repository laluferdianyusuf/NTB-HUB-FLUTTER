import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../models/task_model.dart';
import '../../../../../repository/task_repository.dart';
import '../../../../../core/utils/result.dart';

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(client: ref.watch(dioClientProvider)),
);

final tasksProvider = FutureProvider<Result<List<TaskModel>>>((ref) async {
  return ref.read(taskRepositoryProvider).getTasks();
});
