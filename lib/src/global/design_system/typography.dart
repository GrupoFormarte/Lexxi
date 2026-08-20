import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'color_palette.dart';

abstract class AppTypography {
  static const String fontFamily = 'Nunito Sans';

  static const double defaultLineHeight = 1.4;
  static const double defaultLetterSpacing = 0.0;

  static double get h1 => 28.sp;
  static double get h2 => 24.sp;
  static double get h3 => 20.sp;
  static double get h4 => 18.sp;

  static double get body1 => 16.sp;
  static double get body2 => 14.sp;

  static double get caption => 12.sp;
  static double get overline => 10.sp;

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w900;
  static const FontWeight black = FontWeight.w900;

  static TextStyle _appFont({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
    List<FontFeature>? fontFeatures,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: height,
      letterSpacing: letterSpacing,
      fontFeatures: fontFeatures,
      fontVariations: [
        FontVariation.weight(fontWeight.value.toDouble()),
      ],
    );
  }

  static TextStyle get displayLarge => _appFont(
    fontSize: h1,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => _appFont(
    fontSize: h2,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: -0.25,
  );

  static TextStyle get displaySmall => _appFont(
    fontSize: h3,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0,
  );

  static TextStyle get headlineLarge => _appFont(
    fontSize: h2,
    fontWeight: bold,
    height: 1.25,
    letterSpacing: -0.25,
  );

  static TextStyle get headlineMedium => _appFont(
    fontSize: h3,
    fontWeight: semiBold,
    height: 1.3,
    letterSpacing: 0,
  );

  static TextStyle get headlineSmall => _appFont(
    fontSize: h4,
    fontWeight: medium,
    height: 1.35,
    letterSpacing: 0.15,
  );

  static TextStyle get titleLarge => _appFont(
    fontSize: 16.0,
    fontWeight: bold,
    height: 1.35,
    letterSpacing: 0.15,
  );

  static TextStyle get titleMedium => _appFont(
    fontSize: 16.0,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static TextStyle get titleSmall => _appFont(
    fontSize: body2,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get bodyLarge => _appFont(
    fontSize: body1,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static TextStyle get bodyLargeItalic => _appFont(
    fontSize: body1,
    fontWeight: regular,
    fontStyle: FontStyle.italic,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static TextStyle get bodyMedium => _appFont(
    fontSize: body2,
    fontWeight: regular,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static TextStyle get bodyMediumItalic => _appFont(
    fontSize: body2,
    fontWeight: regular,
    fontStyle: FontStyle.italic,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static TextStyle get bodySmall => _appFont(
    fontSize: caption,
    fontWeight: regular,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static TextStyle get bodySmallItalic => _appFont(
    fontSize: caption,
    fontWeight: regular,
    fontStyle: FontStyle.italic,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static TextStyle get labelLarge => _appFont(
    fontSize: body2,
    fontWeight: medium,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => _appFont(
    fontSize: caption,
    fontWeight: medium,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => _appFont(
    fontSize: overline,
    fontWeight: medium,
    height: 1.45,
    letterSpacing: 0.5,
  );

  static TextStyle get button => _appFont(
    fontSize: body2,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0.75,
  );

  static TextStyle get buttonSecondary => _appFont(
    fontSize: body2,
    fontWeight: medium,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static TextStyle get inputText => _appFont(
    fontSize: body1,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static TextStyle get inputHint => _appFont(
    fontSize: body1,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static TextStyle get quizOption => _appFont(
    fontSize: h4,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get score => _appFont(
    fontSize: h2,
    fontWeight: extraBold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle get timer => _appFont(
    fontSize: h2,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  static TextStyle get navigation => _appFont(
    fontSize: body2,
    fontWeight: medium,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static TextStyle get primaryText =>
      bodyLarge.copyWith(color: ColorPalette.primary);

  static TextStyle get onWhiteText =>
      bodyLarge.copyWith(color: ColorPalette.primary);

  static TextStyle get onDarkText =>
      bodyLarge.copyWith(color: ColorPalette.white);

  static TextStyle get successText =>
      bodyLarge.copyWith(color: ColorPalette.success);

  static TextStyle get errorText =>
      bodyLarge.copyWith(color: ColorPalette.error);

  static TextStyle get warningText =>
      bodyLarge.copyWith(color: ColorPalette.warning);

  static TextStyle get secondaryText =>
      bodyLarge.copyWith(color: ColorPalette.greyMedium);

  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  static TextStyle getPerformanceTextStyle(double percentage) {
    final color = ColorPalette.getPerformanceColor(percentage);
    return score.copyWith(color: color);
  }

  static TextStyle adaptive(TextStyle style, bool isDark) {
    return style.copyWith(
      color: isDark ? ColorPalette.white : ColorPalette.primary,
    );
  }

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  static TextTheme get lightTextTheme => textTheme.apply(
    bodyColor: ColorPalette.primary,
    displayColor: ColorPalette.primary,
  );

  static TextTheme get darkTextTheme => textTheme.apply(
    bodyColor: ColorPalette.primary,
    displayColor: ColorPalette.primary,
  );
}

extension TypographyExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle adaptiveTextStyle(TextStyle style) {
    final isDark = Theme.of(this).brightness == Brightness.dark;

    return AppTypography.adaptive(style, isDark);
  }

  TextStyle get displayLarge => AppTypography.displayLarge;

  TextStyle get headlineMedium => AppTypography.headlineMedium;

  TextStyle get titleLarge => AppTypography.titleLarge;

  TextStyle get bodyLarge => AppTypography.bodyLarge;

  TextStyle get bodyLargeItalic => AppTypography.bodyLargeItalic;

  TextStyle get bodyMedium => AppTypography.bodyMedium;

  TextStyle get bodyMediumItalic => AppTypography.bodyMediumItalic;

  TextStyle get bodySmallItalic => AppTypography.bodySmallItalic;

  TextStyle get labelMedium => AppTypography.labelMedium;

  TextStyle get buttonStyle => AppTypography.button;

  TextStyle get quizOptionStyle => AppTypography.quizOption;

  TextStyle get scoreStyle => AppTypography.score;

  TextStyle get timerStyle => AppTypography.timer;
}

abstract class FixedSizes {
  static const double tiny = 8.0;
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;
  static const double huge = 32.0;
}