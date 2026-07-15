import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/onboarding_data.dart';
import '../../../../../core/constants/app_colors.dart';

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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: UserInterests.options.map((option) {
        final isSelected = selectedIds.contains(option.id);

        return FilterChip(
          selected: isSelected,
          showCheckmark: false,
          avatar: Icon(
            option.icon,
            size: 18,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
          label: Text(option.label),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
          onSelected: (_) => onToggle(option.id),
        );
      }).toList(),
    );
  }
}
