import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/embed_controller.dart';
import '../../domain/embed_config.dart';
import '../status_presenter.dart';
import 'run_report_view.dart';

class ExecutionPanel extends GetView<EmbedController> {
  const ExecutionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final inset = context.isCompactScreen ? 16.0 : 24.0;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceBar,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 58,
            padding: EdgeInsets.symmetric(horizontal: inset),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Execution & output', style: AppText.sectionTitle),
                Icon(Icons.terminal, size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(inset),
            child: const _CurrentConfiguration(),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: EdgeInsets.all(inset),
            child: Obx(() {
              final result = controller.lastResult;
              return result == null
                  ? const _EmptyReport()
                  : RunReportView(result: result);
            }),
          ),
          _AutoResolutionNote(inset: inset),
        ],
      ),
    );
  }
}

class _CurrentConfiguration extends GetView<EmbedController> {
  const _CurrentConfiguration();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final view = presentStatus(controller);
      final config = controller.config;
      final libs = config.libraryMode == LibraryMode.automatic
          ? 'auto-resolve'
          : '${config.libraries.length} ${config.libraries.length == 1 ? 'library' : 'libraries'}';
      final input = config.inputAssembly?.name;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CURRENT CONFIGURATION', style: AppText.overline),
              StatusBadge(label: view.runLabel, tone: view.runTone),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              _Chip(icon: Icons.extension_outlined, label: libs),
              const Icon(Icons.arrow_forward, size: 18, color: AppColors.textMuted),
              _Chip(
                icon: Icons.inventory_2_outlined,
                label: input ?? 'no input',
                accent: input != null,
              ),
            ],
          ),
          Text(view.message, style: AppText.body),
        ],
      );
    });
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, this.accent = false});

  final IconData icon;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final fg = accent ? AppColors.accent : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: accent ? AppColors.accentSurface : AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(icon, size: 16, color: fg),
          Text(label, style: AppText.monoSecondary.copyWith(color: fg)),
        ],
      ),
    );
  }
}

class _EmptyReport extends StatelessWidget {
  const _EmptyReport();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Text('No runs yet', style: AppText.cardTitle),
        Text(
          'Configure the three steps, then select Embed assemblies. The run summary and console output appear here.',
          style: AppText.body,
        ),
      ],
    );
  }
}

class _AutoResolutionNote extends StatelessWidget {
  const _AutoResolutionNote({required this.inset});

  final double inset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(inset, 0, inset, 22),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 9,
        children: [
          Divider(height: 1, color: AppColors.border),
          Text('Using automatic resolution?', style: AppText.captionSecondary),
          Text(
            'Referenced DLLs are searched beside each examined assembly, recursively. '
            'Missing references are skipped; not all runtime dependencies are guaranteed to be found.',
            style: TextStyle(fontFamily: AppFonts.sans, fontSize: 10, height: 1.6, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
