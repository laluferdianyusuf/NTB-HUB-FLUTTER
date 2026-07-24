import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../providers/booking_provider.dart';
import '../booking_common_widgets.dart';

class BookingUnitStep extends StatelessWidget {
  const BookingUnitStep({
    super.key,
    required this.data,
    required this.selectedUnitId,
    required this.onSelectUnit,
  });

  final ServiceBookingData data;
  final String? selectedUnitId;
  final ValueChanged<String> onSelectUnit;

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
        Text(
          'Pilih unit di ${data.service.name}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
        ),
        const SizedBox(height: AppSpacing.md),
        if (data.units.isEmpty)
          const BookingEmptyInfo(text: 'Belum ada unit untuk layanan ini.')
        else
          ...data.units.map(
            (unit) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: BookingUnitSelectCard(
                unit: unit,
                isSelected: selectedUnitId == unit.id,
                onTap: () => onSelectUnit(unit.id),
              ),
            ),
          ),
      ],
    );
  }
}
