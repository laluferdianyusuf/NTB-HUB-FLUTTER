import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/interest_icon_mapper.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/interest_model.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../providers/interest_provider.dart';

enum InterestGridStyle { chips, enterprise }

class InterestChipGrid extends ConsumerWidget {
  const InterestChipGrid({
    super.key,
    required this.selectedIds,
    required this.onToggle,
    this.style = InterestGridStyle.chips,
  });

  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;
  final InterestGridStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestsAsync = ref.watch(interestsProvider);

    return interestsAsync.when(
      loading: () => style == InterestGridStyle.enterprise
          ? const _EnterpriseInterestSkeleton()
          : const Wrap(
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
        isDark: style == InterestGridStyle.enterprise,
      ),
      data: (resultValue) => switch (resultValue) {
        result.Success(:final data) => style == InterestGridStyle.enterprise
            ? _EnterpriseInterestGrid(
                interests: data,
                selectedIds: selectedIds,
                onToggle: onToggle,
              )
            : _InterestChipContent(
                interests: data,
                selectedIds: selectedIds,
                onToggle: onToggle,
              ),
        result.Error(:final failure) => _InterestError(
          message: failure.message,
          onRetry: () => ref.invalidate(interestsProvider),
          isDark: style == InterestGridStyle.enterprise,
        ),
      },
    );
  }
}

class _EnterpriseInterestSkeleton extends StatelessWidget {
  const _EnterpriseInterestSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const AppSkeleton(borderRadius: 18),
    );
  }
}

class _EnterpriseInterestGrid extends StatelessWidget {
  const _EnterpriseInterestGrid({
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
      return Text(
        'Minat belum tersedia',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: interests.length,
      itemBuilder: (context, index) {
        final interest = interests[index];
        final isSelected = selectedIds.contains(interest.id);
        final accent = interest.color;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onToggle(interest.id),
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isSelected
                    ? accent.withValues(alpha: 0.88)
                    : Colors.white.withValues(alpha: 0.12),
                border: Border.all(
                  color: isSelected
                      ? accent
                      : Colors.white.withValues(alpha: 0.24),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  if (isSelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: accent,
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.22)
                              : accent.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          InterestIconMapper.iconForName(interest.name),
                          color: isSelected ? Colors.white : accent,
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        interest.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          fontSize: 14,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
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
  const _InterestError({
    required this.message,
    required this.onRetry,
    this.isDark = false,
  });

  final String message;
  final VoidCallback onRetry;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark
                ? Colors.white.withValues(alpha: 0.75)
                : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onRetry,
          style: TextButton.styleFrom(
            foregroundColor: isDark ? Colors.white : AppColors.primary,
          ),
          child: const Text('Coba Lagi'),
        ),
      ],
    );
  }
}
