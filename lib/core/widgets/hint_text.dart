import 'package:flutter/material.dart';

import '../theme/theme.dart';

class HintText extends StatelessWidget {
  const HintText(this.text, {super.key, this.icon, this.style = AppText.caption, this.color});

  final String text;
  final IconData? icon;
  final TextStyle style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effective = color == null ? style : style.copyWith(color: color);
    final textWidget = Text(text, style: effective);
    if (icon == null) return textWidget;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 13, color: effective.color),
        ),
        Expanded(child: textWidget),
      ],
    );
  }
}
