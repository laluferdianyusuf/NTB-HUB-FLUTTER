import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get adaptiveTextPrimary =>
      isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

  Color get adaptiveTextSecondary =>
      isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

  Color get adaptiveBackground =>
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

  Color get adaptiveSurface =>
      isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;

  Color get adaptiveDivider =>
      isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;

  Color get primaryColor => Theme.of(this).colorScheme.primary;

  Color get cardColor => Theme.of(this).cardTheme.color ?? adaptiveSurface;

  Color get dividerColor => Theme.of(this).dividerTheme.color ?? adaptiveDivider;

  TextStyle get inputTextStyle =>
      textTheme.bodyLarge?.copyWith(color: adaptiveTextPrimary) ??
      TextStyle(color: adaptiveTextPrimary, fontSize: 16);

  InputDecoration appInputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? counterText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      counterText: counterText,
    ).applyDefaults(theme.inputDecorationTheme);
  }

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
