import 'package:flutter/material.dart';

abstract class ColorPalette {
  static const Color primary = Color(0xFF151f6d);

  static const Color primaryLight = Color.fromARGB(255, 53, 70, 169);

  static const LinearGradient gradientBlueBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLight, primary],
  );

  static const Color secondary = Color(0xFFff6a14);

  static const Color tertiary = Color(0xFFff6a14);

  static const Color success = Color(0xFF3BF4B5);

  static const Color warning = Color(0xFFFCA700);

  static const Color error = Color(0xFFE53E3E);

  static const Color info = Color(0xFF3BD8F4);

  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF000000);

  static const Color greyLight = Color(0xFFDDDDDD);

  static const Color greyMedium = Color(0xFFB0B0B0);

  static const Color greyDark = Color(0xFF787878);

  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color surfaceDarkSecondary = Color(0xFF121212);

  static const Color cardDark = Color(0xFF2C2C2C);

  static const Color cardDarkAlt = Color(0xFF1A1A1A);

  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment(1.18, -1.16),
    end: Alignment(-0.58, 0.26),
    colors: [Color.fromARGB(255, 240, 127, 32), Color.fromARGB(255, 240, 127, 32)],
  );

  static const LinearGradient gradientAction = LinearGradient(
    begin: Alignment(1.18, -1.16),
    end: Alignment(-0.58, 0.26),
    colors: [
      Color(0xE63BD8F4), 
      Color(0xE63CF7E9), 
    ],
  );

  static const LinearGradient gradientNeutral = LinearGradient(
    colors: [white, white],
  );

  static const LinearGradient gradientGrey = LinearGradient(
    begin: Alignment(-0.7, -1.0),
    end: Alignment.center,
    colors: [
      Color(0x38F0EFEF),
      Color(0x38787878), 
    ],
  );

  static const LinearGradient gradientDark = LinearGradient(
    begin: Alignment(1.18, -1.16),
    end: Alignment(-0.58, 0.26),
    colors: [primary, primary],
  );

  static const LinearGradient gradientDarkSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceDark, surfaceDarkSecondary],
  );

  static const LinearGradient gradientDarkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardDark, cardDarkAlt],
  );

  static const Color levelSuperior = Color(0xFF00E676);

  static const Color levelHigh = secondary;

  static const Color levelMedium = warning;

  static const Color levelBasic = Color(0xFFFF9800);

  static const Color levelLow = error;

  static Color getPerformanceColor(double percentage) {
    if (percentage >= 90) return levelSuperior;
    if (percentage >= 75) return levelHigh;
    if (percentage >= 60) return levelMedium;
    if (percentage >= 40) return levelBasic;
    return levelLow;
  }

  static LinearGradient getPerformanceGradient(double percentage) {
    final color = getPerformanceColor(percentage);
    return LinearGradient(
      begin: const Alignment(1.18, -1.16),
      end: const Alignment(-0.58, 0.26),
      colors: [color, color.withOpacity(0.8)],
    );
  }

  static Color withAlpha(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color adaptiveTextColor(bool isDark) {
    return isDark ? white : primary;
  }

  static Color adaptiveSurfaceColor(bool isDark) {
    return isDark ? surfaceDark : white;
  }

  static LinearGradient adaptiveGradient(bool isDark) {
    return isDark ? gradientPrimary : gradientNeutral;
  }
}

extension ColorPaletteExtension on BuildContext {
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  Color get adaptiveTextColor => ColorPalette.adaptiveTextColor(isDarkMode);

  Color get adaptiveSurfaceColor =>
      ColorPalette.adaptiveSurfaceColor(isDarkMode);

  LinearGradient get adaptiveGradient =>
      ColorPalette.adaptiveGradient(isDarkMode);

  Color get primaryColor => ColorPalette.primary;
  Color get secondaryColor => ColorPalette.secondary;
  Color get tertiaryColor => ColorPalette.tertiary;
  Color get successColor => ColorPalette.success;
  Color get errorColor => ColorPalette.error;
  Color get warningColor => ColorPalette.warning;
}
