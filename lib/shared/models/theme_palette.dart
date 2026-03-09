import 'package:flutter/material.dart';

class ThemePalette {
  final String id;
  final String name;
  final Color primary;
  final Color secondary;
  final Color cardBackground;
  final Color scaffoldBackground;
  final Color textColor;
  final int unlockLevel;

  const ThemePalette({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.cardBackground,
    required this.scaffoldBackground,
    required this.textColor,
    required this.unlockLevel,
  });
}
