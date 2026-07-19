import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Color.lerp(
              AppColors.divider,
              AppColors.divider.withValues(alpha: 0.45),
              _controller.value,
            ),
          ),
        );
      },
    );
  }
}

class AppGridSkeleton extends StatelessWidget {
  const AppGridSkeleton({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.aspectRatio = 0.72,
  });

  final int itemCount;
  final int crossAxisCount;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: aspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => const _GridCardSkeleton(),
    );
  }
}

class _GridCardSkeleton extends StatelessWidget {
  const _GridCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppSkeleton(height: 92, borderRadius: 14),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(height: 14, width: double.infinity),
                SizedBox(height: 8),
                AppSkeleton(height: 10, width: 100),
                SizedBox(height: 12),
                AppSkeleton(height: 10, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppListSkeleton extends StatelessWidget {
  const AppListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: const [
            AppSkeleton(width: 48, height: 48, borderRadius: 12),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeleton(height: 14, width: double.infinity),
                  SizedBox(height: 8),
                  AppSkeleton(height: 10, width: 180),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDetailSkeleton extends StatelessWidget {
  const AppDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppSkeleton(height: 220, width: double.infinity, borderRadius: 16),
          SizedBox(height: 20),
          AppSkeleton(height: 24, width: 240),
          SizedBox(height: 12),
          AppSkeleton(height: 14, width: 160),
          SizedBox(height: 24),
          AppSkeleton(height: 80, width: double.infinity, borderRadius: 12),
          SizedBox(height: 16),
          AppSkeleton(height: 14, width: double.infinity),
          SizedBox(height: 8),
          AppSkeleton(height: 14, width: double.infinity),
          SizedBox(height: 8),
          AppSkeleton(height: 14, width: 280),
        ],
      ),
    );
  }
}
