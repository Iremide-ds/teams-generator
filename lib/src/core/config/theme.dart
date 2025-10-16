import 'package:flutter/material.dart';
import 'package:teams_gen/src/core/config/colors.dart';

// Shared base theme configuration
class AppTheme {
  // Common colors
  static const _brandColor = AppColors.brandColor;
  static const _errorColor = AppColors.errorColor;

  // static const _fontFamily = 'Inter';

  // Light-specific palette
  static const _lightBg = AppColors.lightBg;
  static const _lightSurface = AppColors.lightSurface;
  static const _lightText = AppColors.lightText;

  // Dark-specific palette
  static const _darkBg = AppColors.darkBg;
  static const _darkSurface = AppColors.darkSurface;
  static const _darkText = AppColors.darkText;

  // Common text theme
  static const _baseTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontSize: 16),
  );

  // Light theme
  static ThemeData lightTheme = _baseTheme(
    brightness: Brightness.light,
    background: _lightBg,
    surface: _lightSurface,
    textColor: _lightText,
  );

  // Dark theme
  static ThemeData darkTheme = _baseTheme(
    brightness: Brightness.dark,
    background: _darkBg,
    surface: _darkSurface,
    textColor: _darkText,
  );

  // Shared theme builder
  static ThemeData _baseTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color textColor,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: _brandColor,
      onPrimary: Colors.white,
      secondary: _brandColor.withAlpha((0.8 * 255).toInt()),
      onSecondary: Colors.white,
      error: _errorColor,
      onError: Colors.white,
      tertiary: background,
      onTertiary: textColor,
      surface: surface,
      onSurface: textColor,
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      // fontFamily: _fontFamily,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      textTheme: _baseTextTheme.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textColor,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface.withAlpha((0.8 * 255).toInt()),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: textColor.withAlpha((0.6 * 255).toInt())),
      ),
    );
  }
}
