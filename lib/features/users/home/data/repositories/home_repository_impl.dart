import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({HomeLocalDatasource? datasource})
      : _datasource = datasource ?? HomeLocalDatasource();

  final HomeLocalDatasource _datasource;

  @override
  Future<List<PostEntity>> getPosts() async {
    final models = await _datasource.getPosts();
    return models
        .map(
          (model) => PostEntity(
            id: model.id,
            authorName: model.authorName,
            content: model.content,
            likes: model.likes,
            comments: model.comments,
            createdAt: model.createdAt,
          ),
        )
        .toList();
  }
}
