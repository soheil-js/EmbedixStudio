import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/embed_controller.dart';

class InputAssemblySection extends GetView<EmbedController> {
  const InputAssemblySection({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactScreen;

    return AppCard(
      child: Obx(() {
        final input = controller.config.inputAssembly;
        final isNative = input != null && !input.isManaged;

        final icon = Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            size: 21,
            color: AppColors.textSecondary,
          ),
        );

        final info = input == null
            ? const Text('No assembly selected', style: AppText.body)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    input.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.monoStrong,
                  ),
                  Text(
                    controller.displayPath(input.path),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.monoCaption,
                  ),
                ],
              );

        final badge = input == null
            ? null
            : StatusBadge(
                label: input.isManaged
                    ? 'MANAGED .NET'
                    : 'NATIVE · UNSUPPORTED',
                tone: input.isManaged ? BadgeTone.neutral : BadgeTone.danger,
              );

        final browse = AppButton(
          label: 'Browse…',
          icon: Icons.folder_open_outlined,
          onPressed: controller.isRunning ? null : controller.pickInputAssembly,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            const StepHeader(
              index: '01',
              title: 'Input assembly',
              flag: '--input · required',
            ),
            InsetBox(
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12,
                      children: [
                        Row(
                          spacing: 12,
                          children: [
                            icon,
                            Expanded(child: info),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (badge != null)
                              badge
                            else
                              const SizedBox.shrink(),
                            browse,
                          ],
                        ),
                      ],
                    )
                  : Row(
                      spacing: 12,
                      children: [
                        icon,
                        Expanded(child: info),
                        ?badge,
                        browse,
                      ],
                    ),
            ),
            HintText(
              isNative
                  ? 'This file is a native DLL. Select a managed .NET assembly instead.'
                  : 'Select a compiled managed .NET assembly. Native C/C++ DLLs are not supported.',
              color: isNative ? AppColors.danger : null,
            ),
          ],
        );
      }),
    );
  }
}
