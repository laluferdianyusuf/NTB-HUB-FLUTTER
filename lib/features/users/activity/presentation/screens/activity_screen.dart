import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../database/app_database.dart';
import '../../../../../models/activity_model.dart';

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
      body: activitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (activities) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: activities.length,
          separatorBuilder: (_, _) => Divider(color: context.adaptiveDivider),
          itemBuilder: (context, index) =>
              _ActivityTile(activity: activities[index]),
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

  Color _colorForType(ActivityType type, BuildContext context) {
    return switch (type) {
      ActivityType.groupJoin => context.primaryColor,
      ActivityType.like => Colors.red,
      ActivityType.event => AppColors.secondary,
      ActivityType.booking => Colors.blue,
      ActivityType.comment => Colors.purple,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: _colorForType(
          activity.type,
          context,
        ).withValues(alpha: 0.15),
        child: Icon(
          _iconForType(activity.type),
          color: _colorForType(activity.type, context),
          size: 20,
        ),
      ),
      title: Text(activity.title),
      subtitle: Text(
        DateFormatter.formatRelative(activity.createdAt),
        style: TextStyle(fontSize: 12, color: context.adaptiveTextSecondary),
      ),
    );
  }
}
