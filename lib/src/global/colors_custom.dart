// DEPRECATED: Este archivo ha sido reemplazado por el nuevo sistema de colores
// Use: import 'package:lexxi/src/global/design_system/color_palette.dart';

import 'package:lexxi/src/global/design_system/color_palette.dart';

// Exportar todo del nuevo sistema para fácil migración
export 'package:lexxi/src/global/design_system/color_palette.dart';

/// @deprecated Use ColorPalette en lugar de AppColors
/// 
/// Mapeo de compatibilidad hacia atrás:
/// - AppColors.blueDark -> ColorPalette.primary
/// - AppColors.green -> ColorPalette.secondary
/// - AppColors.yellowGolden -> ColorPalette.warning
/// - AppColors.linealGrdientGreen -> ColorPalette.gradientPrimary
abstract class AppColors {
  // ===== COMPATIBILIDAD HACIA ATRÁS =====
  // Estos valores mantienen compatibilidad con el código existente
  
  // Colores principales mapeados al nuevo sistema
  static const blueDark = ColorPalette.primary;
  static const white = ColorPalette.white;
  static const green = ColorPalette.secondary;
  static const yellowGolden = ColorPalette.warning;
  static const grey = ColorPalette.greyLight;
  static const greyLight = ColorPalette.greyMedium;

  // Gradientes mapeados al nuevo sistema
  static const linealGrdientGreen = ColorPalette.gradientPrimary;
  static const gradientAction = ColorPalette.gradientAction;
  static const linearGradientDefault = ColorPalette.gradientNeutral;
  static const linealGGrey = ColorPalette.gradientGrey;
  static const linealGradientBlueDark = ColorPalette.gradientDark;
  static const linearGradientDark = ColorPalette.gradientDarkSurface;
  static const linearGradientDarkCard = ColorPalette.gradientDarkCard;
  static const gradientCheck = ColorPalette.gradientPrimary;
}
