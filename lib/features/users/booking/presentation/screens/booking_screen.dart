import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = [
      _BookingItem(
        venue: 'Auditorium Mataram',
        date: DateTime(2026, 7, 15),
        status: 'Dikonfirmasi',
        statusColor: AppColors.success,
      ),
      _BookingItem(
        venue: 'Gedung Serbaguna Sumbawa',
        date: DateTime(2026, 7, 22),
        status: 'Menunggu',
        statusColor: AppColors.secondary,
      ),
      _BookingItem(
        venue: 'Convention Hall Lombok',
        date: DateTime(2026, 8, 5),
        status: 'Dibatalkan',
        statusColor: AppColors.error,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.booking),
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.adaptiveDivider),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Iconsax.buildings,
                      color: context.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.venue,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormatter.formatDate(booking.date),
                          style: TextStyle(
                            color: context.adaptiveTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: booking.statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(
                        color: booking.statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.primaryColor,
        onPressed: () {},
        icon: Icon(Iconsax.add, color: Colors.white, size: 20),
        label: const Text(
          'Booking Baru',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _BookingItem {
  const _BookingItem({
    required this.venue,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  final String venue;
  final DateTime date;
  final String status;
  final Color statusColor;
}
