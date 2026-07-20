import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../models/interest_model.dart';
import '../../../../../repository/interest_repository.dart';

final interestRepositoryProvider = Provider<InterestRepository>(
  (ref) => InterestRepository(client: ref.watch(dioClientProvider)),
);

final interestsProvider =
    FutureProvider<Result<List<InterestModel>>>((ref) async {
  return ref.read(interestRepositoryProvider).getInterests();
});
