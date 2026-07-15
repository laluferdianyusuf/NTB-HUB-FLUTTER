import '../entities/post_entity.dart';

abstract interface class HomeRepository {
  Future<List<PostEntity>> getPosts();
}
