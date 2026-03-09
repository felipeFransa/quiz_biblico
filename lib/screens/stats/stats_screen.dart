import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/stats_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas')),
      body: Consumer<StatsProvider>(
        builder: (context, stats, _) {
          final cards = [
            _StatCard(
              icon: Icons.sports_esports_rounded,
              label: 'Partidas Jogadas',
              value: '${stats.totalGames}',
              color: const Color(0xFF60A5FA),
            ),
            _StatCard(
              icon: Icons.check_circle_rounded,
              label: 'Acertos Totais',
              value: '${stats.totalCorrect}',
              color: AppTheme.correct,
            ),
            _StatCard(
              icon: Icons.percent_rounded,
              label: 'Precisão Geral',
              value: '${(stats.overallAccuracy * 100).round()}%',
              color: const Color(0xFFA78BFA),
            ),
            _StatCard(
              icon: Icons.local_fire_department_rounded,
              label: 'Melhor Sequência',
              value: '${stats.bestStreak}x',
              color: Colors.orange,
            ),
            _StatCard(
              icon: Icons.star_rounded,
              label: 'Melhor Pontuação',
              value: '${stats.bestScore}',
              color: AppTheme.accent,
            ),
          ];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: stats.totalGames == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📊',
                            style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma partida jogada ainda!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white54),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    itemCount: cards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (_, i) => cards[i]
                        .animate()
                        .fadeIn(delay: (i * 80).ms, duration: 400.ms)
                        .scale(delay: (i * 80).ms, duration: 400.ms),
                  ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
