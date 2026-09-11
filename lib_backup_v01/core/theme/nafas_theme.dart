import 'package:flutter/material.dart';
import 'nafas_colors.dart';
import 'nafas_radius.dart';

abstract final class NafasTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: NafasColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NafasColors.primary,
        brightness: Brightness.light,
        primary: NafasColors.primary,
        secondary: NafasColors.accent,
        surface: NafasColors.surface,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: NafasColors.textPrimary,
          height: 1.3,
        ),
        headlineMedium: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: NafasColors.textPrimary,
          height: 1.35,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: NafasColors.textPrimary,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: NafasColors.textPrimary,
        ),
        bodyLarge: const TextStyle(
          fontSize: 15,
          color: NafasColors.textPrimary,
          height: 1.7,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: NafasColors.textSecondary,
          height: 1.65,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          color: NafasColors.textMuted,
          height: 1.55,
        ),
      ),
      cardTheme: CardThemeData(
        color: NafasColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NafasRadius.card),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: NafasColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NafasRadius.button),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NafasColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NafasRadius.input),
          borderSide: const BorderSide(color: NafasColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NafasRadius.input),
          borderSide: const BorderSide(color: NafasColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NafasRadius.input),
          borderSide: const BorderSide(color: NafasColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
