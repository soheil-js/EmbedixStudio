import 'package:embedix_studio/core/utils/app_info.dart';
import 'package:embedix_studio/core/window/app_window.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/responsive/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppWindow.configure();
  AppBreakpoints.configure();
  await AppInfo.init();
  runApp(const EmbedixApp());
}
