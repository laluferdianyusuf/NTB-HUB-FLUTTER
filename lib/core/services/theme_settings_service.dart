import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../storage/local_storage.dart';

enum AppThemePreference {
  light,
  dark,
  system,
}

class ThemeSettingsService {
  ThemeSettingsService({LocalStorage? storage})
      : _storage = storage ?? LocalStorage();

  final LocalStorage _storage;

  static const _themeModeKey = 'app_theme_mode';
  static const _accentKey = 'app_accent';

  Future<AppThemePreference> getThemePreference() async {
    final raw = await _storage.read<String>(_themeModeKey);
    return AppThemePreference.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => AppThemePreference.system,
    );
  }

  Future<void> setThemePreference(AppThemePreference preference) async {
    await _storage.save(_themeModeKey, preference.name);
  }

  Future<AppAccent> getAccent() async {
    final raw = await _storage.read<String>(_accentKey);
    return AppAccent.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => AppAccent.mint,
    );
  }

  Future<void> setAccent(AppAccent accent) async {
    await _storage.save(_accentKey, accent.name);
  }

  ThemeMode toThemeMode(AppThemePreference preference) {
    return switch (preference) {
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
      AppThemePreference.system => ThemeMode.system,
    };
  }
}
