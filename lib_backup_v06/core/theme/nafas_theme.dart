import 'package:flutter/material.dart';
import 'nafas_colors.dart';
import 'nafas_radius.dart';

abstract final class NafasTheme {
  static const _fallbackFonts = <String>[
    'Estedad',
    'Noto Sans Arabic',
    'Tahoma',
  ];

  static TextStyle _text({
    required double size,
    required FontWeight weight,
    required Color color,
    double height = 1.55,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Vazirmatn',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontFamilyFallback: _fallbackFonts,
    );
  }

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Vazirmatn',
      brightness: Brightness.light,
      scaffoldBackgroundColor: NafasColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: NafasColors.primary,
        brightness: Brightness.light,
        primary: NafasColors.primary,
        secondary: NafasColors.accent,
        surface: NafasColors.surface,
        error: NafasColors.danger,
      ),
    );

    return base.copyWith(
      splashFactory: InkSparkle.splashFactory,
      textTheme: TextTheme(
        displaySmall: _text(size: 34, weight: FontWeight.w900, color: NafasColors.textPrimary, height: 1.25),
        headlineLarge: _text(size: 28, weight: FontWeight.w900, color: NafasColors.textPrimary, height: 1.28),
        headlineMedium: _text(size: 22, weight: FontWeight.w900, color: NafasColors.textPrimary, height: 1.34),
        titleLarge: _text(size: 19, weight: FontWeight.w900, color: NafasColors.textPrimary, height: 1.42),
        titleMedium: _text(size: 16, weight: FontWeight.w800, color: NafasColors.textPrimary, height: 1.48),
        bodyLarge: _text(size: 15, weight: FontWeight.w500, color: NafasColors.textPrimary, height: 1.75),
        bodyMedium: _text(size: 14, weight: FontWeight.w500, color: NafasColors.textSecondary, height: 1.72),
        bodySmall: _text(size: 12, weight: FontWeight.w500, color: NafasColors.textMuted, height: 1.62),
        labelLarge: _text(size: 14, weight: FontWeight.w800, color: NafasColors.textPrimary, height: 1.35),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: _text(size: 19, weight: FontWeight.w900, color: NafasColors.textPrimary, height: 1.2),
        iconTheme: const IconThemeData(color: NafasColors.textPrimary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: NafasColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NafasRadius.button)),
          textStyle: _text(size: 15, weight: FontWeight.w900, color: Colors.white, height: 1.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          backgroundColor: Colors.white,
          foregroundColor: NafasColors.textPrimary,
          side: const BorderSide(color: NafasColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(NafasRadius.button)),
          textStyle: _text(size: 14, weight: FontWeight.w800, color: NafasColors.textPrimary, height: 1.2),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NafasColors.primary,
          textStyle: _text(size: 13, weight: FontWeight.w800, color: NafasColors.primary, height: 1.2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NafasColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        hintStyle: _text(size: 13, weight: FontWeight.w500, color: NafasColors.textMuted),
        labelStyle: _text(size: 13, weight: FontWeight.w700, color: NafasColors.textSecondary),
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
          borderSide: const BorderSide(color: NafasColors.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: Colors.white.withValues(alpha: .97),
        elevation: 0,
        indicatorColor: NafasColors.surfaceSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return _text(
            size: 10.5,
            weight: active ? FontWeight.w900 : FontWeight.w600,
            color: active ? NafasColors.primary : NafasColors.textMuted,
            height: 1.1,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? NafasColors.primary : NafasColors.textMuted,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: NafasColors.border),
        backgroundColor: Colors.white,
        selectedColor: NafasColors.surfaceSoft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: _text(size: 12.5, weight: FontWeight.w700, color: NafasColors.textPrimary, height: 1.2),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: NafasColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: _text(size: 13, weight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}
