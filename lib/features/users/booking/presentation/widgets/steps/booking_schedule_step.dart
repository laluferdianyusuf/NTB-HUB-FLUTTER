import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/helpers/time_slot_helper.dart';
import '../../../../../../models/booking_time_selection.dart';
import '../../../../../../models/venue_service_model.dart';
import '../../../../../../widgets/common/app_surface_card.dart';
import '../../providers/booking_provider.dart';
import '../booking_common_widgets.dart';
import '../booking_time_picker.dart';

class BookingScheduleStep extends StatelessWidget {
  const BookingScheduleStep({
    super.key,
    required this.data,
    required this.selectedUnit,
    required this.selectedDate,
    required this.timeSelection,
    required this.onSelectDate,
    required this.onTimeChanged,
  });

  final ServiceBookingData data;
  final VenueServiceUnitModel selectedUnit;
  final DateTime? selectedDate;
  final BookingTimeSelection? timeSelection;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<BookingTimeSelection?> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    final openDates = data.schedule.upcomingOpenDates();
    final activeDate =
        selectedDate ?? (openDates.isNotEmpty ? openDates.first : null);
    final daySchedule = activeDate == null
        ? null
        : data.schedule.scheduleFor(activeDate);
    final timeSlots = daySchedule == null
        ? const <String>[]
        : TimeSlotHelper.generateSlots(
            openTime: daySchedule.openTime,
            closeTime: daySchedule.closeTime,
          );

    if (activeDate != null && selectedDate == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onSelectDate(activeDate);
      });
    }

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
          borderRadius: 16,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedUnit.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              if (selectedUnit.capacity != null)
                Text(
                  'Kapasitas ${selectedUnit.capacity}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.section),
        BookingSectionHeader(
          title: 'Pilih Hari',
          subtitle: daySchedule == null
              ? 'Jadwal operasional venue'
              : 'Buka ${daySchedule.openTime} – ${daySchedule.closeTime}',
        ),
        const SizedBox(height: AppSpacing.md),
        if (openDates.isEmpty)
          const BookingEmptyInfo(
            text: 'Belum ada jadwal operasional tersedia.',
          )
        else
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: openDates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final date = openDates[index];
                final isSelected = selectedDate != null &&
                    _isSameDay(selectedDate!, date);
                return BookingDayChip(
                  date: date,
                  isSelected: isSelected,
                  onTap: () => onSelectDate(date),
                );
              },
            ),
          ),
        const SizedBox(height: AppSpacing.section),
        const BookingSectionHeader(
          title: 'Pilih Waktu',
          subtitle: 'Ketuk kotak jam mulai, ketuk lagi untuk perpanjang durasi',
        ),
        const SizedBox(height: AppSpacing.md),
        if (daySchedule == null)
          const BookingEmptyInfo(
            text: 'Pilih hari operasional terlebih dahulu.',
          )
        else
          AppSurfaceCard(
            borderRadius: 18,
            child: BookingTimePicker(
              openTime: daySchedule.openTime,
              closeTime: daySchedule.closeTime,
              slots: timeSlots,
              selection: timeSelection,
              onChanged: onTimeChanged,
            ),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
