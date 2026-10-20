import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Radio-style selectable tile.
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selected ? AppColors.accentSurface : AppColors.surfaceInset,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: selected ? AppColors.accentBorder : AppColors.border),
            ),
            child: Row(
              spacing: 10,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceInset,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: selected ? 4 : 1,
                      color: selected ? AppColors.accent : AppColors.textMuted,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        title,
                        style: AppText.label.copyWith(
                          color: selected ? AppColors.accent : AppColors.textSecondary,
                        ),
                      ),
                      Text(subtitle, style: AppText.microSecondary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
