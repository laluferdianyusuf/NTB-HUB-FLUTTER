import '../../../../../core/helpers/pagination_helper.dart';
import '../../../../../database/app_database.dart';
import '../../../../../models/post_model.dart';

class HomeLocalDatasource {
  HomeLocalDatasource({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;
  static const int pageSize = 8;

  Future<List<PostModel>> getPosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _database.posts;
  }

  Future<PaginationResult<PostModel>> getPostsPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return PaginationHelper.paginate(
      _database.posts,
      page: page,
      pageSize: pageSize,
    );
  }
}
