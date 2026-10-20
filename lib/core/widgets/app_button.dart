import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.secondary,
    this.height = 34,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final double height;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final (Color bg, Color fg, Color border) = switch (variant) {
      AppButtonVariant.primary => (AppColors.accent, AppColors.onAccent, Colors.transparent),
      AppButtonVariant.secondary => (AppColors.surfaceRaised, AppColors.textPrimary, AppColors.border),
      AppButtonVariant.ghost => (Colors.transparent, AppColors.textSecondary, Colors.transparent),
    };

    return Opacity(
      opacity: (onPressed == null && !loading) ? 0.45 : 1,
      child: Material(
        color: bg,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: border),
        ),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: variant == AppButtonVariant.primary ? 20 : 12),
              child: Center(
                widthFactor: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    if (loading)
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: fg),
                      )
                    else if (icon != null)
                      Icon(icon, size: 16, color: fg),
                    Text(label, style: AppText.button.copyWith(color: fg)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
