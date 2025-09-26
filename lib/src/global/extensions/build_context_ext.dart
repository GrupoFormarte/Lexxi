import 'package:flutter/material.dart';
import 'package:lexxi/src/global/device_size.dart';

extension BuildContextExt on BuildContext {
  bool get darkmode {
    // return Theme.of(this).brightness == Brightness.dark;
    return true;
  }

  TextTheme get textTheme {
    return Theme.of(this).textTheme;
  }

  bool get isSmall{

    return DeviceSizeClassifier.isMall(this);
  }


}
