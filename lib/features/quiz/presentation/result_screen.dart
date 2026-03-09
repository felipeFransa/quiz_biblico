import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/quiz_provider.dart';
import '../../gamification/providers/progress_provider.dart';
import '../../../core/theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final session = ref.watch(quizProvider);
        final stats = ref.watch(progressProvider);
        final theme = Theme.of(context);
        final isPerfect = session.score == session.questions.length && session.questions.isNotEmpty;
        final xp = 30 + (session.score * 10) + (isPerfect ? 50 : 0);
        final percentage = session.questions.isNotEmpty
            ? (session.score / session.questions.length * 100).round()
            : 0;

        if (isPerfect) _confettiController.play();

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Celestial background
              Container(decoration: AppTheme.celestialDecoration),

              // Golden glow behind score circle
              Positioned(
                top: MediaQuery.of(context).size.height * 0.18,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        isPerfect
                            ? AppTheme.divineGold.withValues(alpha: 0.2)
                            : AppTheme.primaryBlue.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Header badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isPerfect
                                ? [AppTheme.divineGold, Colors.amber]
                                : [AppTheme.primaryBlue, AppTheme.primaryBlue.withValues(alpha: 0.7)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          isPerfect ? '✨ PERFEITO! GLÓRIA A DEUS! ✨' : 'QUIZ CONCLUÍDO',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Animated Score Circle
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer ring
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isPerfect
                                      ? AppTheme.divineGold.withValues(alpha: 0.3)
                                      : AppTheme.primaryBlue.withValues(alpha: 0.15),
                                  width: 12,
                                ),
                              ),
                            ),
                            // Inner circle
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: isPerfect
                                        ? AppTheme.divineGold.withValues(alpha: 0.3)
                                        : AppTheme.primaryBlue.withValues(alpha: 0.1),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$percentage%',
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: isPerfect ? AppTheme.divineGold : AppTheme.primaryBlue,
                                    ),
                                  ),
                                  Text(
                                    '${session.score}/${session.questions.length} acertos',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Inspirational quote on result
                      Text(
                        isPerfect
                            ? '"Tudo posso naquele que me fortalece."'
                            : '"Continue buscando a sabedoria de Deus."',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        isPerfect ? '— Filipenses 4:13' : '— Provérbios 3:13',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.divineGold,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // XP Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.divineGold.withValues(alpha: 0.08),
                              AppTheme.divineGold.withValues(alpha: 0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recompensa ganha!',
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    isPerfect ? 'Bônus de pontuação perfeita!' : 'Continue praticando!',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+$xp XP',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: AppTheme.divineGold,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withValues(alpha: 0.8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Share.share('Acertei $percentage% no Bíblia Quiz! Nível ${stats.level}. Venha testar seus conhecimentos bíblicos! ✝️');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.ios_share_rounded, color: Colors.white, size: 22),
                                  const SizedBox(width: 12),
                                  Text(
                                    'COMPARTILHAR',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'VOLTAR AO INÍCIO',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Confetti on top
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [AppTheme.divineGold, Colors.amber, Colors.white, AppTheme.primaryBlue],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
