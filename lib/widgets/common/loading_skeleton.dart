import 'package:flutter/material.dart';
import 'package:ntbhub_flutter/core/constants/app_strings.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ntbhub_flutter/core/constants/api_constants.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
    );
  }
}

class VenueCardSkeleton extends StatelessWidget {
  const VenueCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppStrings.cardBorderRadius),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingSkeleton(height: 160, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LoadingSkeleton(width: 200, height: 18),
                SizedBox(height: 8),
                LoadingSkeleton(width: 120, height: 14),
                SizedBox(height: 8),
                LoadingSkeleton(width: 80, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        LoadingSkeleton(width: 200, height: 24),
        SizedBox(height: 8),
        LoadingSkeleton(width: 150, height: 16),
        SizedBox(height: 20),
        LoadingSkeleton(height: 48),
        SizedBox(height: 20),
        LoadingSkeleton(height: 160),
        SizedBox(height: 24),
        LoadingSkeleton(width: 120, height: 18),
        SizedBox(height: 12),
        VenueCardSkeleton(),
        VenueCardSkeleton(),
      ],
    );
  }
}
