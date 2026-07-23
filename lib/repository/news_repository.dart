import '../core/api/api_endpoints.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/failure.dart';
import '../core/helpers/json_field_helper.dart';
import '../core/network/dio_client.dart';
import '../core/utils/result.dart';
import '../models/news_model.dart';

class NewsRepository {
  NewsRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<List<NewsModel>>> getAllNews() async {
    try {
      final response = await _client.get<List<NewsModel>>(
        ApiEndpoints.allNews,
        fromJson: _parseNewsList,
      );

      final news = response.data
        ..sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));

      return Success(news);
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<NewsModel>> getNewsDetail(String id) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        ApiEndpoints.newsDetail(id),
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return Success(NewsModel.fromJson(response.data));
    } on AppException catch (error) {
      return Error(_mapException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Future<Result<NewsModel>> getNewsById(String id) async {
    final detailResult = await getNewsDetail(id);
    if (detailResult case Success()) {
      return detailResult;
    }

    final listResult = await getAllNews();
    if (listResult case Success(:final data)) {
      try {
        return Success(data.firstWhere((news) => news.id == id));
      } catch (_) {
        return const Error(UnknownFailure('Berita tidak ditemukan'));
      }
    }

    if (listResult case Error(:final failure)) {
      return Error(failure);
    }

    return const Error(UnknownFailure('Berita tidak ditemukan'));
  }

  List<NewsModel> _parseNewsList(dynamic json) {
    return JsonFieldHelper.readObjectList(
      json,
    ).map(NewsModel.fromJson).where((news) => news.id.isNotEmpty).toList();
  }

  Failure _mapException(AppException error) {
    return switch (error) {
      NetworkException() => NetworkFailure(error.message),
      ServerException() => ServerFailure(error.message),
      NotFoundException() => ServerFailure(error.message),
      UnauthorizedException() => UnauthorizedFailure(error.message),
      _ => UnknownFailure(error.message),
    };
  }
}
