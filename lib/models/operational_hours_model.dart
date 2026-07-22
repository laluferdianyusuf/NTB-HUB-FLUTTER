import '../core/helpers/json_field_helper.dart';

class OperationalDayModel {
  const OperationalDayModel({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    required this.isOpen,
    this.dayName,
  });

  final int dayOfWeek;
  final String openTime;
  final String closeTime;
  final bool isOpen;
  final String? dayName;

  static const dayLabels = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

  String get shortLabel {
    if (dayName != null && dayName!.trim().isNotEmpty) {
      return dayName!.trim();
    }
    if (dayOfWeek >= 1 && dayOfWeek <= 7) {
      return dayLabels[dayOfWeek % 7];
    }
    return '-';
  }

  bool matchesDate(DateTime date) {
    if (!isOpen) return false;
    return date.weekday == _normalizeDay(dayOfWeek);
  }

  factory OperationalDayModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['operational', 'data']) ?? json;

    final dayValue = source['dayOfWeek'] ??
        source['day_of_week'] ??
        source['day'] ??
        source['weekday'];

    return OperationalDayModel(
      dayOfWeek: _parseDayOfWeek(dayValue) ?? 0,
      openTime: JsonFieldHelper.readString(source, [
            'openTime',
            'open_time',
            'startTime',
            'start_time',
            'open',
          ]) ??
          '08:00',
      closeTime: JsonFieldHelper.readString(source, [
            'closeTime',
            'close_time',
            'endTime',
            'end_time',
            'close',
          ]) ??
          '17:00',
      isOpen: JsonFieldHelper.readBool(source, [
        'isOpen',
        'is_open',
        'active',
      ], fallback: true),
      dayName: JsonFieldHelper.readString(source, [
        'dayName',
        'day_name',
        'label',
      ]),
    );
  }

  static int _normalizeDay(int day) {
    if (day >= 0 && day <= 6) {
      return day == 0 ? DateTime.sunday : day;
    }
    if (day >= 1 && day <= 7) return day;
    return day;
  }

  static int? _parseDayOfWeek(dynamic value) {
    if (value is int) return _normalizeDay(value);
    if (value is num) return _normalizeDay(value.toInt());

    switch (value?.toString().toUpperCase()) {
      case 'SUNDAY':
      case 'MINGGU':
      case 'MIN':
        return DateTime.sunday;
      case 'MONDAY':
      case 'SENIN':
      case 'SEN':
        return DateTime.monday;
      case 'TUESDAY':
      case 'SELASA':
      case 'SEL':
        return DateTime.tuesday;
      case 'WEDNESDAY':
      case 'RABU':
      case 'RAB':
        return DateTime.wednesday;
      case 'THURSDAY':
      case 'KAMIS':
      case 'KAM':
        return DateTime.thursday;
      case 'FRIDAY':
      case 'JUMAT':
      case 'JUM':
        return DateTime.friday;
      case 'SATURDAY':
      case 'SABTU':
      case 'SAB':
        return DateTime.saturday;
      default:
        return int.tryParse(value.toString());
    }
  }
}

class OperationalScheduleModel {
  const OperationalScheduleModel({required this.days});

  final List<OperationalDayModel> days;

  List<DateTime> upcomingOpenDates({int count = 14}) {
    final today = DateTime.now();
    final result = <DateTime>[];

    for (var offset = 0; result.length < count && offset < 60; offset++) {
      final date = DateTime(today.year, today.month, today.day + offset);
      final schedule = scheduleFor(date);
      if (schedule != null && schedule.isOpen) {
        result.add(date);
      }
    }

    return result;
  }

  OperationalDayModel? scheduleFor(DateTime date) {
    for (final day in days) {
      if (day.matchesDate(date)) return day;
    }
    return null;
  }

  factory OperationalScheduleModel.fromJson(dynamic json) {
    final items = JsonFieldHelper.readObjectList(json)
        .map(OperationalDayModel.fromJson)
        .where((day) => day.dayOfWeek > 0)
        .toList();

    return OperationalScheduleModel(days: items);
  }
}
