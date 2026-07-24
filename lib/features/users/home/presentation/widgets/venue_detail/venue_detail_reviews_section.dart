import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/helpers/date_formatter.dart';
import '../../../../../../core/utils/result.dart' as result;
import '../../../../../../models/review_model.dart';
import '../../../../../../widgets/common/app_skeleton.dart';
import '../../providers/venue_detail_provider.dart';
import '../venue_detail_hero.dart';

class VenueDetailReviewsSection extends ConsumerWidget {
  const VenueDetailReviewsSection({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(venueReviewsProvider(venueId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VenueDetailSectionHeader(
          title: 'Ulasan',
          subtitle: 'Pengalaman pengunjung venue ini',
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: reviewsAsync.when(
            loading: () => Column(
              key: const ValueKey('reviews-loading'),
              children: List.generate(
                2,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: index == 1 ? 0 : 12),
                  child: const AppSkeleton(
                    height: 110,
                    width: double.infinity,
                    borderRadius: 16,
                  ),
                ),
              ),
            ),
            error: (_, _) => _ReviewsMessageCard(
              key: const ValueKey('reviews-error'),
              message: 'Gagal memuat ulasan.',
              onRetry: () => ref.invalidate(venueReviewsProvider(venueId)),
            ),
            data: (resultValue) => switch (resultValue) {
              result.Success(:final data) =>
                data.isEmpty
                    ? const _ReviewsMessageCard(
                        key: ValueKey('reviews-empty'),
                        message: 'Belum ada ulasan untuk venue ini.',
                      )
                    : _ReviewsList(
                        key: const ValueKey('reviews-list'),
                        reviews: data,
                      ),
              result.Error(:final failure) => _ReviewsMessageCard(
                key: const ValueKey('reviews-failure'),
                message: failure.message,
                onRetry: () => ref.invalidate(venueReviewsProvider(venueId)),
              ),
            },
          ),
        ),
      ],
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({super.key, required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < reviews.length; i++) ...[
          _ReviewCard(review: reviews[i]),
          if (i < reviews.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.user,
                  size: 18,
                  color: context.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.displayUserName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: context.adaptiveTextPrimary,
                      ),
                    ),
                    if (review.createdAt != null)
                      Text(
                        DateFormatter.formatDate(review.createdAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: context.adaptiveTextSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Iconsax.star1, size: 14, color: AppColors.star),
                  const SizedBox(width: 4),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.adaptiveTextPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.displayComment,
            style: TextStyle(
              color: context.adaptiveTextSecondary,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsMessageCard extends StatelessWidget {
  const _ReviewsMessageCard({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: TextStyle(color: context.adaptiveTextSecondary)),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: Icon(Iconsax.refresh, size: 16),
              label: const Text('Muat Ulang'),
            ),
          ],
        ],
      ),
    );
  }
}
