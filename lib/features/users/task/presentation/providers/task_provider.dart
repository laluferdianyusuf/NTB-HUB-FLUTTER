import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/task_model.dart';
import '../../../../../repository/task_repository.dart';
import '../../../../../core/utils/result.dart';

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(),
);

final tasksProvider = FutureProvider<Result<List<TaskModel>>>((ref) async {
  return ref.read(taskRepositoryProvider).getTasks();
});
