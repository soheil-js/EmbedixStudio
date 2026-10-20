import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/embed_controller.dart';
import '../status_presenter.dart';

class ActionBar extends GetView<EmbedController> {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactScreen;

    return Obx(() {
      final view = presentStatus(controller);

      final status = Row(
        spacing: 10,
        children: [
          StatusBadge(
            label: view.readinessLabel,
            tone: view.readinessTone,
            showDot: view.readinessDot,
          ),
          Flexible(
            child: Text(
              view.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.captionSecondary,
            ),
          ),
        ],
      );

      final runButton = AppButton(
        label: controller.isRunning ? 'Embedding…' : 'Embed assemblies',
        icon: Icons.play_arrow_rounded,
        variant: AppButtonVariant.primary,
        height: 44,
        loading: controller.isRunning,
        onPressed: controller.canRun ? controller.run : null,
      );

      if (compact) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [status, runButton],
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: status),
          const SizedBox(width: 16),
          runButton,
        ],
      );
    });
  }
}
