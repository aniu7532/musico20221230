import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musico/const/app_data.dart';

class FixedScaleTextWidget extends StatelessWidget {
  const FixedScaleTextWidget({
    Key? key,
    this.max = 1.0,
    required this.child,
  }) : super(key: key);

  final double max;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var scale = min(max, data.textScaleFactor);

    if (AppData.useScaleText) {
      return child;
    }

    return MediaQuery(
      data: data.copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}
