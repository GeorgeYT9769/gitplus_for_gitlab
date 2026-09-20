import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const EmptyWidget({
    super.key,
    this.title = 'No Data Found',
    this.message = 'There is nothing to display here right now.',
    this.icon = Icons.folder_open_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Get.theme.colorScheme.primary.withAlpha(120),
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  title.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Get.theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Get.theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListView(physics: const AlwaysScrollableScrollPhysics()),
      ],
    );
  }
}
