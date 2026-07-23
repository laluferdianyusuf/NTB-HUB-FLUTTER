import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/helpers/time_slot_helper.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/booking_time_selection.dart';
import '../../../../../models/operational_hours_model.dart';
import '../../../../../models/venue_service_model.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_time_picker.dart';

class ServiceBookingScreen extends ConsumerStatefulWidget {
  const ServiceBookingScreen({
    super.key,
    required this.serviceId,
    required this.venueId,
    this.initialService,
  });

  final String serviceId;
  final String venueId;
  final VenueServiceModel? initialService;

  @override
  ConsumerState<ServiceBookingScreen> createState() =>
      _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends ConsumerState<ServiceBookingScreen> {
  DateTime? _selectedDate;
  String? _selectedUnitId;
  BookingTimeSelection? _timeSelection;

  ServiceBookingArgs get _args => (
    serviceId: widget.serviceId,
    venueId: widget.venueId.isNotEmpty
        ? widget.venueId
        : (widget.initialService?.venueId ?? ''),
  );

  int get _currentStep {
    if (_selectedDate == null) return 0;
    if (_selectedUnitId == null) return 1;
    if (_timeSelection == null || !_timeSelection!.isValid) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(serviceBookingDataProvider(_args));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Booking Layanan'),
        backgroundColor: Colors.white,
        foregroundColor: context.adaptiveTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      body: bookingAsync.when(
        loading: () => const _BookingLoadingView(),
        error: (error, _) => _BookingErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(serviceBookingDataProvider(_args)),
        ),
        data: (bookingResult) => switch (bookingResult) {
          result.Success(:final data) => _BookingContent(
            data: _mergeInitialService(data),
            currentStep: _currentStep,
            selectedDate: _selectedDate,
            selectedUnitId: _selectedUnitId,
            timeSelection: _timeSelection,
            onSelectDate: (date) => setState(() {
              _selectedDate = date;
              _selectedUnitId = null;
              _timeSelection = null;
            }),
            onSelectUnit: (unitId, daySchedule) => setState(() {
              _selectedUnitId = unitId;
              _timeSelection = null;
            }),
            onTimeChanged: (selection) =>
                setState(() => _timeSelection = selection),
          ),
          result.Error(:final failure) => _BookingErrorView(
            message: failure.message,
            onRetry: () => ref.invalidate(serviceBookingDataProvider(_args)),
          ),
        },
      ),
      bottomNavigationBar: bookingAsync.maybeWhen(
        data: (bookingResult) => switch (bookingResult) {
          result.Success(:final data) => _BookingBottomBar(
            enabled:
                _selectedDate != null &&
                _selectedUnitId != null &&
                _timeSelection != null &&
                _timeSelection!.isValid,
            service: _mergeInitialService(data).service,
            selectedDate: _selectedDate,
            timeSelection: _timeSelection,
            onContinue: () {
              final selection = _timeSelection!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Booking ${_mergeInitialService(data).service.displayName} '
                    'pada ${DateFormatter.formatDate(_selectedDate!)} '
                    '${selection.displayRange} (${selection.displayDuration})',
                  ),
                ),
              );
            },
          ),
          result.Error() => null,
        },
        orElse: () => null,
      ),
    );
  }

  ServiceBookingData _mergeInitialService(ServiceBookingData data) {
    final initial = widget.initialService;
    if (initial == null) return data;

    return ServiceBookingData(
      service: data.service.mergeWith(initial),
      schedule: data.schedule,
      units: data.units.isNotEmpty ? data.units : initial.units,
    );
  }
}

class _BookingContent extends StatelessWidget {
  const _BookingContent({
    required this.data,
    required this.currentStep,
    required this.selectedDate,
    required this.selectedUnitId,
    required this.timeSelection,
    required this.onSelectDate,
    required this.onSelectUnit,
    required this.onTimeChanged,
  });

  final ServiceBookingData data;
  final int currentStep;
  final DateTime? selectedDate;
  final String? selectedUnitId;
  final BookingTimeSelection? timeSelection;
  final ValueChanged<DateTime> onSelectDate;
  final void Function(String unitId, OperationalDayModel? daySchedule)
  onSelectUnit;
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        _BookingStepHeader(currentStep: currentStep),
        const SizedBox(height: 20),
        _ServiceSummaryCard(service: data.service),
        const SizedBox(height: 24),
        _SectionTitle(
          title: 'Pilih Hari',
          subtitle: daySchedule == null
              ? 'Jadwal operasional venue'
              : 'Buka ${daySchedule.openTime} – ${daySchedule.closeTime}',
        ),
        const SizedBox(height: 12),
        if (openDates.isEmpty)
          const _EmptyInfo(text: 'Belum ada jadwal operasional tersedia.')
        else
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: openDates.length,
              separatorBuilder: (_, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final date = openDates[index];
                final isSelected =
                    selectedDate != null && _isSameDay(selectedDate!, date);
                return _DayChip(
                  date: date,
                  isSelected: isSelected,
                  onTap: () => onSelectDate(date),
                );
              },
            ),
          ),
        const SizedBox(height: 28),
        _SectionTitle(
          title: 'Pilih Unit & Waktu',
          subtitle: 'Pilih unit, lalu ketuk kotak waktu (kelipatan 1 jam)',
        ),
        const SizedBox(height: 12),
        if (data.units.isEmpty)
          const _EmptyInfo(text: 'Belum ada unit untuk layanan ini.')
        else
          ...data.units.map(
            (unit) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _UnitBookingCard(
                unit: unit,
                isSelected: selectedUnitId == unit.id,
                daySchedule: daySchedule,
                timeSlots: timeSlots,
                timeSelection: selectedUnitId == unit.id ? timeSelection : null,
                onSelectUnit: () => onSelectUnit(unit.id, daySchedule),
                onTimeChanged: onTimeChanged,
              ),
            ),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _BookingStepHeader extends StatelessWidget {
  const _BookingStepHeader({required this.currentStep});

  final int currentStep;

  static const _steps = ['Hari', 'Unit', 'Waktu', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            Expanded(
              child: _StepItem(
                label: _steps[i],
                index: i + 1,
                isActive: currentStep >= i,
                isCurrent: currentStep == i,
              ),
            ),
            if (i < _steps.length - 1)
              Container(
                width: 12,
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                color: currentStep > i
                    ? context.primaryColor
                    : context.adaptiveDivider,
              ),
          ],
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.label,
    required this.index,
    required this.isActive,
    required this.isCurrent,
  });

  final String label;
  final int index;
  final bool isActive;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive
                ? context.primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? context.primaryColor : context.adaptiveDivider,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              color: isActive ? Colors.white : context.adaptiveTextSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent
                ? context.primaryColor
                : context.adaptiveTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _ServiceSummaryCard extends StatelessWidget {
  const _ServiceSummaryCard({required this.service});

  final VenueServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.adaptiveDivider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
              _InfoChip(icon: Iconsax.wallet_2, label: service.displayPrice),
              if (service.duration != null &&
                  service.duration!.trim().isNotEmpty)
                _InfoChip(icon: Iconsax.timer_1, label: service.duration!),
              if (service.bookingType != null &&
                  service.bookingType!.trim().isNotEmpty)
                _InfoChip(icon: Iconsax.calendar, label: service.bookingType!),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnitBookingCard extends StatelessWidget {
  const _UnitBookingCard({
    required this.unit,
    required this.isSelected,
    required this.daySchedule,
    required this.timeSlots,
    required this.timeSelection,
    required this.onSelectUnit,
    required this.onTimeChanged,
  });

  final VenueServiceUnitModel unit;
  final bool isSelected;
  final OperationalDayModel? daySchedule;
  final List<String> timeSlots;
  final BookingTimeSelection? timeSelection;
  final VoidCallback onSelectUnit;
  final ValueChanged<BookingTimeSelection?> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? context.primaryColor : context.adaptiveDivider,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSelectUnit,
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                      isSelected ? Iconsax.tick_circle : Iconsax.arrow_down_1,
                      size: 18,
                      color: isSelected
                          ? context.primaryColor
                          : context.adaptiveTextSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: isSelected && daySchedule != null
                ? Column(
                    children: [
                      Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: BookingTimePicker(
                          openTime: daySchedule!.openTime,
                          closeTime: daySchedule!.closeTime,
                          slots: timeSlots,
                          selection: timeSelection,
                          onChanged: onTimeChanged,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            width: 76,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? context.primaryColor : Colors.white,
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
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              color: context.adaptiveTextSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _EmptyInfo extends StatelessWidget {
  const _EmptyInfo({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Text(text, style: TextStyle(color: context.adaptiveTextSecondary)),
    );
  }
}

class _BookingBottomBar extends StatelessWidget {
  const _BookingBottomBar({
    required this.enabled,
    required this.service,
    required this.selectedDate,
    required this.timeSelection,
    required this.onContinue,
  });

  final bool enabled;
  final VenueServiceModel service;
  final DateTime? selectedDate;
  final BookingTimeSelection? timeSelection;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        14 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (enabled && selectedDate != null && timeSelection != null) ...[
            Text(
              '${DateFormatter.formatDate(selectedDate!)} · ${timeSelection!.displayRange}',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            Text(
              'Durasi ${timeSelection!.displayDuration}',
              style: TextStyle(
                color: context.adaptiveTextSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
          ],
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: enabled ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: context.adaptiveDivider,
                elevation: enabled ? 2 : 0,
                shadowColor: context.primaryColor.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                enabled
                    ? 'Lanjutkan · ${service.displayPrice}'
                    : 'Pilih hari, unit & waktu',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingLoadingView extends StatelessWidget {
  const _BookingLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        AppSkeleton(height: 56, width: double.infinity, borderRadius: 16),
        SizedBox(height: 16),
        AppSkeleton(height: 160, width: double.infinity, borderRadius: 18),
        SizedBox(height: 20),
        AppSkeleton(height: 18, width: 120),
        SizedBox(height: 12),
        AppSkeleton(height: 92, width: double.infinity, borderRadius: 16),
        SizedBox(height: 24),
        AppSkeleton(height: 180, width: double.infinity, borderRadius: 18),
      ],
    );
  }
}

class _BookingErrorView extends StatelessWidget {
  const _BookingErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.warning_2, size: 40, color: AppColors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
