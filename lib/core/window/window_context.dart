import 'package:flutter/widgets.dart';
import 'package:nativeapi_flutter/nativeapi_flutter.dart';

/// Window helpers available through BuildContext.
extension WindowContext on BuildContext {
  /// Returns the current native window.
  Window? get currentWindow => WindowManager.instance.getCurrent();

  /// Returns whether the window is maximized.
  bool get isWindowMaximized => currentWindow?.isMaximized ?? false;

  /// Returns whether the window is maximized.
  bool get isWindowMinimized => currentWindow?.isMinimized ?? false;

  /// Returns whether the window is restored (not maximized or minimized).
  bool get isWindowRestored => !isWindowMaximized && !isWindowMinimized;

  /// Sets the window's content size.
  void setWindowSize(Size size) {
    currentWindow?.contentSize = size.toNative();
  }

  /// Sets the window's minimum content size.
  void setWindowMinimumSize(Size size) {
    currentWindow?.minimumSize = size.toNative();
  }

  /// Sets the window's maximum content size.
  void setWindowMaximumSize(Size size) {
    currentWindow?.maximumSize = size.toNative();
  }

  /// Sets the window's title.
  void setWindowTitle(String title) {
    currentWindow?.title = title;
  }

  /// Centers the window on the screen.
  void centerWindow() {
    currentWindow?.center();
  }

  /// Minimizes the window.
  void minimizeWindow() {
    currentWindow?.minimize();
  }

  /// Maximizes the window.
  void maximizeWindow() {
    currentWindow?.maximize();
  }

  /// Restores the window to its previous size.
  void restoreWindow() {
    currentWindow?.restore();
  }

  /// Toggles between maximized and restored states.
  void toggleMaximizeWindow() {
    if (isWindowMaximized) {
      restoreWindow();
    } else {
      maximizeWindow();
    }
  }

  /// Closes the window.
  void closeWindow() {
    currentWindow?.close();
  }

  /// Hides the native title bar.
  void hideTitleBar() {
    currentWindow?.titleBarStyle = TitleBarStyle.hidden;
  }

  /// Restores the native title bar.
  void showTitleBar() {
    currentWindow?.titleBarStyle = TitleBarStyle.normal;
  }

  /// Sets the window's title bar style.
  void setWindowTitleBarStyle(TitleBarStyle style) {
    currentWindow?.titleBarStyle = style;
  }

  /// Returns a widget that allows dragging the window.
  Widget dragToMoveArea({required Widget child}) {
    return DragToMoveArea(window: currentWindow, child: child);
  }
}
