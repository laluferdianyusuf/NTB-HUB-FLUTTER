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

class BookingPaymentStep extends StatelessWidget {
  const BookingPaymentStep({
    super.key,
    required this.data,
    required this.selectedUnit,
    required this.selectedDate,
    required this.timeSelection,
    required this.selectedPaymentMethod,
    required this.onSelectPaymentMethod,
  });

  final ServiceBookingData data;
  final VenueServiceUnitModel selectedUnit;
  final DateTime selectedDate;
  final BookingTimeSelection timeSelection;
  final String selectedPaymentMethod;
  final ValueChanged<String> onSelectPaymentMethod;

  static const _methods = [
    (id: 'wallet', label: 'Dompet NTB Hub', icon: Iconsax.wallet_2),
    (id: 'qris', label: 'QRIS', icon: Iconsax.scan_barcode),
    (id: 'bank', label: 'Transfer Bank', icon: Iconsax.bank),
  ];

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
        AppSurfaceCard(
          borderRadius: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _estimatedTotal,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: context.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${data.service.displayName} · ${selectedUnit.name}',
                style: TextStyle(color: context.adaptiveTextSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormatter.formatDate(selectedDate)} · ${timeSelection.displayRange}',
                style: TextStyle(color: context.adaptiveTextSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.section),
        const BookingSectionHeader(
          title: 'Metode Pembayaran',
          subtitle: 'Pilih cara pembayaran booking',
        ),
        const SizedBox(height: AppSpacing.md),
        ..._methods.map(
          (method) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppSurfaceCard(
              borderRadius: 16,
              onTap: () => onSelectPaymentMethod(method.id),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(method.icon, color: context.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      method.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.adaptiveTextPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    selectedPaymentMethod == method.id
                        ? Iconsax.tick_circle5
                        : Iconsax.record_circle,
                    color: selectedPaymentMethod == method.id
                        ? context.primaryColor
                        : context.adaptiveTextSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
