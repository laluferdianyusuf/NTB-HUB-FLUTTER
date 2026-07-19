import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/venue_category_model.dart';
import '../../../../../repository/venue_category_repository.dart';
import '../../../../../core/utils/result.dart';

final venueCategoryRepositoryProvider = Provider<VenueCategoryRepository>(
  (ref) => VenueCategoryRepository(),
);

final venueCategoriesProvider =
    FutureProvider<Result<List<VenueCategoryModel>>>((ref) async {
  return ref.read(venueCategoryRepositoryProvider).getCategories();
});

final venueSubCategoriesProvider = FutureProvider.family<
    Result<List<VenueSubCategoryModel>>,
    String>((ref, categoryId) async {
  return ref.read(venueCategoryRepositoryProvider).getSubCategories(categoryId);
});
