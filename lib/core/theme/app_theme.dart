import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light({AppAccent accent = AppAccent.mint}) {
    return _buildTheme(
      brightness: Brightness.light,
      accent: accent,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      border: AppColors.lightBorder,
      textPrimary: AppColors.textPrimaryLight,
      textSecondary: AppColors.textSecondaryLight,
    );
  }

  static ThemeData dark({AppAccent accent = AppAccent.mint}) {
    return _buildTheme(
      brightness: Brightness.dark,
      accent: accent,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      border: AppColors.darkBorder,
      textPrimary: AppColors.textPrimaryDark,
      textSecondary: AppColors.textSecondaryDark,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppAccent accent,
    required Color background,
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final seed = AppColors.accentColor(accent);
    final baseTextTheme = brightness == Brightness.light
        ? GoogleFonts.plusJakartaSansTextTheme()
        : GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme);
    final textTheme = baseTextTheme.apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
        primary: seed,
        secondary: AppColors.secondary,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: textSecondary),
      primaryIconTheme: IconThemeData(color: seed),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: background,
        foregroundColor: textPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStrings.cardBorderRadius),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStrings.defaultBorderRadius),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStrings.defaultBorderRadius),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStrings.defaultBorderRadius),
          borderSide: BorderSide(color: seed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStrings.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStrings.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppStrings.defaultBorderRadius),
          borderSide: BorderSide(color: border.withValues(alpha: 0.6)),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
        labelStyle: textTheme.bodyMedium?.copyWith(color: textSecondary),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: seed,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
        prefixIconColor: seed,
        suffixIconColor: textSecondary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: seed,
        selectionColor: seed.withValues(alpha: 0.25),
        selectionHandleColor: seed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: seed,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStrings.buttonBorderRadius),
          ),
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStrings.buttonBorderRadius),
          ),
          side: BorderSide(color: border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: seed,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: seed.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: seed,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(color: textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: seed);
          }
          return IconThemeData(color: textSecondary);
        }),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: seed,
        unselectedLabelColor: textSecondary,
        indicatorColor: seed,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.titleSmall,
        dividerColor: border,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: textSecondary,
          height: 1.5,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: seed,
        linearTrackColor: border,
        circularTrackColor: border,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: seed.withValues(alpha: 0.15),
        disabledColor: border,
        labelStyle: textTheme.bodySmall?.copyWith(color: textPrimary),
        secondaryLabelStyle: textTheme.bodySmall?.copyWith(color: textSecondary),
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.bodyMedium?.copyWith(color: textPrimary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seed,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return seed;
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return seed.withValues(alpha: 0.35);
          }
          return null;
        }),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: seed,
        textColor: textPrimary,
      ),
    );
  }
}
