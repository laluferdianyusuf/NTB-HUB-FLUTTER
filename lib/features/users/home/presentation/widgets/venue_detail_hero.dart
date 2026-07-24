import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ntbhub_flutter/widgets/common/app_image.dart';

import '../../../../../widgets/common/app_section_header.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../models/venue_model.dart';
import '../providers/home_content_provider.dart';

class VenueDetailSliverHeader extends ConsumerStatefulWidget {
  const VenueDetailSliverHeader({
    super.key,
    required this.venue,
    this.expandedHeight = 280,
  });

  final VenueModel venue;
  final double expandedHeight;

  static const _fallbackGradient = [Color(0xFF1B5E4B), Color(0xFF2E8B6E)];

  @override
  ConsumerState<VenueDetailSliverHeader> createState() =>
      _VenueDetailSliverHeaderState();
}

class _VenueDetailSliverHeaderState
    extends ConsumerState<VenueDetailSliverHeader> {
  late bool _isLiked = widget.venue.isLiked;
  bool _isTogglingFavorite = false;

  @override
  void didUpdateWidget(covariant VenueDetailSliverHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.venue.id != widget.venue.id ||
        oldWidget.venue.isLiked != widget.venue.isLiked) {
      _isLiked = widget.venue.isLiked;
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isTogglingFavorite) return;

    setState(() => _isTogglingFavorite = true);
    try {
      final result = await ref
          .read(venueRepositoryProvider)
          .toggleVenueLike(widget.venue.id);

      if (!mounted) return;

      switch (result) {
        case Success(:final data):
          setState(() => _isLiked = data.isLiked);
          ref.invalidate(venueDetailProvider(widget.venue.id));
          context.showSnackBar(
            data.isLiked ? 'Added to favorites' : 'Removed from favorites',
          );
        case Error(:final failure):
          context.showSnackBar(failure.message, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isTogglingFavorite = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return SliverAppBar(
      expandedHeight: widget.expandedHeight,
      pinned: true,
      stretch: true,
      backgroundColor: appBarTheme.backgroundColor,
      foregroundColor: appBarTheme.foregroundColor,
      elevation: appBarTheme.elevation ?? 0,
      scrolledUnderElevation: appBarTheme.scrolledUnderElevation ?? 0,
      leadingWidth: 64,

      actions: [
        IconButton(
          icon: Icon(
            _isLiked ? Iconsax.heart5 : Iconsax.heart,
            color: _isLiked ? AppColors.error : null,
          ),
          onPressed: _isTogglingFavorite ? () {} : _toggleFavorite,
        ),
        IconButton(
          icon: const Icon(Iconsax.share),
          onPressed: () => context.showSnackBar('Share link copied'),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _HeroBackdrop(venue: widget.venue),
      ),
    );
  }
}

class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    final images = venue.allImages;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (images.isEmpty)
          const _FallbackBackdrop()
        else
          PageView.builder(
            itemCount: images.length,
            itemBuilder: (_, index) => AppImage(
              source: images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorIcon: Iconsax.buildings,
              placeholder: const _FallbackBackdrop(),
            ),
          ),
        // const DecoratedBox(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       colors: [Color(0x73000000), Color(0x12000000), Color(0xE6000000)],
        //       stops: [0, 0.42, 1],
        //     ),
        //   ),
        // ),
        // Positioned(
        //   left: 20,
        //   right: 20,
        //   bottom: 36,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Container(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 10,
        //           vertical: 5,
        //         ),
        //         decoration: BoxDecoration(
        //           color: context.primaryColor.withValues(alpha: 0.85),
        //           borderRadius: BorderRadius.circular(999),
        //         ),
        //         child: const Text(
        //           'Venue',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 11,
        //             fontWeight: FontWeight.w700,
        //             letterSpacing: 0.5,
        //           ),
        //         ),
        //       ),
        //       const SizedBox(height: 10),
        //       Text(
        //         venue.name,
        //         maxLines: 2,
        //         overflow: TextOverflow.ellipsis,
        //         style: const TextStyle(
        //           color: Colors.white,
        //           fontSize: 30,
        //           fontWeight: FontWeight.w800,
        //           height: 1.12,
        //           letterSpacing: -0.8,
        //         ),
        //       ),
        //       const SizedBox(height: 8),
        //       Row(
        //         children: [
        //           Icon(
        //             Iconsax.location,
        //             size: 15,
        //             color: Colors.white.withValues(alpha: 0.92),
        //           ),
        //           const SizedBox(width: 6),
        //           Expanded(
        //             child: Text(
        //               venue.location,
        //               maxLines: 1,
        //               overflow: TextOverflow.ellipsis,
        //               style: TextStyle(
        //                 color: Colors.white.withValues(alpha: 0.9),
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
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
    return AppSectionHeader(title: title, subtitle: subtitle);
  }
}
