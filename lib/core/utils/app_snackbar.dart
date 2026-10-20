import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/theme.dart';

/// Thin wrapper over GetX snackbars so no widget needs a ScaffoldMessenger.
abstract final class AppSnackbar {
  static void show(String message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          message,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        ),
        backgroundColor: AppColors.surfaceRaised,
        borderRadius: AppRadius.md,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }
}
