import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/embed_controller.dart';

class CommandPreviewCard extends GetView<EmbedController> {
  const CommandPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    const base = TextStyle(fontFamily: AppFonts.mono, fontSize: 12, height: 1.85);

    return AppCard(
      color: AppColors.surfaceInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                spacing: 9,
                children: [
                  Icon(Icons.terminal, size: 16, color: AppColors.textSecondary),
                  Text('CLI command preview', style: AppText.cardTitle),
                ],
              ),
              AppButton(
                label: 'Copy command',
                icon: Icons.copy_outlined,
                variant: AppButtonVariant.ghost,
                height: 28,
                onPressed: () async {
                  await controller.copyCommand();
                  AppSnackbar.show('Command copied');
                },
              ),
            ],
          ),
          Obx(() {
            final command = controller.previewCommand;
            return SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(text: command.headDisplay, style: base.copyWith(color: AppColors.accent)),
                  TextSpan(text: command.optionsDisplay, style: base.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            );
          }),
          const HintText(
            'Relative paths resolve from the working directory shown above. Default options are omitted.',
            style: AppText.micro,
          ),
        ],
      ),
    );
  }
}
