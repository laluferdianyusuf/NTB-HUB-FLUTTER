import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ntbhub_flutter/widgets/common/app_image.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../models/venue_model.dart';

class VenueDetailSliverHeader extends StatelessWidget {
  const VenueDetailSliverHeader({
    super.key,
    required this.venue,
    this.expandedHeight = 280,
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
      foregroundColor: AppColors.textPrimaryLight,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: const SizedBox.shrink(),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: _HeroIconButton(
          icon: Iconsax.arrow_left_3,
          onPressed: () => context.pop(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: PageView.builder(
          itemCount: venue.allImages.isEmpty ? 1 : venue.allImages.length,
          itemBuilder: (_, index) => AppImage(
            source: venue.allImages.isEmpty
                ? (venue.imageUrl ?? '')
                : venue.allImages[index],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
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
            errorBuilder: (_, _, _) => const _FallbackBackdrop(),
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
                  color: context.primaryColor.withValues(alpha: 0.85),
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
                style: TextStyle(
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
          child: Icon(icon, size: 20, color: context.adaptiveTextPrimary),
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
      if (venue.averageRating > 0)
        _VenueStatData(
          icon: Iconsax.star,
          label: 'Rating',
          value: venue.averageRating.toStringAsFixed(1),
        ),
      if (venue.totalReviews > 0)
        _VenueStatData(
          icon: Iconsax.message_text,
          label: 'Ulasan',
          value: '${venue.totalReviews}',
        ),
      if (venue.totalLikes > 0)
        _VenueStatData(
          icon: Iconsax.heart,
          label: 'Suka',
          value: '${venue.totalLikes}',
        ),
      if (venue.totalViews > 0)
        _VenueStatData(
          icon: Iconsax.eye,
          label: 'Dilihat',
          value: '${venue.totalViews}',
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
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
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
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, size: 18, color: context.primaryColor),
          ),
          const Spacer(),
          Text(
            data.label,
            style: TextStyle(
              color: context.adaptiveTextSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.adaptiveTextPrimary,
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
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: context.adaptiveTextPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              color: context.adaptiveTextSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}
