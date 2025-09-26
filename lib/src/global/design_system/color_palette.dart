// design_system/color_palette.dart
// Sistema de Paleta de Colores Organizado para Formarte App

import 'package:flutter/material.dart';

/// Sistema de colores organizado por categorías y usos específicos
abstract class ColorPalette {
  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES PRIMARIOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Color principal de la marca - Azul oscuro corporativo
  // static const Color primary = Color(0xFF2C314A);
  // static const Color primary = Color(0xFF151f6d);
  static const Color primary = Color(0xFF151f6d);

  /// Color secundario - Verde agua para acciones positivas
  static const Color secondary = Color(0xFFff6a14);

  /// Color terciario - Cian para efectos y highlights
  static const Color tertiary = Color(0xFFff6a14);

  ///nuevo color
  ///
  // static const

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES SEMÁNTICOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Verde - Respuestas correctas, éxito, confirmación
  static const Color success = Color(0xFF3BF4B5);

  /// Amarillo dorado - Advertencias, puntos, medallas
  static const Color warning = Color(0xFFFCA700);

  /// Rojo - Errores, respuestas incorrectas
  static const Color error = Color(0xFFE53E3E);

  /// Azul claro - Información, enlaces
  static const Color info = Color(0xFF3BD8F4);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES NEUTROS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Blanco puro
  static const Color white = Color(0xFFFFFFFF);

  /// Negro puro
  static const Color black = Color(0xFF000000);

  /// Gris claro - Bordes, divisores
  static const Color greyLight = Color(0xFFDDDDDD);

  /// Gris medio - Texto secundario
  static const Color greyMedium = Color(0xFFB0B0B0);

  /// Gris oscuro - Texto deshabilitado
  static const Color greyDark = Color(0xFF787878);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES DE SUPERFICIE (MODO OSCURO)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Superficie principal modo oscuro
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Superficie secundaria modo oscuro
  static const Color surfaceDarkSecondary = Color(0xFF121212);

  /// Tarjetas modo oscuro
  static const Color cardDark = Color(0xFF2C2C2C);

  /// Tarjetas modo oscuro alternativas
  static const Color cardDarkAlt = Color(0xFF1A1A1A);

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PRINCIPALES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gradiente principal verde-cian
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment(1.18, -1.16),
    end: Alignment(-0.58, 0.26),
    colors: [secondary, tertiary],
  );

  /// Gradiente de acción con transparencia
  static const LinearGradient gradientAction = LinearGradient(
    begin: Alignment(1.18, -1.16),
    end: Alignment(-0.58, 0.26),
    colors: [
      Color(0xE63BD8F4), // info con 90% opacidad
      Color(0xE63CF7E9), // tertiary con 90% opacidad
    ],
  );

  /// Gradiente neutro (blanco)
  static const LinearGradient gradientNeutral = LinearGradient(
    colors: [white, white],
  );

  /// Gradiente gris con transparencia
  static const LinearGradient gradientGrey = LinearGradient(
    begin: Alignment(-0.7, -1.0),
    end: Alignment.center,
    colors: [
      Color(0x38F0EFEF), // greyLight con 22% opacidad
      Color(0x38787878), // greyDark con 22% opacidad
    ],
  );

  /// Gradiente azul oscuro sólido
  static const LinearGradient gradientDark = LinearGradient(
    begin: Alignment(1.18, -1.16),
    end: Alignment(-0.58, 0.26),
    colors: [primary, primary],
  );

  /// Gradiente de fondo modo oscuro
  static const LinearGradient gradientDarkSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceDark, surfaceDarkSecondary],
  );

  /// Gradiente para tarjetas modo oscuro
  static const LinearGradient gradientDarkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardDark, cardDarkAlt],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES CONTEXTUALES POR NIVEL DE RENDIMIENTO
  // ═══════════════════════════════════════════════════════════════════════════

  /// Nivel Superior - Verde brillante
  static const Color levelSuperior = Color(0xFF00E676);

  /// Nivel Alto - Verde estándar
  static const Color levelHigh = secondary;

  /// Nivel Medio - Amarillo
  static const Color levelMedium = warning;

  /// Nivel Básico - Naranja
  static const Color levelBasic = Color(0xFFFF9800);

  /// Nivel Bajo - Rojo
  static const Color levelLow = error;

  // ═══════════════════════════════════════════════════════════════════════════
  // MÉTODOS DE UTILIDAD
  // ═══════════════════════════════════════════════════════════════════════════

  /// Obtiene el color según el nivel de rendimiento
  static Color getPerformanceColor(double percentage) {
    if (percentage >= 90) return levelSuperior;
    if (percentage >= 75) return levelHigh;
    if (percentage >= 60) return levelMedium;
    if (percentage >= 40) return levelBasic;
    return levelLow;
  }

  /// Obtiene el gradiente según el nivel de rendimiento
  static LinearGradient getPerformanceGradient(double percentage) {
    final color = getPerformanceColor(percentage);
    return LinearGradient(
      begin: const Alignment(1.18, -1.16),
      end: const Alignment(-0.58, 0.26),
      colors: [color, color.withOpacity(0.8)],
    );
  }

  /// Colores con transparencia para overlays
  static Color withAlpha(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES TEMÁTICOS ADAPTIVOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Color de texto adaptivo al tema
  static Color adaptiveTextColor(bool isDark) {
    return isDark ? white : primary;
  }

  /// Color de superficie adaptivo al tema
  static Color adaptiveSurfaceColor(bool isDark) {
    return isDark ? surfaceDark : white;
  }

  /// Gradiente adaptivo al tema
  static LinearGradient adaptiveGradient(bool isDark) {
    return isDark ? gradientPrimary : gradientNeutral;
  }
}

/// Extensión para BuildContext para acceso fácil a colores
extension ColorPaletteExtension on BuildContext {
  /// Verifica si está en modo oscuro
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  /// Color de texto adaptivo
  Color get adaptiveTextColor => ColorPalette.adaptiveTextColor(isDarkMode);

  /// Color de superficie adaptivo
  Color get adaptiveSurfaceColor =>
      ColorPalette.adaptiveSurfaceColor(isDarkMode);

  /// Gradiente adaptivo
  LinearGradient get adaptiveGradient =>
      ColorPalette.adaptiveGradient(isDarkMode);

  /// Acceso rápido a colores principales
  Color get primaryColor => ColorPalette.primary;
  Color get secondaryColor => ColorPalette.secondary;
  Color get tertiaryColor => ColorPalette.tertiary;
  Color get successColor => ColorPalette.success;
  Color get errorColor => ColorPalette.error;
  Color get warningColor => ColorPalette.warning;
}
