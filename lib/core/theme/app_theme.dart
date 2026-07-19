import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color tealAccent = Color(0xFF18FFFF);
  static const Color coralAccent = Color(0xFFFF6E40);
  static const Color deepSlate = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);

  // Light theme colors
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF0D9488);

  static ThemeData get stitchDarkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepSlate,
      colorScheme: const ColorScheme.dark(
        primary: tealAccent,
        secondary: coralAccent,
        surface: surfaceColor,
      ),
      useMaterial3: true,

      // Typography
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            displayMedium: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            displaySmall: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineLarge: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineMedium: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            headlineSmall: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            titleLarge: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            titleMedium: GoogleFonts.outfit(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            titleSmall: GoogleFonts.outfit(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

      // Component Themes
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tealAccent,
          foregroundColor: deepSlate,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static ThemeData get stitchLightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        secondary: coralAccent,
        surface: lightSurface,
        onSurface: const Color(0xFF1E293B),
      ),
      useMaterial3: true,

      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
            displayMedium: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
            displaySmall: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
            headlineLarge: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
            headlineMedium: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            headlineSmall: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            titleLarge: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
            titleMedium: GoogleFonts.outfit(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
            titleSmall: GoogleFonts.outfit(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),

      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
