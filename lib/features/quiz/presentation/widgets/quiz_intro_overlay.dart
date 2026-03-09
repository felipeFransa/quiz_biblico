import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class QuizIntroOverlay extends StatefulWidget {
  final String verse;
  final String reference;
  final VoidCallback onFinished;

  const QuizIntroOverlay({
    super.key,
    required this.verse,
    required this.reference,
    required this.onFinished,
  });

  @override
  State<QuizIntroOverlay> createState() => _QuizIntroOverlayState();
}

class _QuizIntroOverlayState extends State<QuizIntroOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _controller.forward().then((_) => widget.onFinished());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppTheme.celestialDecoration,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Divine Glow Effect
                  Transform.scale(
                    scale: _glowAnimation.value,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.divineGold.withValues(alpha: 0.2),
                            AppTheme.divineGold.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: AppTheme.divineGold,
                          size: 48,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          widget.verse,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppTheme.primaryBlue,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.reference,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.divineGold,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
