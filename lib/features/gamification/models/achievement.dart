import 'package:flutter/material.dart';
import '../../../shared/models/user_stats.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int target;
  final int Function(UserStats stats) getProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.target,
    required this.getProgress,
  });

  bool isUnlocked(UserStats stats) => getProgress(stats) >= target;
  double getPercent(UserStats stats) => (getProgress(stats) / target).clamp(0.0, 1.0);
}
