import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../models/venue_model.dart';

class VenueDetailOverviewSection extends StatelessWidget {
  const VenueDetailOverviewSection({super.key, required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venue.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            Row(
              children: [
                if (venue.averageRating > 0)
                  Row(
                    children: [
                      Icon(Iconsax.star1, size: 16, color: AppColors.star),
                      Text(' ${venue.rating}  '),
                      Text(
                        '${venue.totalReviews} Reviews',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                const SizedBox(width: 8),
                if (venue.totalViews > 0)
                  Row(
                    children: [
                      Icon(Iconsax.eye4, size: 16, color: AppColors.info),
                      Text(' ${venue.totalViews}  '),
                      Text(
                        'Impressions',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                const SizedBox(width: 8),
                if (venue.totalLikes > 0)
                  Row(
                    children: [
                      Icon(Iconsax.heart5, size: 16, color: AppColors.error),
                      Text(' ${venue.totalLikes}  '),
                      Text(
                        'Likes',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Iconsax.location,
              size: 18,
              color: context.adaptiveTextSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                venue.location,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: context.adaptiveTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
