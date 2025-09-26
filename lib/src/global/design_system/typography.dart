// design_system/typography.dart
// Sistema de Tipografía Organizado para Formarte App

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'color_palette.dart';

/// Sistema de tipografía organizado con escalas consistentes
abstract class AppTypography {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONFIGURACIÓN BASE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Familia de fuente principal - Open Sans
  static const String fontFamily = 'Open Sans';

  /// Altura de línea por defecto
  static const double defaultLineHeight = 1.4;

  /// Espaciado de letras por defecto
  static const double defaultLetterSpacing = 0.0;

  // ═══════════════════════════════════════════════════════════════════════════
  // ESCALA DE TAMAÑOS (RESPONSIVE)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Extra grande - Títulos principales
  static double get h1 => 28.sp;

  /// Grande - Subtítulos principales
  static double get h2 => 24.sp;

  /// Medio grande - Secciones importantes
  static double get h3 => 20.sp;

  /// Medio - Subsecciones
  static double get h4 => 18.sp;

  /// Estándar - Texto principal
  static double get body1 => 16.sp;

  /// Pequeño - Texto secundario
  static double get body2 => 14.sp;

  /// Muy pequeño - Metadatos, ayuda
  static double get caption => 12.sp;

  /// Diminuto - Labels, badges
  static double get overline => 10.sp;

  // ═══════════════════════════════════════════════════════════════════════════
  // PESOS DE FUENTE
  // ═══════════════════════════════════════════════════════════════════════════

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ═══════════════════════════════════════════════════════════════════════════
  // ESTILOS DE TEXTO PRINCIPALES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Título principal de pantalla
  static TextStyle get displayLarge => GoogleFonts.openSans(
        fontSize: h1,
        fontWeight: bold,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// Título secundario de pantalla
  static TextStyle get displayMedium => GoogleFonts.openSans(
        fontSize: h2,
        fontWeight: semiBold,
        height: 1.3,
        letterSpacing: -0.25,
      );

  /// Título pequeño de pantalla
  static TextStyle get displaySmall => GoogleFonts.openSans(
        fontSize: h3,
        fontWeight: medium,
        height: 1.3,
        letterSpacing: 0,
      );

  /// Encabezado principal
  static TextStyle get headlineLarge => GoogleFonts.openSans(
        fontSize: h2,
        fontWeight: bold,
        height: 1.25,
        letterSpacing: -0.25,
      );

  /// Encabezado mediano
  static TextStyle get headlineMedium => GoogleFonts.openSans(
        fontSize: h3,
        fontWeight: semiBold,
        height: 1.3,
        letterSpacing: 0,
      );

  /// Encabezado pequeño
  static TextStyle get headlineSmall => GoogleFonts.openSans(
        fontSize: h4,
        fontWeight: medium,
        height: 1.35,
        letterSpacing: 0.15,
      );

  /// Título grande (mantener configuración original)
  static TextStyle get titleLarge => GoogleFonts.openSans(
        fontSize: 16.0, // Tamaño fijo original
        fontWeight: bold, // Peso original
        height: 1.35,
        letterSpacing: 0.15,
      );

  /// Título mediano (mantener configuración original)
  static TextStyle get titleMedium => GoogleFonts.openSans(
        fontSize: 16.0, // Tamaño fijo original
        height: 1.5,
        letterSpacing: 0.1,
      );

  /// Título pequeño
  static TextStyle get titleSmall => GoogleFonts.openSans(
        fontSize: body2,
        fontWeight: medium,
        height: 1.4,
        letterSpacing: 0.1,
      );

  /// Texto principal grande
  static TextStyle get bodyLarge => GoogleFonts.openSans(
        fontSize: body1,
        fontWeight: regular,
        height: 1.5,
        letterSpacing: 0.5,
      );

  /// Texto principal mediano
  static TextStyle get bodyMedium => GoogleFonts.openSans(
        fontSize: body2,
        fontWeight: regular,
        height: 1.43,
        letterSpacing: 0.25,
      );

  /// Texto principal pequeño
  static TextStyle get bodySmall => GoogleFonts.openSans(
        fontSize: caption,
        fontWeight: regular,
        height: 1.33,
        letterSpacing: 0.4,
      );

  /// Etiquetas y metadatos
  static TextStyle get labelLarge => GoogleFonts.openSans(
        fontSize: body2,
        fontWeight: medium,
        height: 1.43,
        letterSpacing: 0.1,
      );

  /// Etiquetas medianas
  static TextStyle get labelMedium => GoogleFonts.openSans(
        fontSize: caption,
        fontWeight: medium,
        height: 1.33,
        letterSpacing: 0.5,
      );

  /// Etiquetas pequeñas
  static TextStyle get labelSmall => GoogleFonts.openSans(
        fontSize: overline,
        fontWeight: medium,
        height: 1.45,
        letterSpacing: 0.5,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ESTILOS CONTEXTUALES ESPECÍFICOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Estilo para botones principales
  static TextStyle get button => GoogleFonts.openSans(
        fontSize: body2,
        fontWeight: semiBold,
        height: 1.2,
        letterSpacing: 0.75,
      );

  /// Estilo para botones secundarios
  static TextStyle get buttonSecondary => GoogleFonts.openSans(
        fontSize: body2,
        fontWeight: medium,
        height: 1.2,
        letterSpacing: 0.5,
      );

  /// Estilo para campos de entrada
  static TextStyle get inputText => GoogleFonts.openSans(
        fontSize: body1,
        fontWeight: regular,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Estilo para placeholder de campos
  static TextStyle get inputHint => GoogleFonts.openSans(
        fontSize: body1,
        fontWeight: regular,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Estilo para opciones de quiz
  static TextStyle get quizOption => GoogleFonts.openSans(
        fontSize: h4,
        fontWeight: medium,
        height: 1.4,
        letterSpacing: 0.1,
      );

  /// Estilo para puntajes
  static TextStyle get score => GoogleFonts.openSans(
        fontSize: h2,
        fontWeight: extraBold,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// Estilo para temporizadores
  static TextStyle get timer => GoogleFonts.openSans(
        fontSize: h2,
        fontWeight: bold,
        height: 1.2,
        letterSpacing: 0,
        fontFeatures: [const FontFeature.tabularFigures()],
      );

  /// Estilo para navegación
  static TextStyle get navigation => GoogleFonts.openSans(
        fontSize: body2,
        fontWeight: medium,
        height: 1.43,
        letterSpacing: 0.25,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ESTILOS CON COLORES APLICADOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Texto primario (azul oscuro)
  static TextStyle get primaryText => bodyLarge.copyWith(
        color: ColorPalette.primary,
      );

  /// Texto en superficie blanca
  static TextStyle get onWhiteText => bodyLarge.copyWith(
        color: ColorPalette.primary,
      );

  /// Texto en superficie oscura
  static TextStyle get onDarkText => bodyLarge.copyWith(
        color: ColorPalette.white,
      );

  /// Texto de éxito
  static TextStyle get successText => bodyLarge.copyWith(
        color: ColorPalette.success,
      );

  /// Texto de error
  static TextStyle get errorText => bodyLarge.copyWith(
        color: ColorPalette.error,
      );

  /// Texto de advertencia
  static TextStyle get warningText => bodyLarge.copyWith(
        color: ColorPalette.warning,
      );

  /// Texto secundario/gris
  static TextStyle get secondaryText => bodyLarge.copyWith(
        color: ColorPalette.greyMedium,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // MÉTODOS DE UTILIDAD
  // ═══════════════════════════════════════════════════════════════════════════

  /// Aplica color a cualquier estilo de texto
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Aplica peso a cualquier estilo de texto
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Aplica tamaño a cualquier estilo de texto
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Obtiene estilo según nivel de rendimiento
  static TextStyle getPerformanceTextStyle(double percentage) {
    final color = ColorPalette.getPerformanceColor(percentage);
    return score.copyWith(color: color);
  }

  /// Estilo adaptivo según tema
  static TextStyle adaptive(TextStyle style, bool isDark) {
    return style.copyWith(
      color: isDark ? ColorPalette.white : ColorPalette.primary,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA COMPLETO PARA FLUTTER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Genera TextTheme completo para Flutter
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

  /// Genera TextTheme con colores para tema claro (mantener colores originales)
  static TextTheme get lightTextTheme => textTheme.apply(
        bodyColor: ColorPalette.primary, // Era AppColors.blueDark
        displayColor: ColorPalette.primary,
      );

  /// Genera TextTheme con colores para tema oscuro (mantener colores originales)
  static TextTheme get darkTextTheme => textTheme.apply(
        bodyColor: ColorPalette
            .primary, // En el original también era AppColors.blueDark
        displayColor: ColorPalette.primary,
      );
}

/// Extensión para BuildContext para acceso fácil a tipografía
extension TypographyExtension on BuildContext {
  /// Acceso al tema de texto actual
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Obtiene estilo adaptivo al tema actual
  TextStyle adaptiveTextStyle(TextStyle style) {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return AppTypography.adaptive(style, isDark);
  }

  /// Acceso rápido a estilos de texto comunes
  TextStyle get displayLarge => AppTypography.displayLarge;
  TextStyle get headlineMedium => AppTypography.headlineMedium;
  TextStyle get titleLarge => AppTypography.titleLarge;
  TextStyle get bodyLarge => AppTypography.bodyLarge;
  TextStyle get bodyMedium => AppTypography.bodyMedium;
  TextStyle get labelMedium => AppTypography.labelMedium;
  TextStyle get buttonStyle => AppTypography.button;
  TextStyle get quizOptionStyle => AppTypography.quizOption;
  TextStyle get scoreStyle => AppTypography.score;
  TextStyle get timerStyle => AppTypography.timer;
}

/// Constantes para tamaños fijos (cuando no se necesita responsive)
abstract class FixedSizes {
  static const double tiny = 8.0;
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;
  static const double huge = 32.0;
}
