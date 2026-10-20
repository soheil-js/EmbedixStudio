import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/embed_controller.dart';
import '../../domain/embed_config.dart';
import '../../domain/run_result.dart';

class RunReportView extends GetView<EmbedController> {
  const RunReportView({super.key, required this.result});

  final EmbedRunResult result;

  String get _finishedLabel {
    String two(int n) => n.toString().padLeft(2, '0');
    final t = result.finishedAt;
    final seconds = (result.duration.inMilliseconds / 1000).toStringAsFixed(1);
    return 'Finished ${two(t.hour)}:${two(t.minute)}:${two(t.second)} · $seconds s';
  }

  String get _bannerDetail {
    if (!result.isSuccess) {
      return result.errorMessage ?? 'The command did not complete.';
    }

    final libs = result.libraryMode == LibraryMode.automatic
        ? 'automatic resolution'
        : '${result.libraryCount} explicit ${result.libraryCount == 1 ? 'library' : 'libraries'}';
    return '$libs · ${result.pdbGenerated ? 'PDB generated' : 'no PDB'}';
  }

  @override
  Widget build(BuildContext context) {
    final ok = result.isSuccess;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                const Text('Latest run', style: AppText.cardTitle),
                Text(_finishedLabel, style: AppText.micro),
              ],
            ),
            StatusBadge(
              label: ok
                  ? 'SUCCESS · EXIT 0'
                  : 'FAILED · EXIT ${result.exitCode}',
              tone: ok ? BadgeTone.success : BadgeTone.danger,
              showDot: true,
            ),
          ],
        ),
        _Banner(
          success: ok,
          title: ok ? 'Assembly embedded successfully' : 'Embedding failed',
          detail: _bannerDetail,
        ),
        Obx(
          () => _Tabs(
            labels: const ['Run summary', 'Console'],
            selected: controller.reportTab,
            onSelected: controller.setReportTab,
          ),
        ),
        Obx(() => controller.reportTab == 0 ? _summary() : _console()),
      ],
    );
  }

  Widget _summary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 13,
          children: [
            for (final step in result.steps)
              Row(
                spacing: 9,
                children: [
                  Icon(
                    step.succeeded ? Icons.check : Icons.error_outline,
                    size: 13,
                    color: step.succeeded ? AppColors.accent : AppColors.danger,
                  ),
                  Expanded(
                    child: Text(step.label, style: AppText.monoSecondary),
                  ),
                ],
              ),
          ],
        ),
        if (result.outputFiles.isNotEmpty) _outputs(),
      ],
    );
  }

  Widget _outputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 7,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('OUTPUT FILES', style: AppText.overline),
            InkWell(
              onTap: () =>
                  controller.openOutputDirectory(result.outputDirectory),
              child: const Row(
                spacing: 5,
                children: [
                  Text('Open directory', style: AppText.microSecondary),
                  Icon(
                    Icons.open_in_new,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        Text('${result.outputDirectory}\\', style: AppText.monoSecondary),
        for (final file in result.outputFiles)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              spacing: 10,
              children: [
                const Icon(
                  Icons.insert_drive_file_outlined,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(file.name, style: AppText.mono),
                      Text(file.description, style: AppText.micro),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _console() {
    return InsetBox(
      padding: const EdgeInsets.all(12),
      child: SelectableText(
        result.consoleLines.isEmpty
            ? '(no output)'
            : result.consoleLines.join('\n'),
        style: AppText.monoSecondary.copyWith(height: 1.7),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.success,
    required this.title,
    required this.detail,
  });

  final bool success;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final fg = success ? AppColors.accent : AppColors.danger;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: success ? AppColors.accentSurface : AppColors.dangerSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        spacing: 10,
        children: [
          Icon(
            success ? Icons.check_circle_outline : Icons.error_outline,
            size: 19,
            color: fg,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(title, style: AppText.label.copyWith(color: fg)),
                Text(detail, style: AppText.microSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        spacing: 24,
        children: [
          for (var i = 0; i < labels.length; i++)
            InkWell(
              onTap: () => onSelected(i),
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: i == selected
                          ? AppColors.accent
                          : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 12,
                    fontWeight: i == selected
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: i == selected
                        ? AppColors.accent
                        : AppColors.textMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
