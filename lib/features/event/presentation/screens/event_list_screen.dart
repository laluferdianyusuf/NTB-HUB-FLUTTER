import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/helpers/date_formatter.dart';
import '../../../../widgets/common/AppButton.dart';
import '../../../../widgets/common/app_page_scaffold.dart';
import '../../../../widgets/common/app_surface_card.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      _EventItem(
        title: 'Festival Bau Nyale 2026',
        location: 'Pantai Seger, Lombok',
        date: DateTime(2026, 2, 20),
        attendees: 1250,
      ),
      _EventItem(
        title: 'NTB Expo & UMKM Fair',
        location: 'Mataram Convention Center',
        date: DateTime(2026, 3, 10),
        attendees: 890,
      ),
      _EventItem(
        title: 'Lomba Perahu Tradisional',
        location: 'Pantai Tanjung, Sumbawa',
        date: DateTime(2026, 4, 5),
        attendees: 456,
      ),
    ];

    return AppPageScaffold(
      title: AppStrings.events,
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return AppSurfaceCard(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Iconsax.calendar,
                        color: AppColors.secondary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: context.adaptiveTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _EventDetailRow(icon: Iconsax.location, text: event.location),
                const SizedBox(height: 6),
                _EventDetailRow(
                  icon: Iconsax.calendar,
                  text: DateFormatter.formatDate(event.date),
                ),
                const SizedBox(height: 6),
                _EventDetailRow(
                  icon: Iconsax.people,
                  text: '${event.attendees} peserta',
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(label: 'Daftar Event', onPressed: () {}),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EventItem {
  const _EventItem({
    required this.title,
    required this.location,
    required this.date,
    required this.attendees,
  });

  final String title;
  final String location;
  final DateTime date;
  final int attendees;
}

class _EventDetailRow extends StatelessWidget {
  const _EventDetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.adaptiveTextSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: context.adaptiveTextSecondary),
          ),
        ),
      ],
    );
  }
}
