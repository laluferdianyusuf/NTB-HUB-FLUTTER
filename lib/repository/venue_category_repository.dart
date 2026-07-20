import '../core/api/api_endpoints.dart';
import '../core/errors/failure.dart';
import '../core/network/dio_client.dart';
import '../core/utils/result.dart';
import '../models/venue_category_model.dart';

class VenueCategoryRepository {
  VenueCategoryRepository({required DioClient client}) : _client = client;

  final DioClient _client;

  Future<Result<List<VenueCategoryModel>>> getCategories() async {
    try {
      final response = await _client.get<List<VenueCategoryModel>>(
        ApiEndpoints.venueCategories,
        fromJson: _parseCategoryList,
      );

      final categories = response.data
          .where((category) => category.isActive)
          .toList();

      return Success(categories);
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  Future<Result<List<VenueSubCategoryModel>>> getSubCategories(
    String categoryId,
  ) async {
    try {
      final response = await _client.get<List<VenueSubCategoryModel>>(
        ApiEndpoints.venueSubCategoriesByCategory(categoryId),
        fromJson: _parseSubCategoryList,
      );

      final subCategories = response.data
          .where((item) => item.isActive)
          .toList();

      return Success(subCategories);
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  List<VenueCategoryModel> _parseCategoryList(dynamic json) {
    if (json is! List) return [];

    return json
        .map(
          (item) => VenueCategoryModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  List<VenueSubCategoryModel> _parseSubCategoryList(dynamic json) {
    if (json is! List) return [];

    return json
        .map(
          (item) =>
              VenueSubCategoryModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
