import 'package:flutter/material.dart';

import '../theme/theme.dart';

class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.index, required this.title, required this.flag});

  final String index;
  final String title;
  final String flag;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Text(index, style: AppText.monoCaption),
        Expanded(child: Text(title, style: AppText.sectionTitle)),
        Text(flag, style: AppText.monoSecondary),
      ],
    );
  }
}
