import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';

Color blackToWhite(BuildContext context) {
  return context.darkmode ? AppColors.white : AppColors.blueDark;
}

Color whiteToBlack(BuildContext context) {
  return context.darkmode ? AppColors.blueDark : AppColors.white;
}

Gradient whiteToGradienGreen(BuildContext context) {
  return context.darkmode
      ? AppColors.linealGrdientGreen
      : AppColors.linearGradientDefault;
}

Gradient gradienGreenTowhite(BuildContext context) {
  return context.darkmode
      ? AppColors.linearGradientDefault
      : AppColors.linealGrdientGreen;
}

Gradient blueDarkToGradienGreen(BuildContext context) {
  return context.darkmode
      ? AppColors.linealGrdientGreen
      : AppColors.linealGradientBlueDark;
}
Gradient gradientGreenToBlueDark(BuildContext context) {
  return context.darkmode
      ? AppColors. linealGradientBlueDark
      : AppColors.linealGrdientGreen;
}
