import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class ComboIndicator extends StatelessWidget {
  final int combo;

  const ComboIndicator({super.key, required this.combo});

  @override
  Widget build(BuildContext context) {
    if (combo < 2) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFFD700)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            'x$combo',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.08, 1.08),
          duration: 600.ms,
          curve: Curves.easeInOut,
        );
  }
}

class ScoreBar extends StatelessWidget {
  final int score;
  final int combo;
  final double progress;

  const ScoreBar({
    super.key,
    required this.score,
    required this.combo,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: AppTheme.accent, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$score pts',
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            ComboIndicator(combo: combo),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppTheme.cardBg,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.accent),
          ),
        ),
      ],
    );
  }
}
