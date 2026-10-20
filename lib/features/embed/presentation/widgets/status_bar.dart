import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/theme/theme.dart';
import '../../application/embed_controller.dart';
import '../status_presenter.dart';

class StatusBar extends GetView<EmbedController> {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = context.isCompactScreen;
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: context.pagePadding),
      decoration: const BoxDecoration(
        color: AppColors.surfaceBar,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Obx(() {
        final view = presentStatus(controller);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!compact)
              const Flexible(
                child: Text(
                  'LOCAL PROCESS  /  Managed .NET assemblies only',
                  overflow: TextOverflow.ellipsis,
                  style: AppText.monoCaption,
                ),
              ),
            Flexible(
              child: Text(
                view.footer,
                overflow: TextOverflow.ellipsis,
                style: AppText.captionSecondary,
              ),
            ),
          ],
        );
      }),
    );
  }
}
