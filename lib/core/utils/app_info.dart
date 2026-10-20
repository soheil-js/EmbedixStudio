import 'package:package_info_plus/package_info_plus.dart';

/// Static app metadata. Call [init] once in `main()` before `runApp`.
abstract final class AppInfo {
  static String _version = '';

  /// e.g. `1.2.0`. Empty until [init] has completed.
  static String get version => _version;

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    _version = info.version;
  }
}
