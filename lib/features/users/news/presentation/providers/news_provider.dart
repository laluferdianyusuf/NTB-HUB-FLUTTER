import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/news_model.dart';
import '../../../../../repository/news_repository.dart';
import '../../../../../core/utils/result.dart';

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepository(),
);

final newsListProvider = FutureProvider<Result<List<NewsModel>>>((ref) async {
  return ref.read(newsRepositoryProvider).getAllNews();
});
