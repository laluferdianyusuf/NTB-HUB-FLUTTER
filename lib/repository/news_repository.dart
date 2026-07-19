import '../core/api/api_endpoints.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/utils/result.dart';
import '../models/news_model.dart';

class NewsRepository {
  NewsRepository({DioClient? client}) : _client = client ?? DioClient();

  final DioClient _client;

  Future<Result<List<NewsModel>>> getAllNews() async {
    try {
      final response = await _client.get<List<NewsModel>>(
        ApiEndpoints.allNews,
        fromJson: _parseNewsList,
      );

      final news = response.data
        ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      return Success(news);
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  Future<Result<NewsModel>> getNewsById(String id) async {
    final result = await getAllNews();

    if (result case Success(:final data)) {
      try {
        return Success(data.firstWhere((news) => news.id == id));
      } catch (_) {
        return const Error(UnknownFailure('Berita tidak ditemukan'));
      }
    }

    if (result case Error(:final failure)) {
      return Error(failure);
    }

    return const Error(UnknownFailure('Berita tidak ditemukan'));
  }

  List<NewsModel> _parseNewsList(dynamic json) {
    return JsonFieldHelper.readObjectList(json)
        .map(NewsModel.fromJson)
        .where((news) => news.id.isNotEmpty)
        .toList();
  }
}
