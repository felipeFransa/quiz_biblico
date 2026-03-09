import 'package:flutter/material.dart';
import '../models/theme_palette.dart';

class ThemeConfig {
  static const themes = [
    ThemePalette(
      id: 'holy_light',
      name: 'Luz Sagrada',
      primary: Color(0xFF2196F3),
      secondary: Color(0xFFE3F2FD),
      cardBackground: Colors.white,
      scaffoldBackground: Color(0xFFF5F5F5),
      textColor: Colors.black87,
      unlockLevel: 0,
    ),
    ThemePalette(
      id: 'old_parchment',
      name: 'Pergaminho Antigo',
      primary: Color(0xFF8D6E63),
      secondary: Color(0xFFD7CCC8),
      cardBackground: Color(0xFFF5F5DC),
      scaffoldBackground: Color(0xFFEFEBE9),
      textColor: Color(0xFF3E2723),
      unlockLevel: 3,
    ),
    ThemePalette(
      id: 'night_prayer',
      name: 'Oração Noturna',
      primary: Color(0xFF3F51B5),
      secondary: Color(0xFF1A237E),
      cardBackground: Color(0xFF283593),
      scaffoldBackground: Color(0xFF121212),
      textColor: Colors.white,
      unlockLevel: 7,
    ),
    ThemePalette(
      id: 'golden_temple',
      name: 'Templo Dourado',
      primary: Color(0xFFFFD700),
      secondary: Color(0xFFFFECB3),
      cardBackground: Color(0xFFFFF8E1),
      scaffoldBackground: Color(0xFFFAFAFA),
      textColor: Color(0xFFBF8F00),
      unlockLevel: 15,
    ),
    ThemePalette(
      id: 'divine_purple',
      name: 'Roxo Divino',
      primary: Color(0xFF9C27B0),
      secondary: Color(0xFFE1BEE7),
      cardBackground: Color(0xFFF3E5F5),
      scaffoldBackground: Color(0xFFF8F8F8),
      textColor: Color(0xFF4A148C),
      unlockLevel: 25,
    ),
  ];

  static ThemePalette getTheme(String id) {
    return themes.firstWhere((t) => t.id == id, orElse: () => themes.first);
  }

  static ThemeData createThemeData(ThemePalette palette) {
    return ThemeData(
      primaryColor: palette.primary,
      scaffoldBackgroundColor: palette.scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        primary: palette.primary,
        secondary: palette.secondary,
        surface: palette.cardBackground,
      ),
      cardTheme: CardThemeData(
        color: palette.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: palette.textColor),
        bodyMedium: TextStyle(color: palette.textColor),
      ),
    );
  }
}
