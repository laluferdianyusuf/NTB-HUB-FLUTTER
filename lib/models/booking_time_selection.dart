import '../core/helpers/time_slot_helper.dart';

class BookingTimeSelection {
  const BookingTimeSelection({
    required this.startTime,
    required this.durationMinutes,
    required this.closeTime,
  });

  final String startTime;
  final int durationMinutes;
  final String closeTime;

  String? get endTime =>
      TimeSlotHelper.calculateEndTime(startTime, durationMinutes);

  bool get isValid {
    final end = endTime;
    if (end == null) return false;
    return TimeSlotHelper.isWithinOperatingHours(
      startTime: startTime,
      endTime: end,
      closeTime: closeTime,
    );
  }

  String get displayRange {
    final end = endTime;
    if (end == null) return startTime;
    return '$startTime – $end';
  }

  String get displayDuration =>
      TimeSlotHelper.formatDuration(durationMinutes);

  static BookingTimeSelection? selectionFromTap({
    required String slot,
    required BookingTimeSelection? current,
    required List<String> slots,
    required String closeTime,
  }) {
    final slotIndex = slots.indexOf(slot);
    if (slotIndex < 0) return current;

    const hourMinutes = TimeSlotHelper.slotIntervalMinutes;

    if (current == null) {
      return BookingTimeSelection(
        startTime: slot,
        durationMinutes: hourMinutes,
        closeTime: closeTime,
      );
    }

    final startIndex = slots.indexOf(current.startTime);
    if (startIndex < 0) {
      return BookingTimeSelection(
        startTime: slot,
        durationMinutes: hourMinutes,
        closeTime: closeTime,
      );
    }

    if (slotIndex < startIndex) {
      return BookingTimeSelection(
        startTime: slot,
        durationMinutes: hourMinutes,
        closeTime: closeTime,
      );
    }

    if (slotIndex == startIndex &&
        current.durationMinutes > hourMinutes) {
      return BookingTimeSelection(
        startTime: slot,
        durationMinutes: hourMinutes,
        closeTime: closeTime,
      );
    }

    final durationMinutes = (slotIndex - startIndex + 1) * hourMinutes;
    return BookingTimeSelection(
      startTime: current.startTime,
      durationMinutes: durationMinutes,
      closeTime: closeTime,
    );
  }

  static bool isSlotSelected({
    required String slot,
    required BookingTimeSelection selection,
    required List<String> slots,
  }) {
    final startIndex = slots.indexOf(selection.startTime);
    final slotIndex = slots.indexOf(slot);
    if (startIndex < 0 || slotIndex < 0) return false;

    final endIndex = startIndex +
        (selection.durationMinutes ~/ TimeSlotHelper.slotIntervalMinutes) -
        1;
    return slotIndex >= startIndex && slotIndex <= endIndex;
  }

  BookingTimeSelection copyWith({
    String? startTime,
    int? durationMinutes,
    String? closeTime,
  }) {
    return BookingTimeSelection(
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      closeTime: closeTime ?? this.closeTime,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookingTimeSelection &&
        other.startTime == startTime &&
        other.durationMinutes == durationMinutes;
  }

  @override
  int get hashCode => Object.hash(startTime, durationMinutes);
}
