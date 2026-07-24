import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/helpers/date_formatter.dart';
import '../../../../../../models/booking_time_selection.dart';
import '../../../../../../models/venue_service_model.dart';
import '../../../../../../widgets/common/app_surface_card.dart';
import '../../providers/booking_provider.dart';
import '../booking_common_widgets.dart';

class BookingTotalStep extends StatelessWidget {
  const BookingTotalStep({
    super.key,
    required this.data,
    required this.selectedUnit,
    required this.selectedDate,
    required this.timeSelection,
  });

  final ServiceBookingData data;
  final VenueServiceUnitModel selectedUnit;
  final DateTime selectedDate;
  final BookingTimeSelection timeSelection;

  String _formatPrice(double value) {
    return 'Rp ${value.round().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  String get _estimatedTotal {
    final hourly = selectedUnit.price ?? data.service.price;
    if (hourly == null) return data.service.displayPrice;
    final hours = timeSelection.durationMinutes / 60;
    return _formatPrice(hourly * hours);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.sm,
        AppSpacing.pageHorizontal,
        AppSpacing.xxl,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        const BookingSectionHeader(
          title: 'Ringkasan Booking',
          subtitle: 'Pastikan detail booking sudah benar',
        ),
        const SizedBox(height: AppSpacing.md),
        AppSurfaceCard(
          borderRadius: 18,
          child: Column(
            children: [
              BookingSummaryRow(
                label: 'Layanan',
                value: data.service.displayName,
              ),
              Divider(color: context.adaptiveDivider),
              BookingSummaryRow(label: 'Unit', value: selectedUnit.name),
              Divider(color: context.adaptiveDivider),
              BookingSummaryRow(
                label: 'Tanggal',
                value: DateFormatter.formatDate(selectedDate),
              ),
              Divider(color: context.adaptiveDivider),
              BookingSummaryRow(
                label: 'Waktu',
                value: timeSelection.displayRange,
              ),
              Divider(color: context.adaptiveDivider),
              BookingSummaryRow(
                label: 'Durasi',
                value: timeSelection.displayDuration,
              ),
              Divider(color: context.adaptiveDivider),
              BookingSummaryRow(
                label: 'Estimasi Total',
                value: _estimatedTotal,
                highlight: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppSurfaceCard(
          child: Row(
            children: [
              Icon(Iconsax.info_circle, color: context.primaryColor, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Total final dapat berbeda setelah konfirmasi venue.',
                  style: TextStyle(
                    color: context.adaptiveTextSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
