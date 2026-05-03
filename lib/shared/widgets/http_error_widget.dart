import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HttpErrorWidget extends StatelessWidget {
  const HttpErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Get.theme.hintColor, size: 100),
            Text(
              'Error',
              style: TextStyle(color: Get.theme.hintColor, fontSize: 35,),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      ListView()
    ]);
  }
}
