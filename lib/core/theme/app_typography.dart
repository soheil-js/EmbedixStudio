import 'package:flutter/painting.dart';

import 'app_colors.dart';

abstract final class AppFonts {
  static const sans = 'Inter';
  static const mono = 'JetBrains Mono';
}

/// Design tokens: text styles.
abstract final class AppText {
  static const brand = TextStyle(fontFamily: AppFonts.sans, fontSize: 15, color: AppColors.textPrimary);
  static const brandSub = TextStyle(fontFamily: AppFonts.sans, fontSize: 11, letterSpacing: 0.8, color: AppColors.textMuted);
  static const link = TextStyle(fontFamily: AppFonts.sans, fontSize: 12, color: AppColors.textSecondary);

  static const pageTitle = TextStyle(fontFamily: AppFonts.sans, fontSize: 30, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const pageSubtitle = TextStyle(fontFamily: AppFonts.sans, fontSize: 13, color: AppColors.textSecondary);

  static const sectionTitle = TextStyle(fontFamily: AppFonts.sans, fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const cardTitle = TextStyle(fontFamily: AppFonts.sans, fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const overline = TextStyle(fontFamily: AppFonts.sans, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.6, color: AppColors.textMuted);
  static const label = TextStyle(fontFamily: AppFonts.sans, fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary);
  static const labelPrimary = TextStyle(fontFamily: AppFonts.sans, fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  static const body = TextStyle(fontFamily: AppFonts.sans, fontSize: 12, height: 1.6, color: AppColors.textSecondary);
  static const caption = TextStyle(fontFamily: AppFonts.sans, fontSize: 11, color: AppColors.textMuted);
  static const captionSecondary = TextStyle(fontFamily: AppFonts.sans, fontSize: 11, color: AppColors.textSecondary);
  static const micro = TextStyle(fontFamily: AppFonts.sans, fontSize: 10, color: AppColors.textMuted);
  static const microSecondary = TextStyle(fontFamily: AppFonts.sans, fontSize: 10, color: AppColors.textSecondary);

  static const mono = TextStyle(fontFamily: AppFonts.mono, fontSize: 12, color: AppColors.textPrimary);
  static const monoStrong = TextStyle(fontFamily: AppFonts.mono, fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
  static const monoCaption = TextStyle(fontFamily: AppFonts.mono, fontSize: 11, color: AppColors.textMuted);
  static const monoSecondary = TextStyle(fontFamily: AppFonts.mono, fontSize: 11, color: AppColors.textSecondary);

  static const badge = TextStyle(fontFamily: AppFonts.sans, fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary);
  static const button = TextStyle(fontFamily: AppFonts.sans, fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary);
}
