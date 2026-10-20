import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/path_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/embed_controller.dart';

class OutputSection extends GetView<EmbedController> {
  const OutputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactScreen;

    return AppCard(
      child: Obx(() {
        final config = controller.config;
        final output = config.outputDirectory;
        final input = config.inputAssembly;
        final outputDisplay = output == null ? null : controller.displayPath(output);

        final pdbToggle = ToggleTile(
          title: 'Generate PDB',
          subtitle: 'On by default · omit --no-pdb',
          value: config.generatePdb,
          onChanged: controller.setGeneratePdb,
        );
        final overwriteToggle = ToggleTile(
          title: 'Reuse / overwrite directory',
          subtitle: 'On by default · omit --no-overwrite',
          value: config.overwriteOutput,
          onChanged: controller.setOverwriteOutput,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 14,
          children: [
            const StepHeader(index: '03', title: 'Output options', flag: '--output'),
            InsetBox(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                spacing: 10,
                children: [
                  const Icon(Icons.folder_outlined, size: 16, color: AppColors.textSecondary),
                  Expanded(
                    child: Text(
                      outputDisplay ?? 'Choose an output directory',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: outputDisplay == null ? AppText.body : AppText.mono,
                    ),
                  ),
                  if (!compact) const Text('DIRECTORY', style: AppText.micro),
                  AppButton(
                    label: 'Browse…',
                    onPressed: controller.isRunning ? null : controller.pickOutputDirectory,
                  ),
                ],
              ),
            ),
            if (outputDisplay != null && input != null)
              Text(
                'Result → $outputDisplay${PathUtils.separator}${input.name}  ·  Input filename is retained',
                style: AppText.monoSecondary.copyWith(fontSize: 10),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 14,
                      children: [pdbToggle, overwriteToggle],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 24,
                      children: [
                        Expanded(child: pdbToggle),
                        Expanded(child: overwriteToggle),
                      ],
                    ),
            ),
            const HintText(
              'Companion .exe and .runtimeconfig.json are copied only when both exist beside the input DLL.',
              style: AppText.micro,
            ),
          ],
        );
      }),
    );
  }
}
