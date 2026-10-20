import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../application/embed_controller.dart';
import '../../domain/assembly_file.dart';
import '../../domain/embed_config.dart';

class LibrariesSection extends GetView<EmbedController> {
  const LibrariesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactScreen;

    return AppCard(
      child: Obx(() {
        final explicit = controller.config.libraryMode == LibraryMode.explicit;

        final automaticTile = OptionTile(
          title: 'Automatic resolution',
          subtitle: 'Search referenced DLLs recursively',
          selected: !explicit,
          onTap: () => controller.setLibraryMode(LibraryMode.automatic),
        );
        final explicitTile = OptionTile(
          title: 'Explicit selection',
          subtitle: 'Embed only the libraries you choose',
          selected: explicit,
          onTap: () => controller.setLibraryMode(LibraryMode.explicit),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 14,
          children: [
            const StepHeader(index: '02', title: 'Libraries to embed', flag: '--libraries'),
            if (compact)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [automaticTile, explicitTile],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Expanded(child: automaticTile),
                  Expanded(child: explicitTile),
                ],
              ),
            if (explicit) const _LibraryList(),
            HintText(
              explicit
                  ? 'Explicit selection disables automatic resolution. At least one library is required.'
                  : 'Referenced DLLs are searched beside each examined assembly, recursively.',
              icon: Icons.info_outline,
            ),
          ],
        );
      }),
    );
  }
}

class _LibraryList extends GetView<EmbedController> {
  const _LibraryList();

  @override
  Widget build(BuildContext context) {
    // Own Obx: this widget is const, so the parent's Obx can't rebuild it.
    return Obx(() {
      final libraries = controller.config.libraries;
      final count = libraries.length;
      final running = controller.isRunning;

      return InsetBox(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$count selected ${count == 1 ? 'library' : 'libraries'}', style: AppText.captionSecondary),
                  AppButton(
                    label: 'Add libraries',
                    icon: Icons.add,
                    variant: AppButtonVariant.ghost,
                    onPressed: running ? null : controller.addLibraries,
                  ),
                ],
              ),
            ),
            if (libraries.isEmpty)
              const _Row(child: Text('No libraries added yet.', style: AppText.caption))
            else
              for (final lib in libraries)
                _LibraryRow(
                  key: ValueKey(lib.path),
                  library: lib,
                  displayPath: controller.displayPath(lib.path),
                  onRemove: running ? null : () => controller.removeLibrary(lib),
                ),
          ],
        ),
      );
    });
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderSubtle))),
      child: child,
    );
  }
}

class _LibraryRow extends StatelessWidget {
  const _LibraryRow({super.key, required this.library, required this.displayPath, required this.onRemove});

  final AssemblyFile library;
  final String displayPath;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactScreen;

    return _Row(
      child: Row(
        spacing: 10,
        children: [
          const Icon(Icons.extension_outlined, size: 16, color: AppColors.textMuted),
          if (compact)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(library.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.mono),
                    Text(displayPath, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.monoCaption),
                  ],
                ),
              ),
            )
          else ...[
            Expanded(
              flex: 2,
              child: Text(library.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.mono),
            ),
            Expanded(
              flex: 3,
              child: Text(displayPath, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.monoCaption),
            ),
          ],
          Text(
            library.isManaged ? 'MANAGED' : 'NATIVE',
            style: AppText.micro.copyWith(color: library.isManaged ? AppColors.textMuted : AppColors.danger),
          ),
          IconButton(
            tooltip: 'Remove ${library.name}',
            onPressed: onRemove,
            icon: const Icon(Icons.close, size: 14),
            color: AppColors.textMuted,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
          ),
        ],
      ),
    );
  }
}
