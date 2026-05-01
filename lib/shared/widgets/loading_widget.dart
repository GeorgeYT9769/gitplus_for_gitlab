import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

import 'expressive_loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: ExpressiveLoadingIndicator(
          color: Theme.of(context).colorScheme.tertiary,
          constraints: const BoxConstraints(
            minWidth: 64.0,
            minHeight: 64.0,
            maxWidth: 64.0,
            maxHeight: 64.0,
          ),
          polygons: [
            MaterialShapes.softBurst,
            MaterialShapes.pentagon,
            MaterialShapes.pill,
          ],
          semanticsLabel: 'Loading',
          semanticsValue: 'In progress',
        )
      ),
      ListView()
    ]);
  }
}
