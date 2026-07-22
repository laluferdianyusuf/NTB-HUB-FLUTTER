import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../models/venue_model.dart';

class VenueDetailSliverHeader extends StatelessWidget {
  const VenueDetailSliverHeader({
    super.key,
    required this.venue,
    this.expandedHeight = 360,
  });

  final VenueModel venue;
  final double expandedHeight;

  static const _fallbackGradient = [Color(0xFF1B5E4B), Color(0xFF2E8B6E)];

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      stretch: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: const SizedBox.shrink(),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: _HeroIconButton(
          icon: Iconsax.arrow_left_2_copy,
          onPressed: () => context.pop(),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final currentHeight = constraints.biggest.height;
          final collapsedHeight = kToolbarHeight + topPadding;
          final expandRange = expandedHeight - collapsedHeight;
          final expandRatio = expandRange <= 0
              ? 0.0
              : ((currentHeight - collapsedHeight) / expandRange).clamp(
                  0.0,
                  1.0,
                );
          final collapseProgress = 1 - expandRatio;
          final headerReveal = ((collapseProgress - 0.55) / 0.45).clamp(
            0.0,
            1.0,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              _HeroBackdrop(venue: venue),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: collapsedHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: headerReveal),
                    border: headerReveal > 0.95
                        ? Border(
                            bottom: BorderSide(
                              color: AppColors.divider.withValues(
                                alpha: headerReveal,
                              ),
                            ),
                          )
                        : null,
                    boxShadow: headerReveal > 0.95
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              Positioned(
                top: topPadding,
                left: 65,
                right: 16,
                height: kToolbarHeight,
                child: Opacity(
                  opacity: headerReveal,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      venue.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    final imageUrl = venue.imageUrl?.trim();

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imageUrl != null && imageUrl.isNotEmpty)
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _FallbackBackdrop(),
          )
        else
          const _FallbackBackdrop(),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x73000000), Color(0x12000000), Color(0xE6000000)],
              stops: [0, 0.42, 1],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 36,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Venue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                venue.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.12,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Iconsax.location,
                    size: 15,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      venue.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FallbackBackdrop extends StatelessWidget {
  const _FallbackBackdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: VenueDetailSliverHeader._fallbackGradient,
        ),
      ),
      child: Center(
        child: Icon(Iconsax.buildings, size: 80, color: Colors.white24),
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      shadowColor: Colors.black26,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class VenueDetailStatGrid extends StatelessWidget {
  const VenueDetailStatGrid({super.key, required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    final stats = <_VenueStatData>[
      if (venue.capacity > 0)
        _VenueStatData(
          icon: Iconsax.people,
          label: 'Kapasitas',
          value: '${venue.capacity} orang',
        ),
      if (venue.category.isNotEmpty && venue.category != 'Umum')
        _VenueStatData(
          icon: Iconsax.tag,
          label: 'Kategori',
          value: venue.category,
        ),
      if (venue.priceRange.isNotEmpty)
        _VenueStatData(
          icon: Iconsax.wallet_2,
          label: 'Harga',
          value: venue.priceRange,
        ),
      if (venue.rating > 0)
        _VenueStatData(
          icon: Iconsax.star,
          label: 'Rating',
          value: venue.rating.toStringAsFixed(1),
        ),
    ];

    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: stats.length == 1 ? 1 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: stats.length == 1 ? 2.8 : 1.55,
      ),
      itemBuilder: (context, index) => _VenueStatCard(data: stats[index]),
    );
  }
}

class _VenueStatData {
  const _VenueStatData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _VenueStatCard extends StatelessWidget {
  const _VenueStatCard({required this.data});

  final _VenueStatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, size: 18, color: AppColors.primary),
          ),
          const Spacer(),
          Text(
            data.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class VenueDetailSectionHeader extends StatelessWidget {
  const VenueDetailSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}
