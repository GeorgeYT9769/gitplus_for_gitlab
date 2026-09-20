mport 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gitplus_for_gitlab/shared/data/sp_storage.dart';

class ThemeUtils {
  static Color computeIluminance(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  static Color? themedIconColor(Color? originalColor) {
    try {
      final sp = Get.find<SPStorage>();
      if (sp.getMonochromeIcons().value) {
        return Get.theme.colorScheme.onSurfaceVariant;
      }
    } catch (_) {}
    return originalColor;
  }
}
