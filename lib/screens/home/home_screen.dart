import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/enums.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/ads_provider.dart';
import '../category/category_screen.dart';
import '../quiz/quiz_screen.dart';
import '../stats/stats_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 48),
                _buildHeader()
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, duration: 600.ms),
                const Spacer(),
                _buildMenuButtons(context)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, duration: 600.ms),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.accent.withValues(alpha: 0.3),
                AppTheme.accent.withValues(alpha: 0.05),
              ],
            ),
            border:
                Border.all(color: AppTheme.accent.withValues(alpha: 0.5), width: 2),
          ),
          child: const Center(
            child: Text('✝️', style: TextStyle(fontSize: 50)),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'BIBLE QUIZ',
          style: TextStyle(
            color: AppTheme.accent,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Teste seu conhecimento bíblico',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context) {
    return Column(
      children: [
        _HomeButton(
          icon: Icons.play_arrow_rounded,
          label: 'Jogar',
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
          onTap: () => _showDifficultyDialog(context),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _HomeButton(
                icon: Icons.category_rounded,
                label: 'Categorias',
                small: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CategoryScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HomeButton(
                icon: Icons.bar_chart_rounded,
                label: 'Estatísticas',
                small: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatsScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _HomeButton(
          icon: Icons.settings_rounded,
          label: 'Configurações',
          small: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          ),
        ),
      ],
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha a dificuldade',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...Difficulty.values.map((d) => _DifficultyTile(
                  difficulty: d,
                  isSelected: settings.difficulty == d,
                  onTap: () async {
                    await settings.setDifficulty(d);
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      _startQuiz(context, difficulty: d);
                    }
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _startQuiz(BuildContext context,
      {required Difficulty difficulty, QuizCategory? category}) async {
    final quiz = context.read<QuizProvider>();
    final ads = context.read<AdsProvider>();
    await quiz.startQuiz(difficulty: difficulty, category: category);
    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
      ads.maybeShowInterstitial();
    }
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool small;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const _HomeButton({
    required this.icon,
    required this.label,
    this.small = false,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: small ? 16 : 20,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? AppTheme.cardBg : null,
          borderRadius: BorderRadius.circular(18),
          border: gradient == null
              ? Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.2), width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: gradient != null ? AppTheme.primaryDeep : AppTheme.accent,
              size: small ? 22 : 26,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color:
                    gradient != null ? AppTheme.primaryDeep : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: small ? 15 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyTile extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyTile({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  Color get _color {
    switch (difficulty) {
      case Difficulty.easy:
        return AppTheme.correct;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return AppTheme.wrong;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? _color.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? _color.withValues(alpha: 0.6)
                : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.circle, color: _color, size: 12),
            const SizedBox(width: 12),
            Text(
              difficulty.displayName,
              style: TextStyle(
                color: isSelected ? _color : Colors.white70,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Icon(Icons.check_rounded, color: _color, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
