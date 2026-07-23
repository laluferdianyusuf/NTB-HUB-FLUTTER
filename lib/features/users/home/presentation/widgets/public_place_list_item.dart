import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../models/public_place_model.dart';

class PublicPlaceListItem extends StatelessWidget {
  const PublicPlaceListItem({super.key, required this.place});

  final PublicPlaceModel place;

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
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Iconsax.tree, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${place.typeLabel} · ${place.location}',
                    style: TextStyle(
                      color: context.adaptiveTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Iconsax.star,
                        size: 14,
                        color: AppColors.secondary.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: place.isOpen
                              ? AppColors.success
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.isOpen ? 'Buka' : 'Tutup',
                        style: TextStyle(
                          fontSize: 12,
                          color: place.isOpen
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
