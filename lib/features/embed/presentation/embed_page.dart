import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/theme.dart';
import '../application/embed_controller.dart';
import 'widgets/action_bar.dart';
import 'widgets/command_preview_card.dart';
import 'widgets/execution_panel.dart';
import 'widgets/input_assembly_section.dart';
import 'widgets/libraries_section.dart';
import 'widgets/output_section.dart';
import 'widgets/page_header.dart';
import 'widgets/status_bar.dart';
import 'widgets/top_bar.dart';

class EmbedPage extends GetView<EmbedController> {
  const EmbedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar(
            onOpenCliReference: () async {
              await controller.openCliDirectory();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppLayout.maxContentWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.pagePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PageHeader(
                          workingDirectory: controller.workingDirectory,
                        ),
                        ScreenTypeLayout.builder(
                          desktop: (_) => const _WideBody(),
                          mobile: (_) => const _StackedBody(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const StatusBar(),
        ],
      ),
    );
  }
}

class _WideBody extends StatelessWidget {
  const _WideBody();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        Expanded(child: _FormColumn()),
        SizedBox(width: AppLayout.sidePanelWidth, child: ExecutionPanel()),
      ],
    );
  }
}

class _StackedBody extends StatelessWidget {
  const _StackedBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [_FormColumn(), ExecutionPanel()],
    );
  }
}

class _FormColumn extends StatelessWidget {
  const _FormColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        InputAssemblySection(),
        LibrariesSection(),
        OutputSection(),
        CommandPreviewCard(),
        ActionBar(),
      ],
    );
  }
}
