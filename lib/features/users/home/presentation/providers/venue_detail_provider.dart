import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/result.dart';
import '../../../../../models/review_model.dart';
import 'home_content_provider.dart';

final venueReviewsProvider =
    FutureProvider.family<Result<List<Review>>, String>((ref, venueId) async {
      return ref.read(venueRepositoryProvider).getVenueReviews(venueId);
    });

final venueImpressionProvider =
    FutureProvider.family<Result<void>, String>((ref, venueId) async {
      final result =
          await ref.read(venueRepositoryProvider).recordImpression(venueId);

      switch (result) {
        case Success():
          ref.invalidate(venueDetailProvider(venueId));
          return const Success(null);
        case Error(:final failure):
          return Error(failure);
      }
    });
