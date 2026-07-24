import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../models/operational_hours_model.dart';
import '../../../../../models/venue_service_model.dart';
import '../../../../../widgets/common/app_section_header.dart';
import '../../../../../widgets/common/app_surface_card.dart';

class BookingServiceSummaryCard extends StatelessWidget {
  const BookingServiceSummaryCard({super.key, required this.service});

  final VenueServiceModel service;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.displayName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: context.adaptiveTextPrimary,
            ),
          ),
          if (service.displayCategory.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              service.displayCategory,
              style: TextStyle(
                color: context.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (service.description.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              service.description,
              style: TextStyle(
                color: context.adaptiveTextSecondary,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              BookingInfoChip(
                icon: Iconsax.wallet_2,
                label: service.displayPrice,
              ),
              if (service.duration != null &&
                  service.duration!.trim().isNotEmpty)
                BookingInfoChip(
                  icon: Iconsax.timer_1,
                  label: service.duration!,
                ),
              if (service.bookingType != null &&
                  service.bookingType!.trim().isNotEmpty)
                BookingInfoChip(
                  icon: Iconsax.calendar,
                  label: service.bookingType!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingInfoChip extends StatelessWidget {
  const BookingInfoChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.adaptiveTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingEmptyInfo extends StatelessWidget {
  const BookingEmptyInfo({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Text(
        text,
        style: TextStyle(color: context.adaptiveTextSecondary),
      ),
    );
  }
}

class BookingDayChip extends StatelessWidget {
  const BookingDayChip({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  Widget build(BuildContext context) {
    final dayLabel = OperationalDayModel.dayLabels[date.weekday % 7];
    final monthLabel = _months[date.month - 1];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 76,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColor : context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor
                  : context.adaptiveDivider,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayLabel,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white70
                      : context.adaptiveTextSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${date.day}',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : context.adaptiveTextPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              Text(
                monthLabel,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white70
                      : context.adaptiveTextSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingUnitSelectCard extends StatelessWidget {
  const BookingUnitSelectCard({
    super.key,
    required this.unit,
    required this.isSelected,
    required this.onTap,
  });

  final VenueServiceUnitModel unit;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      borderRadius: 18,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? context.primaryColor
                  : context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Iconsax.box,
              color: isSelected ? Colors.white : context.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: context.adaptiveTextPrimary,
                  ),
                ),
                if (unit.capacity != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Kapasitas ${unit.capacity} orang',
                    style: TextStyle(
                      color: context.adaptiveTextSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (unit.price != null)
            Text(
              'Rp ${unit.price!.round()}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.primaryColor,
              ),
            ),
          const SizedBox(width: 8),
          Icon(
            isSelected ? Iconsax.tick_circle : Iconsax.arrow_right_3,
            size: 18,
            color: isSelected
                ? context.primaryColor
                : context.adaptiveTextSecondary,
          ),
        ],
      ),
    );
  }
}

class BookingSummaryRow extends StatelessWidget {
  const BookingSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.adaptiveTextSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                color: highlight
                    ? context.primaryColor
                    : context.adaptiveTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingSectionHeader extends StatelessWidget {
  const BookingSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return AppSectionHeader(title: title, subtitle: subtitle);
  }
}
