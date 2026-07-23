import 'package:flutter/material.dart';

enum AppAccent {
  mint,
  ocean,
  violet,
}

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF00B894);
  static const Color primaryDark = Color(0xFF009E7E);
  static const Color primaryLight = Color(0xFF55EFC4);
  static const Color secondary = Color(0xFF0984E3);
  static const Color accent = Color(0xFF6C5CE7);

  static const Color lightBackground = Color(0xFFF8F9FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8ECF0);

  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF1A1D26);
  static const Color darkBorder = Color(0xFF2A2F3A);

  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFFF7675);
  static const Color info = Color(0xFF74B9FF);

  static const Color textPrimaryLight = Color(0xFF1A1D26);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF5F6FA);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  static const Color star = Color(0xFFFFB800);

  /// Legacy aliases used across existing widgets (light defaults).
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color background = lightBackground;
  static const Color surface = lightSurface;
  static const Color divider = lightBorder;

  static Color accentColor(AppAccent accent) => switch (accent) {
        AppAccent.mint => primary,
        AppAccent.ocean => secondary,
        AppAccent.violet => AppColors.accent,
      };

  static Color accentDarkColor(AppAccent accent) => switch (accent) {
        AppAccent.mint => primaryDark,
        AppAccent.ocean => const Color(0xFF076EBC),
        AppAccent.violet => const Color(0xFF5A4BD1),
      };

  static Color accentLightColor(AppAccent accent) => switch (accent) {
        AppAccent.mint => primaryLight,
        AppAccent.ocean => const Color(0xFF74B9FF),
        AppAccent.violet => const Color(0xFFA29BFE),
      };

  static String accentLabel(AppAccent accent) => switch (accent) {
        AppAccent.mint => 'Mint',
        AppAccent.ocean => 'Ocean',
        AppAccent.violet => 'Violet',
      };

  static List<Color> accentPreviewColors(AppAccent accent) => [
        accentColor(accent),
        accentDarkColor(accent),
        accentLightColor(accent),
      ];
}
