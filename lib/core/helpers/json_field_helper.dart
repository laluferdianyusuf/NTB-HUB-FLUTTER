abstract final class JsonFieldHelper {
  static String? readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
    return null;
  }

  static int? readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is int) return value;
      if (value is num) return value.toInt();
      final parsed = int.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }

  static double? readDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is num) return value.toDouble();
      final parsed = double.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }

  static double readDecimal(
    Map<String, dynamic> json,
    List<String> keys, {
    double fallback = 0,
  }) {
    return readDouble(json, keys) ?? fallback;
  }

  static List<String> readStringList(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is! List) continue;
      return value
          .map((item) => item?.toString().trim() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static Map<String, dynamic> readJson(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
    }
    return const {};
  }

  static Map<String, dynamic> unwrap(
    Map<String, dynamic> json, {
    List<String> keys = const ['data', 'result', 'item'],
  }) {
    return readMap(json, keys) ?? json;
  }

  static bool readBool(Map<String, dynamic> json, List<String> keys,
      {bool fallback = true}) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) return value;
    }
    return fallback;
  }

  static DateTime? readDateTime(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is DateTime) return value;
      final parsed = DateTime.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }

  static Map<String, dynamic>? readMap(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
    }
    return null;
  }

  static List<Map<String, dynamic>> readObjectList(dynamic json) {
    if (json is List) {
      return json.whereType<Map<String, dynamic>>().toList();
    }

    if (json is Map<String, dynamic>) {
      for (final key in [
        'data',
        'items',
        'tasks',
        'news',
        'list',
        'results',
        'venues',
        'events',
        'places',
        'publicPlaces',
        'public_places',
        'services',
        'venueServices',
        'venue_services',
      ]) {
        final value = json[key];
        if (value is List) {
          return value.whereType<Map<String, dynamic>>().toList();
        }
      }
    }

    return const [];
  }
}
