abstract final class TimeSlotHelper {
  const TimeSlotHelper._();

  static const slotIntervalMinutes = 60;

  static List<String> generateSlots({
    required String openTime,
    required String closeTime,
    int intervalMinutes = slotIntervalMinutes,
  }) {
    final open = parseTime(openTime);
    final close = parseTime(closeTime);
    if (open == null || close == null || !close.isAfter(open)) {
      return const [];
    }

    final slots = <String>[];
    var current = open;
    while (current.isBefore(close)) {
      slots.add(formatTime(current));
      current = current.add(Duration(minutes: intervalMinutes));
    }
    return slots;
  }

  static String? calculateEndTime(String startTime, int durationMinutes) {
    final start = parseTime(startTime);
    if (start == null || durationMinutes <= 0) return null;
    return formatTime(start.add(Duration(minutes: durationMinutes)));
  }

  static bool isWithinOperatingHours({
    required String startTime,
    required String endTime,
    required String closeTime,
  }) {
    final start = parseTime(startTime);
    final end = parseTime(endTime);
    final close = parseTime(closeTime);
    if (start == null || end == null || close == null) return false;
    return end.isAfter(start) && !end.isAfter(close);
  }

  static String formatDuration(int minutes) {
    if (minutes <= 0) return '-';
    if (minutes < 60) return '$minutes menit';

    final hours = minutes ~/ 60;
    if (minutes % 60 == 0) {
      return hours == 1 ? '1 jam' : '$hours jam';
    }

    final hoursPart = minutes ~/ 60;
    final minutesPart = minutes % 60;
    return '${hoursPart}j ${minutesPart}m';
  }

  static DateTime? parseTime(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;

    final parts = value.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;

    return DateTime(2000, 1, 1, hour, minute);
  }

  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
