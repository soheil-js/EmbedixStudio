import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.workingDirectory});

  final String workingDirectory;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactScreen;
    final titleStyle = compact
        ? AppText.pageTitle.copyWith(fontSize: 24)
        : AppText.pageTitle;

    return Padding(
      padding: EdgeInsets.only(top: compact ? 20 : 27, bottom: compact ? 18 : 25),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 16,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 7,
            children: [
              Text('Embed assemblies', style: titleStyle),
              const Text(
                'Bundle managed libraries into your compiled .NET assembly.',
                style: AppText.pageSubtitle,
              ),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: compact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              spacing: 7,
              children: [
                const Text('PROCESS WORKING DIRECTORY', style: AppText.overline),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    const Icon(Icons.folder_outlined, size: 14, color: AppColors.textSecondary),
                    Flexible(
                      child: SelectableText(
                        workingDirectory,
                        maxLines: 1,
                        style: AppText.mono.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
