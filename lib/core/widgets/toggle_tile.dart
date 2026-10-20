import 'package:flutter/material.dart';

import '../theme/theme.dart';

class ToggleTile extends StatelessWidget {
  const ToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: title,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => onChanged(!value),
        child: Row(
          spacing: 10,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 28,
              height: 16,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? AppColors.accent : AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(20),
                border: value ? null : Border.all(color: AppColors.border),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 150),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: value ? AppColors.onAccent : AppColors.textMuted,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(title, style: AppText.labelPrimary),
                  Text(subtitle, style: AppText.micro),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
