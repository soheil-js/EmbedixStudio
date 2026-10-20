import 'package:get/get.dart';

import '../../features/embed/bindings/embed_binding.dart';
import '../../features/embed/presentation/embed_page.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.embed,
      page: () => const EmbedPage(),
      binding: EmbedBinding(),
      transition: Transition.noTransition,
    ),
  ];
}
