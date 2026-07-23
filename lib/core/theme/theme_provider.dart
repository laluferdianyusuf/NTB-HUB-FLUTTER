import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../services/theme_settings_service.dart';
import 'app_theme.dart';

final themeSettingsServiceProvider = Provider<ThemeSettingsService>(
  (ref) => ThemeSettingsService(),
);

class AppThemeState {
  const AppThemeState({
    required this.preference,
    required this.accent,
  });

  final AppThemePreference preference;
  final AppAccent accent;

  ThemeMode get themeMode {
    return switch (preference) {
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
      AppThemePreference.system => ThemeMode.system,
    };
  }

  ThemeData get lightTheme => AppTheme.light(accent: accent);
  ThemeData get darkTheme => AppTheme.dark(accent: accent);

  AppThemeState copyWith({
    AppThemePreference? preference,
    AppAccent? accent,
  }) {
    return AppThemeState(
      preference: preference ?? this.preference,
      accent: accent ?? this.accent,
    );
  }
}

class AppThemeNotifier extends Notifier<AppThemeState> {
  @override
  AppThemeState build() {
    Future.microtask(_loadSettings);
    return const AppThemeState(
      preference: AppThemePreference.system,
      accent: AppAccent.mint,
    );
  }

  Future<void> _loadSettings() async {
    final service = ref.read(themeSettingsServiceProvider);
    final preference = await service.getThemePreference();
    final accent = await service.getAccent();
    state = AppThemeState(preference: preference, accent: accent);
  }

  Future<void> setThemePreference(AppThemePreference preference) async {
    await ref.read(themeSettingsServiceProvider).setThemePreference(preference);
    state = state.copyWith(preference: preference);
  }

  Future<void> setAccent(AppAccent accent) async {
    await ref.read(themeSettingsServiceProvider).setAccent(accent);
    state = state.copyWith(accent: accent);
  }
}

final appThemeProvider = NotifierProvider<AppThemeNotifier, AppThemeState>(
  AppThemeNotifier.new,
);
