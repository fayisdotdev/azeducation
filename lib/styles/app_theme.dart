import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ColorScheme get colorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0057B8), // Deep blue
    onPrimary: Colors.white,
    secondary: Color(0xFF00B894), // Teal accent
    onSecondary: Colors.white,
    error: Color(0xFFD32F2F),
    onError: Colors.white,
    background: Color(0xFFF5F6FA),
    onBackground: Color(0xFF222B45),
    surface: Colors.white,
    onSurface: Color(0xFF222B45),
  );

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: colorScheme.onBackground,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: colorScheme.onBackground,
      ),
      titleLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: colorScheme.primary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      labelStyle: GoogleFonts.poppins(
        color: colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: GoogleFonts.poppins(
        color: colorScheme.onBackground.withOpacity(0.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        elevation: 2,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: colorScheme.primary.withOpacity(0.08),
    ),
    iconTheme: IconThemeData(color: colorScheme.primary),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.secondary,
      foregroundColor: colorScheme.onSecondary,
      elevation: 2,
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.primary.withOpacity(0.08),
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.primary,
      contentTextStyle: GoogleFonts.poppins(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: Colors.white,
      selectedTileColor: colorScheme.primary.withOpacity(0.08),
      iconColor: colorScheme.primary,
    ),
  );
}
