import 'package:flutter/material.dart';

enum AppThemePreset { darkGreen, darkBlue, darkPurple, light }

class AppThemeManager {
  static const _key = 'theme_preset';
  static String get storageKey => _key;

  static AppThemePreset fromString(String? s) {
    switch (s) {
      case 'darkBlue':
        return AppThemePreset.darkBlue;
      case 'darkPurple':
        return AppThemePreset.darkPurple;
      case 'light':
        return AppThemePreset.light;
      default:
        return AppThemePreset.darkGreen;
    }
  }

  static String toStorageString(AppThemePreset p) {
    switch (p) {
      case AppThemePreset.darkBlue:
        return 'darkBlue';
      case AppThemePreset.darkPurple:
        return 'darkPurple';
      case AppThemePreset.light:
        return 'light';
      default:
        return 'darkGreen';
    }
  }

  static ThemeData themeFor(AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.darkBlue:
        return _buildDark(
          accent: const Color(0xFF00B4FF),
          bg: const Color(0xFF060A14),
          surface: const Color(0xFF0D1520),
          surfaceLight: const Color(0xFF111E2E),
          card: const Color(0xFF0A1628),
          cardBorder: const Color(0xFF1A3050),
        );
      case AppThemePreset.darkPurple:
        return _buildDark(
          accent: const Color(0xFFBB86FC),
          bg: const Color(0xFF0A0614),
          surface: const Color(0xFF120D20),
          surfaceLight: const Color(0xFF1A1030),
          card: const Color(0xFF110A1E),
          cardBorder: const Color(0xFF2D1A50),
        );
      case AppThemePreset.light:
        return ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF5F7F5),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1B8A1B),
            surface: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF1B8A1B)),
            titleTextStyle: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardColor: Colors.white,
          dividerColor: const Color(0xFFE0E0E0),
        );
      default:
        return AppTheme.darkTheme;
    }
  }

  static ThemeData _buildDark({
    required Color accent,
    required Color bg,
    required Color surface,
    required Color surfaceLight,
    required Color card,
    required Color cardBorder,
  }) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.dark(primary: accent, surface: surface),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: IconThemeData(color: accent),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardColor: card,
      dividerColor: cardBorder,
    );
  }
}

class AppColors {
  static const background = Color(0xFF060F06);
  static const surface = Color(0xFF0D1F0D);
  static const surfaceLight = Color(0xFF122212);
  static const card = Color(0xFF0F1F0F);
  static const cardBorder = Color(0xFF1A3A1A);
  static const neonGreen = Color(0xFF39FF14);
  static const neonGreenDim = Color(0xFF2BC010);
  static const accentGreen = Color(0xFF00E676);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8DA88D);
  static const textMuted = Color(0xFF4A6A4A);
  static const streakOrange = Color(0xFFFF6B2B);
  static const xpBlue = Color(0xFF4FC3F7);
  static const errorRed = Color(0xFFEF5350);
  static const goldStar = Color(0xFFFFD700);
}

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.neonGreen,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: AppColors.neonGreen),
        ),
        cardColor: AppColors.card,
        dividerColor: AppColors.cardBorder,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      );
}

BoxDecoration cardDecoration({Color? color, bool highlighted = false}) =>
    BoxDecoration(
      color: color ?? AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: highlighted
            ? AppColors.neonGreen.withOpacity(0.5)
            : AppColors.cardBorder,
        width: highlighted ? 1.5 : 1,
      ),
    );

ButtonStyle neonButtonStyle({double radius = 50}) =>
    ElevatedButton.styleFrom(
      backgroundColor: AppColors.neonGreen,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 54),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      textStyle:
          const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      elevation: 0,
    );

ButtonStyle outlineButtonStyle({double radius = 50}) =>
    OutlinedButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      minimumSize: const Size(double.infinity, 54),
      side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      textStyle:
          const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );

InputDecoration appInputDecoration(
        {required String hint, Widget? prefix, Widget? suffix}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 15),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.neonGreen, width: 1.5),
      ),
    );

