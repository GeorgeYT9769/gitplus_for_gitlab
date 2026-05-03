import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.question_mark, color: Get.theme.hintColor, size: 100),
            Text(
              'Empty',
              style: TextStyle(color: Get.theme.hintColor, fontSize: 35),
            ),
          ],
        ),
      ),
      ListView()
    ]);
  }
}
