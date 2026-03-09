import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Brand colors
  static const Color primaryDeep = Color(0xFF1A1035);
  static const Color primaryMid = Color(0xFF2D1B69);
  static const Color accent = Color(0xFFFFD700);
  static const Color accentLight = Color(0xFFFFF3B0);
  static const Color correct = Color(0xFF2ECC71);
  static const Color wrong = Color(0xFFE74C3C);
  static const Color cardBg = Color(0xFF251C4A);
  static const Color surfaceColor = Color(0xFF1E1540);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDeep,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentLight,
        surface: surfaceColor,
        onPrimary: primaryDeep,
        onSecondary: primaryDeep,
        error: wrong,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: accent,
          letterSpacing: -1,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          color: Color(0xFFB0A8D0),
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: primaryDeep,
          minimumSize: const Size(double.infinity, 58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          elevation: 0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDeep,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
