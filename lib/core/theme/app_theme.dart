import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppFonts.sans,
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.border,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.onAccent,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surfaceRaised,
      contentTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 12),
    ),
    tooltipTheme: const TooltipThemeData(
      textStyle: TextStyle(color: AppColors.textPrimary, fontSize: 11),
      decoration: BoxDecoration(color: AppColors.surfaceRaised),
    ),
  );
}
