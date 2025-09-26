// design_system/theme_system.dart
// Sistema de Tema Unificado para Formarte App

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_palette.dart';
import 'typography.dart';

/// Sistema de tema centralizado que combina colores y tipografía
abstract class ThemeSystem {
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA CLARO
  // ═══════════════════════════════════════════════════════════════════════════
  
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Esquema de colores
    colorScheme: const ColorScheme.light(
      primary: ColorPalette.primary,
      secondary: ColorPalette.secondary,
      tertiary: ColorPalette.tertiary,
      surface: ColorPalette.white,
      error: ColorPalette.error,
      onPrimary: ColorPalette.white,
      onSecondary: ColorPalette.primary,
      onTertiary: ColorPalette.primary,
      onSurface: ColorPalette.primary,
      onError: ColorPalette.white,
      outline: ColorPalette.greyLight,
      outlineVariant: ColorPalette.greyMedium,
    ),
    
    // Tipografía
    textTheme: AppTypography.lightTextTheme,
    
    // Color de fondo principal (mantener como estaba originalmente)
    scaffoldBackgroundColor: ColorPalette.white,
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: ColorPalette.primary,
      foregroundColor: ColorPalette.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: ColorPalette.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    
    // Botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.primary,
        foregroundColor: ColorPalette.white,
        textStyle: AppTypography.button,
        elevation: 2,
        shadowColor: ColorPalette.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Botones de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorPalette.primary,
        textStyle: AppTypography.buttonSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Botones outlined
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorPalette.primary,
        side: const BorderSide(color: ColorPalette.primary),
        textStyle: AppTypography.buttonSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Campos de entrada
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorPalette.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.greyLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.greyLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.error),
      ),
      labelStyle: AppTypography.inputHint.copyWith(
        color: ColorPalette.greyMedium,
      ),
      hintStyle: AppTypography.inputHint.copyWith(
        color: ColorPalette.greyMedium,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    // Tarjetas
    cardTheme: CardThemeData(
      color: ColorPalette.white,
      elevation: 2,
      shadowColor: ColorPalette.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // Divisores
    dividerTheme: const DividerThemeData(
      color: ColorPalette.greyLight,
      thickness: 1,
      space: 1,
    ),
    
    // IconTheme
    iconTheme: const IconThemeData(
      color: ColorPalette.primary,
      size: 24,
    ),
    
    // BottomNavigationBar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorPalette.white,
      selectedItemColor: ColorPalette.primary,
      unselectedItemColor: ColorPalette.greyMedium,
      selectedLabelStyle: AppTypography.navigation,
      unselectedLabelStyle: AppTypography.navigation,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: ColorPalette.greyLight,
      selectedColor: ColorPalette.secondary,
      labelStyle: AppTypography.labelMedium,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA OSCURO
  // ═══════════════════════════════════════════════════════════════════════════
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Esquema de colores
    colorScheme: const ColorScheme.dark(
      primary: ColorPalette.secondary,
      secondary: ColorPalette.tertiary,
      tertiary: ColorPalette.warning,
      surface: ColorPalette.surfaceDark,
      error: ColorPalette.error,
      onPrimary: ColorPalette.primary,
      onSecondary: ColorPalette.primary,
      onTertiary: ColorPalette.primary,
      onSurface: ColorPalette.white,
      onError: ColorPalette.white,
      outline: ColorPalette.greyDark,
      outlineVariant: ColorPalette.greyMedium,
    ),
    
    // Tipografía
    textTheme: AppTypography.darkTextTheme,
    
    // Color de fondo principal (mantener como estaba originalmente - azul oscuro)
    scaffoldBackgroundColor: ColorPalette.primary, // Era AppColors.blueDark
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: ColorPalette.surfaceDark,
      foregroundColor: ColorPalette.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: ColorPalette.white,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    
    // Botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorPalette.secondary,
        foregroundColor: ColorPalette.primary,
        textStyle: AppTypography.button,
        elevation: 4,
        shadowColor: ColorPalette.secondary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Botones de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorPalette.secondary,
        textStyle: AppTypography.buttonSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Botones outlined
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorPalette.secondary,
        side: const BorderSide(color: ColorPalette.secondary),
        textStyle: AppTypography.buttonSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    
    // Campos de entrada
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorPalette.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.greyDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.greyDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.secondary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorPalette.error),
      ),
      labelStyle: AppTypography.inputHint.copyWith(
        color: ColorPalette.greyMedium,
      ),
      hintStyle: AppTypography.inputHint.copyWith(
        color: ColorPalette.greyMedium,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    // Tarjetas
    cardTheme: CardThemeData(
      color: ColorPalette.cardDark,
      elevation: 4,
      shadowColor: ColorPalette.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // Divisores
    dividerTheme: const DividerThemeData(
      color: ColorPalette.greyDark,
      thickness: 1,
      space: 1,
    ),
    
    // IconTheme
    iconTheme: const IconThemeData(
      color: ColorPalette.secondary,
      size: 24,
    ),
    
    // BottomNavigationBar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorPalette.surfaceDark,
      selectedItemColor: ColorPalette.secondary,
      unselectedItemColor: ColorPalette.greyMedium,
      selectedLabelStyle: AppTypography.navigation,
      unselectedLabelStyle: AppTypography.navigation,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: ColorPalette.greyDark,
      selectedColor: ColorPalette.secondary,
      labelStyle: AppTypography.labelMedium.copyWith(color: ColorPalette.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MÉTODOS DE UTILIDAD
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Obtiene el tema según el modo
  static ThemeData getTheme(bool isDark) {
    return isDark ? darkTheme : lightTheme;
  }
  
  /// Configuración de overlay del sistema
  static SystemUiOverlayStyle getSystemOverlayStyle(bool isDark) {
    return isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
  }
}

/// Extensión para BuildContext para acceso fácil al tema
extension ThemeSystemExtension on BuildContext {
  /// Verifica si está en modo oscuro
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  /// Obtiene el esquema de colores actual
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Acceso rápido a colores primarios
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get surfaceColor => colorScheme.surface;
  
  /// Acceso rápido a estilos de texto
  TextStyle get headlineStyle => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get titleStyle => Theme.of(this).textTheme.titleLarge!;
  TextStyle get bodyStyle => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get captionStyle => Theme.of(this).textTheme.bodySmall!;
}