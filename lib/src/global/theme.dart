// DEPRECATED: Este archivo ha sido reemplazado por el nuevo sistema de diseño
// Use: import 'package:lexxi/src/global/design_system/theme_system.dart';

import 'package:flutter/material.dart';
import 'package:lexxi/src/global/design_system/theme_system.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';

/// @deprecated Use ThemeSystem.lightTheme y ThemeSystem.darkTheme en su lugar
ThemeData getTheme(BuildContext context) {
  if (context.darkmode) {
    return ThemeSystem.darkTheme;
  }
  return ThemeSystem.lightTheme;
}
