import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage([SharedPreferences? prefs]) : _prefs = prefs ?? _requirePrefs();

  static SharedPreferences? _sharedPrefs;

  static void bind(SharedPreferences prefs) {
    _sharedPrefs = prefs;
  }

  static SharedPreferences _requirePrefs() {
    final prefs = _sharedPrefs;
    if (prefs == null) {
      throw StateError('LocalStorage.bind() must be called in main.dart');
    }
    return prefs;
  }

  final SharedPreferences _prefs;

  Future<void> save(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
      return;
    }

    if (value is int) {
      await _prefs.setInt(key, value);
      return;
    }

    if (value is bool) {
      await _prefs.setBool(key, value);
      return;
    }

    if (value is double) {
      await _prefs.setDouble(key, value);
      return;
    }

    if (value is List<String>) {
      await _prefs.setStringList(key, value);
      return;
    }

    if (value is List<dynamic>) {
      await _prefs.setStringList(
        key,
        value.map((item) => item.toString()).toList(),
      );
      return;
    }

    if (value is Map<String, dynamic>) {
      await _prefs.setString(key, jsonEncode(value));
    }
  }

  Future<T?> read<T>(String key) async {
    final value = _prefs.get(key);
    if (value == null) return null;

    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          return decoded as T;
        }
      } catch (_) {
        return value as T?;
      }
    }

    if (value is List && T == List<dynamic>) {
      return value as T;
    }

    return value as T?;
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
