import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../models/booking_time_selection.dart';

class BookingTimePicker extends StatelessWidget {
  const BookingTimePicker({
    super.key,
    required this.openTime,
    required this.closeTime,
    required this.slots,
    required this.selection,
    required this.onChanged,
  });

  final String openTime;
  final String closeTime;
  final List<String> slots;
  final BookingTimeSelection? selection;
  final ValueChanged<BookingTimeSelection?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const _EmptySlotMessage(
        message: 'Tidak ada slot waktu untuk hari ini.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PickerLabel(
          icon: Iconsax.clock,
          title: 'Pilih Waktu',
          subtitle:
              'Ketuk kotak jam mulai, ketuk lagi untuk perpanjang durasi',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            const columns = 4;
            final itemWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: slots.map((slot) {
                final isSelected = selection != null &&
                    BookingTimeSelection.isSlotSelected(
                      slot: slot,
                      selection: selection!,
                      slots: slots,
                    );
                final isRangeStart = selection?.startTime == slot;

                return _TimeSlotBox(
                  width: itemWidth,
                  label: slot,
                  isSelected: isSelected,
                  isRangeStart: isRangeStart,
                  onTap: () {
                    final next = BookingTimeSelection.selectionFromTap(
                      slot: slot,
                      current: selection,
                      slots: slots,
                      closeTime: closeTime,
                    );
                    onChanged(next);
                  },
                );
              }).toList(),
            );
          },
        ),
        if (selection != null && selection!.isValid) ...[
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _TimeRangeSummary(
              key: ValueKey(
                '${selection!.startTime}-${selection!.durationMinutes}',
              ),
              selection: selection!,
              openTime: openTime,
              closeTime: closeTime,
            ),
          ),
        ],
      ],
    );
  }
}

class _PickerLabel extends StatelessWidget {
  const _PickerLabel({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimeSlotBox extends StatelessWidget {
  const _TimeSlotBox({
    required this.width,
    required this.label,
    required this.isSelected,
    required this.isRangeStart,
    required this.onTap,
  });

  final double width;
  final String label;
  final bool isSelected;
  final bool isRangeStart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            height: 52,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.divider,
                width: isRangeStart ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                if (isSelected)
                  Text(
                    isRangeStart ? 'Mulai' : 'Terpilih',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeRangeSummary extends StatelessWidget {
  const _TimeRangeSummary({
    super.key,
    required this.selection,
    required this.openTime,
    required this.closeTime,
  });

  final BookingTimeSelection selection;
  final String openTime;
  final String closeTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.calendar_tick,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selection.displayRange,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${selection.displayDuration} · Operasional $openTime–$closeTime',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySlotMessage extends StatelessWidget {
  const _EmptySlotMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
