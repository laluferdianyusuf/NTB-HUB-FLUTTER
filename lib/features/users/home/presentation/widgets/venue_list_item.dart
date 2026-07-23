import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../models/venue_model.dart';

class VenueListItem extends StatelessWidget {
  const VenueListItem({super.key, required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.adaptiveDivider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Iconsax.buildings,
                color: context.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 14,
                        color: context.adaptiveTextSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.location,
                          style: TextStyle(
                            color: context.adaptiveTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _buildSubtitle(venue),
                    style: TextStyle(
                      color: context.adaptiveTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Iconsax.star, color: AppColors.secondary, size: 16),
                Text(
                  venue.averageRating.toStringAsFixed(1),
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle(VenueModel venue) {
    final parts = <String>[];
    if (venue.city.isNotEmpty) parts.add(venue.city);
    if (venue.province.isNotEmpty && venue.province != venue.city) {
      parts.add(venue.province);
    }
    if (venue.totalReviews > 0) {
      parts.add('${venue.totalReviews} ulasan');
    }
    return parts.isEmpty ? venue.location : parts.join(' · ');
  }
}
