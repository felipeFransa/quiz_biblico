import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final int currentIndex;
  final int total;

  const QuestionCard({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.cardBg, Color(0xFF1E1848)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.accent.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'Pergunta ${currentIndex + 1}/$total',
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            question,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  height: 1.4,
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }
}
