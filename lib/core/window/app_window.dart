import 'package:flutter/widgets.dart';
import 'package:nativeapi_flutter/nativeapi_flutter.dart';

/// Default desktop window configuration shared by the whole app.
abstract final class AppWindow {
  static const Size initialSize = Size(1200, 650);
  static const Size minimumSize = Size(500, 650);

  /// Configures the main window.
  ///
  /// Call once from `main()` before `runApp()`.
  static void configure() {
    final window = WindowManager.instance.getCurrent();

    window?.titleBarStyle = TitleBarStyle.hidden;
    window?.contentSize = initialSize.toNative();
    window?.minimumSize = minimumSize.toNative();
    window?.center();
  }
}
