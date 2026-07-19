import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/interest_icon_mapper.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/interest_model.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../providers/interest_provider.dart';

class InterestChipGrid extends ConsumerWidget {
  const InterestChipGrid({
    super.key,
    required this.selectedIds,
    required this.onToggle,
  });

  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestsAsync = ref.watch(interestsProvider);

    return interestsAsync.when(
      loading: () => const Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          AppSkeleton(height: 40, width: 120, borderRadius: 20),
          AppSkeleton(height: 40, width: 100, borderRadius: 20),
          AppSkeleton(height: 40, width: 110, borderRadius: 20),
          AppSkeleton(height: 40, width: 90, borderRadius: 20),
          AppSkeleton(height: 40, width: 130, borderRadius: 20),
          AppSkeleton(height: 40, width: 105, borderRadius: 20),
        ],
      ),
      error: (error, _) => _InterestError(
        message: error.toString(),
        onRetry: () => ref.invalidate(interestsProvider),
      ),
      data: (resultValue) => switch (resultValue) {
        result.Success(:final data) => _InterestChipContent(
          interests: data,
          selectedIds: selectedIds,
          onToggle: onToggle,
        ),
        result.Error(:final failure) => _InterestError(
          message: failure.message,
          onRetry: () => ref.invalidate(interestsProvider),
        ),
      },
    );
  }
}

class _InterestChipContent extends StatelessWidget {
  const _InterestChipContent({
    required this.interests,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<InterestModel> interests;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) {
      return const Text(
        'Minat belum tersedia',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: interests.map((interest) {
        final isSelected = selectedIds.contains(interest.id);
        final accent = interest.color;

        return FilterChip(
          selected: isSelected,
          showCheckmark: false,
          avatar: Icon(
            InterestIconMapper.iconForName(interest.name),
            size: 18,
            color: isSelected ? Colors.white : accent,
          ),
          label: Text(interest.name),
          selectedColor: accent,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? accent : accent.withValues(alpha: 0.35),
          ),
          onSelected: (_) => onToggle(interest.id),
        );
      }).toList(),
    );
  }
}

class _InterestError extends StatelessWidget {
  const _InterestError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
      ],
    );
  }
}
