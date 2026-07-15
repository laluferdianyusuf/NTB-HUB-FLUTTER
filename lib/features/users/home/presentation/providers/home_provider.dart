import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_posts.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(),
);

final getHomePostsProvider = Provider<GetHomePosts>(
  (ref) => GetHomePosts(ref.watch(homeRepositoryProvider)),
);

class HomeNotifier extends AsyncNotifier<List<PostEntity>> {
  @override
  Future<List<PostEntity>> build() {
    return ref.read(getHomePostsProvider)();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(getHomePostsProvider)());
  }
}

final homeProvider =
    AsyncNotifierProvider<HomeNotifier, List<PostEntity>>(HomeNotifier.new);
