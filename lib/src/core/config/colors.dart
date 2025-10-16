import 'package:flutter/material.dart';

abstract class AppColors {
  // Common colors
  static const brandColor = Color(0xFF5B8DEF);
  static const errorColor = Color(0xFFEF5350);
  static const successColor = Color(0xFF66BB6A);
  static const warningColor = Color.fromARGB(255, 187, 180, 102);

  // Light-specific palette
  static const lightBg = Color(0xFFF9FAFB);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF1F2937);

  // Dark-specific palette
  static const darkBg = Color(0xFF0D1117);
  static const darkSurface = Color(0xFF161B22);
  static const darkText = Color(0xFFE5E7EB);

  /// --- Brand Shades ---
  static const brand = _ColorShades(
    border: Color(0xFF4A7ADB),
    backgroundLight: Color(0xFFE7EEFF),
    backgroundDark: Color(0xFF243B6B),
    icon: Color(0xFF3B6DD8),
    text: Color(0xFF2C4EA3),
  );

  /// --- Error Shades ---
  static const error = _ColorShades(
    border: Color(0xFFE23E3A),
    backgroundLight: Color(0xFFFFE8E7),
    backgroundDark: Color(0xFF4C1E1E),
    icon: Color(0xFFC62828),
    text: Color(0xFF8B1E1E),
  );

  /// --- Success Shades ---
  static const success = _ColorShades(
    border: Color(0xFF57A65B),
    backgroundLight: Color(0xFFEAF6EA),
    backgroundDark: Color(0xFF1C3320),
    icon: Color(0xFF388E3C),
    text: Color(0xFF27632A),
  );

  /// --- Warning Shades ---
  static const warning = _ColorShades(
    border: Color(0xFFA89E52),
    backgroundLight: Color(0xFFFFFBE5),
    backgroundDark: Color(0xFF3A3618),
    icon: Color(0xFF8E863B),
    text: Color(0xFF6A6529),
  );
}

/// Utility class to group shade variations
class _ColorShades {
  final Color border;
  final Color backgroundLight;
  final Color backgroundDark;
  final Color icon;
  final Color text;

  const _ColorShades({
    required this.border,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.icon,
    required this.text,
  });
}
