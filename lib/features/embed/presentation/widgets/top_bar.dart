import 'package:embedix_studio/core/utils/app_info.dart';
import 'package:embedix_studio/core/window/window_context.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key, this.onOpenCliReference});

  final VoidCallback? onOpenCliReference;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.only(left: 8, right: 8),
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
          Expanded(
            child: context.dragToMoveArea(
              child: SizedBox(height: double.infinity),
            ),
          ),
          InkWell(
            onTap: onOpenCliReference,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('CLI reference ↗', style: AppText.link),
            ),
          ),
          SizedBox(width: 10),
          WindowControls(),
        ],
      ),
    );
  }
}
