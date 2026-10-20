import 'package:flutter/painting.dart';

/// Design tokens: colors.
abstract final class AppColors {
  // Surfaces
  static const background = Color(0xFF111416);
  static const surfaceBar = Color(0xFF15191C);
  static const surface = Color(0xFF1A1F22);
  static const surfaceInset = Color(0xFF14181B);
  static const surfaceRaised = Color(0xFF242B2F);

  // Borders
  static const borderSubtle = Color(0xFF252D31);
  static const border = Color(0xFF30383D);

  // Text
  static const textPrimary = Color(0xFFEDF2F3);
  static const textSecondary = Color(0xFFA1ADB3);
  static const textMuted = Color(0xFF75848C);

  // Accent (success)
  static const accent = Color(0xFF8CE8C2);
  static const accentSurface = Color(0xFF20372F);
  static const accentBorder = Color(0xFF527C6B);
  static const onAccent = Color(0xFF10251C);

  // Danger
  static const danger = Color(0xFFFF8A80);
  static const dangerSurface = Color(0xFF3A1F22);
  static const dangerBorder = Color(0xFF7C5256);
}
