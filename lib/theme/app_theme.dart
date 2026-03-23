import 'package:flutter/material.dart';

/// Colour tokens used throughout the app.
abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF00D09C);       // 021Trade green accent
  static const Color primaryDark = Color(0xFF00A87E);

  // Backgrounds
  static const Color darkBg = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1C2128);
  static const Color darkDivider = Color(0xFF30363D);

  // Text
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textTertiary = Color(0xFF484F58);

  // Gain / Loss
  static const Color gain = Color(0xFF26A86E);
  static const Color gainBg = Color(0xFF0D2518);
  static const Color loss = Color(0xFFCF4532);
  static const Color lossBg = Color(0xFF2A0C0C);
  static const Color neutral = Color(0xFF8B949E);
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.textPrimary,
        onPrimary: Color(0xFF0D1117),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 0.5,
        space: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        bodySmall: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 11,
        ),
      ),
    );
  }
}
