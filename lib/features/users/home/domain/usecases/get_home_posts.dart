import '../entities/post_entity.dart';
import '../repositories/home_repository.dart';

class GetHomePosts {
  const GetHomePosts(this._repository);

  final HomeRepository _repository;

  Future<List<PostEntity>> call() => _repository.getPosts();
}
