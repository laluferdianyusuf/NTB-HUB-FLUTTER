import '../core/errors/failure.dart';
import '../core/helpers/pagination_helper.dart';
import '../core/utils/result.dart';
import '../database/app_database.dart';
import '../models/news_model.dart';

class NewsRepository {
  NewsRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;
  static const int pageSize = 10;

  Future<Result<List<NewsModel>>> getNewsList() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return Success(_database.news);
    } catch (e) {
      return const Error(ServerFailure());
    }
  }

  Future<PaginationResult<NewsModel>> getNewsPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return PaginationHelper.paginate(
      _database.news,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<Result<NewsModel>> getNewsById(String id) async {
    try {
      final news = _database.news.firstWhere((n) => n.id == id);
      return Success(news);
    } catch (e) {
      return const Error(UnknownFailure('Berita tidak ditemukan'));
    }
  }
}
