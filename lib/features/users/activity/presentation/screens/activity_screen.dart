import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../database/app_database.dart';
import '../../../../../models/activity_model.dart';
import '../../../../../widgets/common/app_tab_page_header.dart';

final activityListProvider = FutureProvider<List<ActivityModel>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return AppDatabase.instance.activities;
});

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: activitiesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (activities) => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: AppTabPageHeader(title: AppStrings.activity),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                sliver: SliverList.separated(
                  itemCount: activities.length,
                  separatorBuilder: (_, _) => Divider(
                    color: context.adaptiveDivider,
                    height: AppSpacing.xxl,
                  ),
                  itemBuilder: (context, index) =>
                      _ActivityTile(activity: activities[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final ActivityModel activity;

  IconData _iconForType(ActivityType type) {
    return switch (type) {
      ActivityType.groupJoin => Iconsax.people,
      ActivityType.like => Iconsax.heart,
      ActivityType.event => Iconsax.calendar,
      ActivityType.booking => Iconsax.ticket,
      ActivityType.comment => Iconsax.message,
    };
  }

  Color _colorForType(BuildContext context, ActivityType type) {
    return switch (type) {
      ActivityType.groupJoin => context.primaryColor,
      ActivityType.like => AppColors.error,
      ActivityType.event => AppColors.secondary,
      ActivityType.booking => AppColors.success,
      ActivityType.comment => AppColors.star,
    };
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _colorForType(context, activity.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_iconForType(activity.type), color: iconColor, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: context.adaptiveTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                DateFormatter.formatDate(activity.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: context.adaptiveTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
