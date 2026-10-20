import 'package:embedix_studio/core/utils/app_info.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/responsive/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfo.init();
  AppBreakpoints.configure();
  runApp(const EmbedixApp());
}
