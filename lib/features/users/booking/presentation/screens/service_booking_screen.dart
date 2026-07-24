import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/booking_time_selection.dart';
import '../../../../../models/venue_service_model.dart';
import '../../../../../widgets/common/AppButton.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../../../../../widgets/common/app_status_message.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_step_header.dart';
import '../widgets/steps/booking_payment_step.dart';
import '../widgets/steps/booking_schedule_step.dart';
import '../widgets/steps/booking_total_step.dart';
import '../widgets/steps/booking_unit_step.dart';

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
  int _stepIndex = 0;
  String? _selectedUnitId;
  DateTime? _selectedDate;
  BookingTimeSelection? _timeSelection;
  String _paymentMethod = 'wallet';

  ServiceBookingArgs get _args => (
    serviceId: widget.serviceId,
    venueId: widget.venueId.isNotEmpty
        ? widget.venueId
        : (widget.initialService?.venueId ?? ''),
  );

  void _goNext() {
    if (_stepIndex < BookingStepHeader.steps.length - 1) {
      setState(() => _stepIndex++);
    }
  }

  void _goBack() {
    if (_stepIndex > 0) {
      setState(() => _stepIndex--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  VenueServiceUnitModel? _selectedUnit(ServiceBookingData data) {
    if (_selectedUnitId == null) return null;
    for (final unit in data.units) {
      if (unit.id == _selectedUnitId) return unit;
    }
    return null;
  }

  bool _canContinue(ServiceBookingData data) {
    return switch (_stepIndex) {
      0 => _selectedUnitId != null,
      1 =>
        _selectedDate != null &&
            _timeSelection != null &&
            _timeSelection!.isValid,
      2 => true,
      3 => _paymentMethod.isNotEmpty,
      _ => false,
    };
  }

  String _primaryLabel(ServiceBookingData data) {
    return switch (_stepIndex) {
      0 => 'Lanjut ke Jadwal',
      1 => 'Lanjut ke Total',
      2 => 'Lanjut ke Pembayaran',
      3 => 'Bayar Sekarang',
      _ => AppStrings.retry,
    };
  }

  void _onPrimaryAction(ServiceBookingData data) {
    if (!_canContinue(data)) return;

    if (_stepIndex < 3) {
      _goNext();
      return;
    }

    final unit = _selectedUnit(data)!;
    final selection = _timeSelection!;
    context.showSnackBar(
      'Booking ${data.service.displayName} · ${unit.name} '
      'pada ${DateFormatter.formatDate(_selectedDate!)} '
      '${selection.displayRange} (${selection.displayDuration})',
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

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(serviceBookingDataProvider(_args));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: _goBack,
        ),
        title: Text(BookingStepHeader.steps[_stepIndex]),
      ),
      body: bookingAsync.when(
        loading: () => const _BookingLoadingView(),
        error: (error, _) => AppStatusMessage(
          message: error.toString(),
          actionLabel: AppStrings.retry,
          onAction: () => ref.invalidate(serviceBookingDataProvider(_args)),
        ),
        data: (bookingResult) => switch (bookingResult) {
          result.Success(:final data) => _BookingStepFlow(
            data: _mergeInitialService(data),
            stepIndex: _stepIndex,
            selectedUnitId: _selectedUnitId,
            selectedDate: _selectedDate,
            timeSelection: _timeSelection,
            paymentMethod: _paymentMethod,
            onSelectUnit: (unitId) => setState(() {
              _selectedUnitId = unitId;
              _selectedDate = null;
              _timeSelection = null;
            }),
            onSelectDate: (date) => setState(() {
              _selectedDate = date;
              _timeSelection = null;
            }),
            onTimeChanged: (selection) =>
                setState(() => _timeSelection = selection),
            onSelectPaymentMethod: (method) =>
                setState(() => _paymentMethod = method),
          ),
          result.Error(:final failure) => AppStatusMessage(
            message: failure.message,
            actionLabel: AppStrings.retry,
            onAction: () => ref.invalidate(serviceBookingDataProvider(_args)),
          ),
        },
      ),
      bottomNavigationBar: bookingAsync.maybeWhen(
        data: (bookingResult) => switch (bookingResult) {
          result.Success(:final data) => _BookingBottomBar(
            enabled: _canContinue(_mergeInitialService(data)),
            label: _primaryLabel(_mergeInitialService(data)),
            subtitle: _bottomSubtitle(_mergeInitialService(data)),
            onPressed: () => _onPrimaryAction(_mergeInitialService(data)),
          ),
          result.Error() => null,
        },
        orElse: () => null,
      ),
    );
  }

  String? _bottomSubtitle(ServiceBookingData data) {
    if (_stepIndex == 1 &&
        _selectedDate != null &&
        _timeSelection != null &&
        _timeSelection!.isValid) {
      return '${DateFormatter.formatDate(_selectedDate!)} · ${_timeSelection!.displayRange}';
    }
    if (_stepIndex == 2 && _selectedUnit(data) != null) {
      return '${_selectedUnit(data)!.name} · ${data.service.displayName}';
    }
    return null;
  }
}

class _BookingStepFlow extends StatelessWidget {
  const _BookingStepFlow({
    required this.data,
    required this.stepIndex,
    required this.selectedUnitId,
    required this.selectedDate,
    required this.timeSelection,
    required this.paymentMethod,
    required this.onSelectUnit,
    required this.onSelectDate,
    required this.onTimeChanged,
    required this.onSelectPaymentMethod,
  });

  final ServiceBookingData data;
  final int stepIndex;
  final String? selectedUnitId;
  final DateTime? selectedDate;
  final BookingTimeSelection? timeSelection;
  final String paymentMethod;
  final ValueChanged<String> onSelectUnit;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<BookingTimeSelection?> onTimeChanged;
  final ValueChanged<String> onSelectPaymentMethod;

  VenueServiceUnitModel? get _unit {
    if (selectedUnitId == null) return null;
    for (final unit in data.units) {
      if (unit.id == selectedUnitId) return unit;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final unit = _unit;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.sm,
            AppSpacing.pageHorizontal,
            AppSpacing.md,
          ),
          child: BookingStepHeader(currentStep: stepIndex),
        ),
        Expanded(
          child: IndexedStack(
            index: stepIndex,
            children: [
              BookingUnitStep(
                data: data,
                selectedUnitId: selectedUnitId,
                onSelectUnit: onSelectUnit,
              ),
              unit == null
                  ? const _StepPlaceholder(
                      message: 'Pilih unit terlebih dahulu.',
                    )
                  : BookingScheduleStep(
                      data: data,
                      selectedUnit: unit,
                      selectedDate: selectedDate,
                      timeSelection: timeSelection,
                      onSelectDate: onSelectDate,
                      onTimeChanged: onTimeChanged,
                    ),
              unit == null ||
                      selectedDate == null ||
                      timeSelection == null ||
                      !timeSelection!.isValid
                  ? const _StepPlaceholder(
                      message: 'Lengkapi jadwal booking terlebih dahulu.',
                    )
                  : BookingTotalStep(
                      data: data,
                      selectedUnit: unit,
                      selectedDate: selectedDate!,
                      timeSelection: timeSelection!,
                    ),
              unit == null ||
                      selectedDate == null ||
                      timeSelection == null ||
                      !timeSelection!.isValid
                  ? const _StepPlaceholder(
                      message: 'Lengkapi ringkasan booking terlebih dahulu.',
                    )
                  : BookingPaymentStep(
                      data: data,
                      selectedUnit: unit,
                      selectedDate: selectedDate!,
                      timeSelection: timeSelection!,
                      selectedPaymentMethod: paymentMethod,
                      onSelectPaymentMethod: onSelectPaymentMethod,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepPlaceholder extends StatelessWidget {
  const _StepPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.adaptiveTextSecondary),
        ),
      ),
    );
  }
}

class _BookingBottomBar extends StatelessWidget {
  const _BookingBottomBar({
    required this.enabled,
    required this.label,
    required this.onPressed,
    this.subtitle,
  });

  final bool enabled;
  final String label;
  final String? subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageHorizontal,
        AppSpacing.md,
        AppSpacing.pageHorizontal,
        AppSpacing.pageHorizontal + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.adaptiveTextSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppButton(label: label, onPressed: enabled ? onPressed : null),
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
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
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
