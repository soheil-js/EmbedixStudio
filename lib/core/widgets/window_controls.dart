import 'package:embedix_studio/core/window/window_context.dart';
import 'package:flutter/material.dart';

class WindowControls extends StatefulWidget {
  const WindowControls({super.key});

  @override
  State<WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<WindowControls> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WindowButton(
          icon: Icons.remove_rounded,
          // tooltip: 'Minimize',
          onPressed: () => context.minimizeWindow(),
        ),
        _WindowButton(
          icon: context.isWindowMaximized
              ? Icons.filter_none_rounded
              : Icons.crop_square_rounded,
          // tooltip: context.isWindowMaximized ? 'Restore' : 'Maximize',
          onPressed: () => context.toggleMaximizeWindow(),
        ),
        _WindowButton(
          icon: Icons.close_rounded,
          // tooltip: 'Close',
          hoverColor: const Color(0xFFE81123),
          onPressed: () => context.closeWindow(),
        ),
      ],
    );
  }
}

class _WindowButton extends StatelessWidget {
  const _WindowButton({
    required this.icon,
    // required this.tooltip,
    required this.onPressed,
    this.hoverColor = const Color(0x1FFFFFFF),
  });

  final IconData icon;
  // final String tooltip;
  final VoidCallback onPressed;
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 36,
      child: IconButton(
        onPressed: onPressed,
        // tooltip: tooltip,
        padding: EdgeInsets.zero,
        iconSize: 17,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return hoverColor;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered) &&
                hoverColor == const Color(0xFFE81123)) {
              return Colors.white;
            }
            return Theme.of(context).colorScheme.onSurfaceVariant;
          }),
        ),
        icon: Icon(icon),
      ),
    );
  }
}
