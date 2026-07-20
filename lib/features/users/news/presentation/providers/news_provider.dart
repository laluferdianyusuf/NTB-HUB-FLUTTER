import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../models/news_model.dart';
import '../../../../../repository/news_repository.dart';
import '../../../../../core/utils/result.dart';

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepository(client: ref.watch(dioClientProvider)),
);

final newsListProvider = FutureProvider<Result<List<NewsModel>>>((ref) async {
  return ref.read(newsRepositoryProvider).getAllNews();
});

final newsDetailProvider =
    FutureProvider.family<Result<NewsModel>, String>((ref, id) async {
  return ref.read(newsRepositoryProvider).getNewsDetail(id);
});
