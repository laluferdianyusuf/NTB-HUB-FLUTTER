import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/helpers/date_formatter.dart';

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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.events),
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.adaptiveDivider),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Daftar Event'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EventDetailRow extends StatelessWidget {
  const _EventDetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.adaptiveTextSecondary, size: 16),
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
