import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../database/app_database.dart';
import '../../../../../models/group_model.dart';
import '../../../../../widgets/common/app_surface_card.dart';
import '../../../../../widgets/common/app_tab_page_header.dart';

final groupsListProvider = FutureProvider<List<GroupModel>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  return AppDatabase.instance.groups;
});

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: groupsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (groups) => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: AppTabPageHeader(title: AppStrings.groups),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                sliver: SliverList.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) =>
                      _GroupCard(group: groups[index]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () {},
        child: const Icon(Iconsax.add, color: Colors.white, size: 24),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Iconsax.people, color: context.primaryColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.adaptiveTextPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${group.memberCount} anggota',
                  style: TextStyle(color: context.adaptiveTextSecondary),
                ),
              ],
            ),
          ),
          Icon(Iconsax.arrow_right_3, color: context.adaptiveTextSecondary),
        ],
      ),
    );
  }
}
