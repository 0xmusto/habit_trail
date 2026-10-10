import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light, AppPalette.light);

  static ThemeData get dark => _build(Brightness.dark, AppPalette.dark);

  static ThemeData _build(Brightness brightness, AppPalette palette) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColors.lime : AppColors.ink;
    final onPrimary = isDark ? AppColors.ink : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ink,
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        surface: palette.canvas,
        onSurface: palette.ink,
      ),
      scaffoldBackgroundColor: palette.canvas,
      extensions: [palette],
      dialogTheme: DialogThemeData(backgroundColor: palette.surface),
      popupMenuTheme: PopupMenuThemeData(color: palette.surface),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
