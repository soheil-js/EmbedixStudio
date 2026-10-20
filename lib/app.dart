import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/app_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'core/theme/theme.dart';

class EmbedixApp extends StatelessWidget {
  const EmbedixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Embedix Studio',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.embed,
      getPages: AppPages.pages,
    );
  }
}
