import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/utils/result.dart' as result;
import '../../../../../../models/operational_hours_model.dart';
import '../../../../../../widgets/common/app_skeleton.dart';
import '../../../../booking/presentation/providers/booking_provider.dart';

class VenueDetailOperationalSection extends ConsumerWidget {
  const VenueDetailOperationalSection({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoursAsync = ref.watch(operationalHoursProvider(venueId));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: hoursAsync.when(
        loading: () => const AppSkeleton(
          key: ValueKey('operational-loading'),
          height: 20,
          width: double.infinity,
          borderRadius: 16,
        ),
        error: (_, _) => _OperationalMessageCard(
          key: const ValueKey('operational-error'),
          icon: Iconsax.info_circle,
          message: 'Jam operasional belum tersedia.',
          onRetry: () => ref.invalidate(operationalHoursProvider(venueId)),
        ),
        data: (resultValue) => switch (resultValue) {
          result.Success(:final data) =>
            data.days.isEmpty
                ? const _OperationalMessageCard(
                    key: ValueKey('operational-empty'),
                    icon: Iconsax.clock,
                    message: 'Belum ada jadwal operasional.',
                  )
                : _OperationalScheduleCard(
                    key: const ValueKey('operational-data'),
                    schedule: data,
                  ),
          result.Error(:final failure) => _OperationalMessageCard(
            key: const ValueKey('operational-failure'),
            icon: Iconsax.info_circle,
            message: failure.message,
            onRetry: () => ref.invalidate(operationalHoursProvider(venueId)),
          ),
        },
      ),
    );
  }
}

class _OperationalScheduleCard extends StatelessWidget {
  const _OperationalScheduleCard({super.key, required this.schedule});

  final OperationalScheduleModel schedule;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todaySchedule = schedule.scheduleFor(today);

    return Container(
      // width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      // decoration: BoxDecoration(
      //   color: todaySchedule != null && todaySchedule.isOpen
      //       ? AppColors.success.withValues(alpha: 0.1)
      //       : AppColors.error.withValues(alpha: 0.08),
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: Row(
        children: [
          Icon(
            todaySchedule != null && todaySchedule.isOpen
                ? Iconsax.tick_circle
                : Iconsax.close_circle,
            size: 18,
            color: todaySchedule != null && todaySchedule.isOpen
                ? AppColors.success
                : AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _todayLabel(todaySchedule),
              style: TextStyle(
                color: todaySchedule != null && todaySchedule.isOpen
                    ? AppColors.success
                    : AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _todayLabel(OperationalDayModel? todaySchedule) {
    if (todaySchedule == null || !todaySchedule.isOpen) {
      return 'Tutup hari ini';
    }
    return 'Buka hari ini ${todaySchedule.openTime} - ${todaySchedule.closeTime}';
  }
}

class _OperationalMessageCard extends StatelessWidget {
  const _OperationalMessageCard({
    super.key,
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.adaptiveTextSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: context.adaptiveTextSecondary),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: Icon(Iconsax.refresh, size: 16),
              label: const Text('Muat Ulang'),
            ),
          ],
        ],
      ),
    );
  }
}
