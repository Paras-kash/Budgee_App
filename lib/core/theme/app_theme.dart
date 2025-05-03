import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme colors
  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4), // Primary color
    brightness: Brightness.light,
    secondary: const Color(0xFF625B71), // Secondary color
    tertiary: const Color(0xFF7D5260), // Tertiary color
  );

  // Dark theme colors
  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6750A4),
    brightness: Brightness.dark,
    secondary: const Color(0xFFCCC2DC),
    tertiary: const Color(0xFFEFB8C8),
  );

  // Light theme
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: _textTheme,
      appBarTheme: _appBarTheme(_lightColorScheme),
      floatingActionButtonTheme: _fabTheme(_lightColorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(_lightColorScheme),
      navigationBarTheme: _navigationBarTheme(_lightColorScheme),
      cardTheme: _cardTheme(),
      dialogTheme: _dialogTheme(),
      snackBarTheme: _snackBarTheme(_lightColorScheme),
      scaffoldBackgroundColor: _lightColorScheme.surface,
    );
  }

  // Dark theme
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      textTheme: _textTheme,
      appBarTheme: _appBarTheme(_darkColorScheme),
      floatingActionButtonTheme: _fabTheme(_darkColorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(_darkColorScheme),
      navigationBarTheme: _navigationBarTheme(_darkColorScheme),
      cardTheme: _cardTheme(),
      dialogTheme: _dialogTheme(),
      snackBarTheme: _snackBarTheme(_darkColorScheme),
      scaffoldBackgroundColor: _darkColorScheme.surface,
    );
  }

  // Text Theme using Google Fonts
  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.poppins(),
    bodyMedium: GoogleFonts.poppins(),
    bodySmall: GoogleFonts.poppins(),
    labelLarge: GoogleFonts.poppins(fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.poppins(fontWeight: FontWeight.w500),
  );

  // AppBar Theme
  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: colorScheme.primary),
      titleTextStyle: _textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
    );
  }

  // FAB Theme
  static FloatingActionButtonThemeData _fabTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  // Elevated Button Theme
  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(colorScheme.primary),
        foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
        elevation: WidgetStateProperty.all(2),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Navigation Bar Theme
  static NavigationBarThemeData _navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      iconTheme: WidgetStateProperty.all(
        IconThemeData(size: 24, color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  // Card Theme
  static CardTheme _cardTheme() {
    return CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  // Dialog Theme
  static DialogTheme _dialogTheme() {
    return DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    );
  }

  // SnackBar Theme
  static SnackBarThemeData _snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: _textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
