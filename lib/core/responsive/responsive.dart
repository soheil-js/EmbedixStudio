import 'package:flutter/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../theme/app_metrics.dart';

export 'package:responsive_builder/responsive_builder.dart'
    show
        DeviceScreenType,
        ResponsiveBuilder,
        ScreenTypeLayout,
        SizingInformation;

/// Screen-width breakpoints shared by the whole app.
///
/// On desktop platforms `responsive_builder` compares the window width:
///   width >= [desktop] -> desktop, width >= [tablet] -> tablet,
///   width <  [watch]   -> watch,   otherwise mobile.
abstract final class AppBreakpoints {
  static const double watch = 300;
  static const double tablet = 700;
  static const double desktop = AppLayout.wideBreakpoint;

  /// Call once from `main()` before `runApp`.
  static void configure() {
    ResponsiveSizingConfig.instance.setCustomBreakpoints(
      const ScreenBreakpoints(desktop: desktop, tablet: tablet, watch: watch),
    );
  }
}

/// Small helpers on top of `responsive_builder` so widgets stay terse.
extension ResponsiveContext on BuildContext {
  DeviceScreenType get screenType => getDeviceType(MediaQuery.sizeOf(this));

  /// True for phones (and watches): single-column, tighter layouts.
  bool get isCompactScreen =>
      screenType == DeviceScreenType.mobile ||
      screenType == DeviceScreenType.watch;

  /// Picks a value for the current screen type (falls back to the next smaller one).
  T byScreen<T>({required T mobile, T? tablet, T? desktop}) {
    return getValueForScreenType<T>(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  double get pagePadding =>
      byScreen<double>(mobile: 16, tablet: 24, desktop: AppLayout.pagePadding);
}
