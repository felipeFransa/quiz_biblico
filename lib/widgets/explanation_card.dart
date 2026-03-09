import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class ExplanationCard extends StatelessWidget {
  final String explanation;
  final bool isCorrect;

  const ExplanationCard({
    super.key,
    required this.explanation,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppTheme.correct : AppTheme.wrong;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.lightbulb_rounded : Icons.info_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              explanation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 0.3, duration: 300.ms, curve: Curves.easeOut)
        .fadeIn(duration: 300.ms);
  }
}
