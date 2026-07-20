import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';

enum HomeGridCardType { venue, event, publicPlace }

class HomeGridCard extends StatelessWidget {
  const HomeGridCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.type,
    this.rating,
    this.badge,
    this.imageUrl,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String location;
  final HomeGridCardType type;
  final double? rating;
  final String? badge;
  final String? imageUrl;
  final VoidCallback? onTap;

  List<Color> get _gradient => switch (type) {
    HomeGridCardType.venue => [
      const Color(0xFF1B5E4B),
      const Color(0xFF2E8B6E),
    ],
    HomeGridCardType.event => [
      const Color(0xFF0F4C75),
      const Color(0xFF3282B8),
    ],
    HomeGridCardType.publicPlace => [
      const Color(0xFF6A0572),
      const Color(0xFFAB83A1),
    ],
  };

  IconData get _icon => switch (type) {
    HomeGridCardType.venue => Iconsax.buildings,
    HomeGridCardType.event => Iconsax.calendar,
    HomeGridCardType.publicPlace => Iconsax.tree,
  };

  String get _typeLabel => switch (type) {
    HomeGridCardType.venue => 'Venue',
    HomeGridCardType.event => 'Event',
    HomeGridCardType.publicPlace => 'Public Place',
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 92,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: imageUrl == null
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _gradient,
                        )
                      : null,
                  image: imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _icon,
                        color: Colors.white.withValues(
                          alpha: imageUrl == null ? 1 : 0.85,
                        ),
                        size: 32,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _typeLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.location,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (rating != null || badge != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (rating != null) ...[
                              const Icon(
                                Iconsax.star,
                                size: 12,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            if (rating != null && badge != null)
                              const SizedBox(width: 8),
                            if (badge != null)
                              Expanded(
                                child: Text(
                                  badge!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
