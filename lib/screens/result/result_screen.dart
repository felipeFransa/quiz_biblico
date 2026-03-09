import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/enums.dart';
import '../../data/models/quiz_question.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import '../quiz/quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final QuizResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryMid, AppTheme.primaryDeep],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                _buildHeader().animate().fadeIn(duration: 500.ms),
                const SizedBox(height: 32),
                _buildScoreCard(context).animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideY(begin: 0.2, delay: 200.ms),
                const SizedBox(height: 20),
                _buildStats(context).animate()
                    .fadeIn(delay: 350.ms, duration: 500.ms),
                const Spacer(),
                _buildButtons(context).animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms)
                    .slideY(begin: 0.2, delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final String message;
    if (result.accuracy >= 0.9) {
      message = '🏆 Excelente!';
    } else if (result.accuracy >= 0.6) {
      message = '⭐ Bom trabalho!';
    } else if (result.accuracy >= 0.3) {
      message = '📖 Continue estudando!';
    } else {
      message = '💪 Não desista!';
    }

    return Column(
      children: [
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        _buildStars(),
      ],
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            i < result.stars ? Icons.star_rounded : Icons.star_outline_rounded,
            color: AppTheme.accent,
            size: 32,
          )
              .animate(delay: (i * 150 + 600).ms)
              .scale(begin: const Offset(0, 0), duration: 400.ms,
                  curve: Curves.elasticOut),
        );
      }),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: '${result.score}',
              label: 'Pontuação',
              icon: Icons.star_rounded,
              color: AppTheme.accent,
            ),
          ),
          Container(width: 1, height: 60, color: Colors.white12),
          Expanded(
            child: _StatItem(
              value: '${(result.accuracy * 100).round()}%',
              label: 'Precisão',
              icon: Icons.percent_rounded,
              color: AppTheme.correct,
            ),
          ),
          Container(width: 1, height: 60, color: Colors.white12),
          Expanded(
            child: _StatItem(
              value: '${result.correctAnswers}/${result.totalQuestions}',
              label: 'Acertos',
              icon: Icons.check_circle_rounded,
              color: const Color(0xFF60A5FA),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            icon: Icons.local_fire_department_rounded,
            label: 'Melhor sequência',
            value: '${result.bestCombo}x',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoTile(
            icon: Icons.speed_rounded,
            label: 'Dificuldade',
            value: result.difficulty.displayName,
            color: const Color(0xFFA78BFA),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final quiz = context.read<QuizProvider>();
            final settings = context.read<SettingsProvider>();
            await quiz.startQuiz(
              difficulty: settings.difficulty,
              category: result.category,
            );
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const QuizScreen()),
              );
            }
          },
          child: const Text('Jogar Novamente'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () =>
              Navigator.popUntil(context, (r) => r.isFirst),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: const BorderSide(color: Colors.white30),
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Voltar ao Menu'),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
