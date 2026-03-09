import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Premium Palette
  static const Color primaryBlue = Color(0xFF2A3175);
  static const Color accentGreen = Color(0xFF00D084);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color textMain = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color wrong = Color(0xFFF43F5E);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color gold = Color(0xFFFFD700);
  static const Color divineGold = Color(0xFFC5A059); // Dourado mais sóbrio e metálico
  static const Color celestialBlue = Color(0xFFE0E7FF);

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: accentGreen,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textMain,
        error: wrong,
        outline: cardBorder,
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: primaryBlue,
          letterSpacing: -1,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textMain,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textMain,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: textMain,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 15,
          color: textSecondary,
          height: 1.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: background,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          elevation: 4,
          shadowColor: primaryBlue.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        foregroundColor: textMain,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textMain,
        ),
        iconTheme: const IconThemeData(color: primaryBlue, size: 24),
      ),
    );
  }

  // Helper for Premium Decoration
  static BoxDecoration premiumShadow = BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.05),
        offset: const Offset(0, 10),
        blurRadius: 30,
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration celestialDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        celestialBlue,
        background,
      ],
    ),
  );

  static Color get goldGlow => divineGold.withValues(alpha: 0.3);
}
