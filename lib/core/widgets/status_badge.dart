import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum BadgeTone { neutral, success, danger }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = BadgeTone.neutral,
    this.showDot = false,
  });

  final String label;
  final BadgeTone tone;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (tone) {
      BadgeTone.neutral => (AppColors.surfaceRaised, AppColors.textSecondary),
      BadgeTone.success => (AppColors.accentSurface, AppColors.accent),
      BadgeTone.danger => (AppColors.dangerSurface, AppColors.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          if (showDot)
            Container(width: 5, height: 5, decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
          Text(label, style: AppText.badge.copyWith(color: fg)),
        ],
      ),
    );
  }
}
