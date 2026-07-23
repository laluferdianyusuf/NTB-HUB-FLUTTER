import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../database/app_database.dart';
import '../../../../../models/group_model.dart';

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
      body: groupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (groups) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) => _GroupCard(group: groups[index]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.primaryColor,
        onPressed: () {},
        child: Icon(Iconsax.add, color: Colors.white, size: 24),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.adaptiveDivider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
          radius: 28,
          child: Icon(Iconsax.people, color: context.primaryColor, size: 24),
        ),
        title: Text(group.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              group.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              '${group.memberCount} anggota · ${group.category}',
              style: TextStyle(
                color: context.adaptiveTextSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: context.primaryColor,
            side: BorderSide(color: context.primaryColor),
          ),
          child: const Text('Gabung'),
        ),
      ),
    );
  }
}
