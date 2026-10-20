import 'package:embedix_studio/core/utils/app_info.dart';
import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key, this.onOpenCliReference});

  final VoidCallback? onOpenCliReference;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(
        horizontal: context.byScreen<double>(mobile: 16, desktop: 24),
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceBar,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Embedix Studio', style: AppText.brand),
          const SizedBox(width: 10),
          Container(width: 1, height: 16, color: AppColors.border),
          const SizedBox(width: 10),
          Text('v${AppInfo.version}', style: AppText.brandSub),
          const Spacer(),
          InkWell(
            onTap: onOpenCliReference,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('CLI reference ↗', style: AppText.link),
            ),
          ),
        ],
      ),
    );
  }
}
