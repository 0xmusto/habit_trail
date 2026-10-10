import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Colors that change between light and dark mode. Read them with `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.ink,
    required this.inkSurface,
    required this.emphasis,
    required this.canvas,
    required this.surface,
    required this.border,
    required this.sage,
    required this.muted,
    required this.leaf,
    required this.leafSoft,
    required this.dangerSoft,
    required this.locked,
  });

  /// Primary text and icon color.
  final Color ink;

  /// Fill for dark feature cards and selected controls; text on it stays white.
  final Color inkSurface;

  /// Accent for highlights such as progress bars and the current day ring.
  final Color emphasis;
  final Color canvas;
  final Color surface;
  final Color border;
  final Color sage;
  final Color muted;
  final Color leaf;
  final Color leafSoft;
  final Color dangerSoft;
  final Color locked;

  static const light = AppPalette(
    ink: AppColors.ink,
    inkSurface: AppColors.ink,
    emphasis: AppColors.ink,
    canvas: AppColors.canvas,
    surface: Colors.white,
    border: AppColors.border,
    sage: AppColors.sage,
    muted: AppColors.muted,
    leaf: AppColors.leaf,
    leafSoft: AppColors.leafSoft,
    dangerSoft: AppColors.dangerSoft,
    locked: AppColors.locked,
  );

  static const dark = AppPalette(
    ink: Color(0xFFE8F1EC),
    inkSurface: Color(0xFF1F4A3C),
    emphasis: AppColors.lime,
    canvas: Color(0xFF0E1A16),
    surface: Color(0xFF16261F),
    border: Color(0xFF27392F),
    sage: Color(0xFF22352D),
    muted: Color(0xFF94AA9F),
    leaf: Color(0xFFA9CF5F),
    leafSoft: Color(0xFF263A24),
    dangerSoft: Color(0xFF3D2622),
    locked: Color(0xFF2D3F37),
  );

  @override
  AppPalette copyWith({
    Color? ink,
    Color? inkSurface,
    Color? emphasis,
    Color? canvas,
    Color? surface,
    Color? border,
    Color? sage,
    Color? muted,
    Color? leaf,
    Color? leafSoft,
    Color? dangerSoft,
    Color? locked,
  }) => AppPalette(
    ink: ink ?? this.ink,
    inkSurface: inkSurface ?? this.inkSurface,
    emphasis: emphasis ?? this.emphasis,
    canvas: canvas ?? this.canvas,
    surface: surface ?? this.surface,
    border: border ?? this.border,
    sage: sage ?? this.sage,
    muted: muted ?? this.muted,
    leaf: leaf ?? this.leaf,
    leafSoft: leafSoft ?? this.leafSoft,
    dangerSoft: dangerSoft ?? this.dangerSoft,
    locked: locked ?? this.locked,
  );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      ink: mix(ink, other.ink),
      inkSurface: mix(inkSurface, other.inkSurface),
      emphasis: mix(emphasis, other.emphasis),
      canvas: mix(canvas, other.canvas),
      surface: mix(surface, other.surface),
      border: mix(border, other.border),
      sage: mix(sage, other.sage),
      muted: mix(muted, other.muted),
      leaf: mix(leaf, other.leaf),
      leafSoft: mix(leafSoft, other.leafSoft),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      locked: mix(locked, other.locked),
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
