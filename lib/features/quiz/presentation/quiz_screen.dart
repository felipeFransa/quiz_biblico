import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_session.dart';
import '../../../shared/providers/app_providers.dart';
import 'result_screen.dart';
import 'widgets/quiz_intro_overlay.dart';
import '../../../core/theme/app_theme.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  bool _showIntro = true;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(quizProvider);
    final theme = Theme.of(context);

    if (session.status == QuizStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.status == QuizStatus.completed) {
      return const ResultScreen();
    }

    if (_showIntro && session.inspirationVerse != null) {
      return QuizIntroOverlay(
        verse: session.inspirationVerse!,
        reference: session.inspirationReference!,
        onFinished: () => setState(() => _showIntro = false),
      );
    }

    if (session.currentQuestion == null) {
      return const Scaffold(body: Center(child: Text('Nenhuma pergunta encontrada para esta categoria.')));
    }

    final question = session.currentQuestion!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${session.currentIndex + 1} de ${session.questions.length}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.primaryColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.divineGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars_rounded, color: AppTheme.divineGold, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '${session.score}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Celestial background gradient
          Container(decoration: AppTheme.celestialDecoration),

          // Subtle golden watermark (Consistent with Home)
          Positioned(
            top: -40,
            right: -60,
            child: Opacity(
              opacity: 0.04,
              child: Icon(
                Icons.auto_awesome,
                size: 320,
                color: AppTheme.divineGold,
              ),
            ),
          ),
          
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 40),
              if (session.isPartialPool)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.divineGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Últimas ${session.questions.length} perguntas desta categoria',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              // Styled Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (session.currentIndex + 1) / session.questions.length,
                    minHeight: 10,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                    backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  ),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Question Card
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppTheme.divineGold.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.goldGlow,
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          question.text,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.3,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Options
                      ...question.options.map((option) {
                        final isSelected = session.selectedOption == option;
                        final showResult = session.hasAnswered;
                        final isCorrect = question.correctAnswer == option;

                        Color borderColor = theme.colorScheme.outline;
                        Color textColor = theme.colorScheme.onSurface;
                        Color? bgColor = Colors.white;
                        double borderWidth = 1;

                        if (showResult) {
                          if (isCorrect) {
                            borderColor = Colors.green;
                            bgColor = Colors.green.withValues(alpha: 0.05);
                            textColor = Colors.green[800]!;
                            borderWidth = 2;
                          } else if (isSelected) {
                            borderColor = theme.colorScheme.error;
                            bgColor = theme.colorScheme.error.withValues(alpha: 0.05);
                            textColor = theme.colorScheme.error;
                            borderWidth = 2;
                          }
                        } else if (isSelected) {
                          borderColor = theme.primaryColor;
                          borderWidth = 2;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: InkWell(
                            onTap: session.hasAnswered ? null : () => ref.read(quizProvider.notifier).answerQuestion(option),
                            borderRadius: BorderRadius.circular(24),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: borderColor.withValues(alpha: showResult ? 0.8 : 0.4), 
                                  width: borderWidth
                                ),
                                boxShadow: isSelected && !showResult ? [
                                  BoxShadow(
                                    color: theme.primaryColor.withValues(alpha: 0.15),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  )
                                ] : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected || (showResult && isCorrect) ? borderColor : theme.colorScheme.outline,
                                        width: 2,
                                      ),
                                      color: isSelected || (showResult && isCorrect) ? borderColor : Colors.transparent,
                                    ),
                                    child: isSelected || (showResult && isCorrect)
                                      ? Icon(
                                          showResult && !isCorrect ? Icons.close : Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: textColor,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),

                      if (session.hasAnswered) ...[
                        const SizedBox(height: 24),
                        // Explanation Card
                        FutureBuilder<String?>(
                          future: ref.read(bibleServiceProvider).getVerseText(session.currentQuestion?.reference ?? ""),
                          builder: (context, snapshot) {
                            final verseText = snapshot.data;
                            return Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppTheme.celestialBlue.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: AppTheme.divineGold.withValues(alpha: 0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.auto_awesome_rounded, color: AppTheme.divineGold, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'REFLEXÃO BÍBLICA',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    session.currentQuestion?.explanation ?? "",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      height: 1.5,
                                    ),
                                  ),
                                  const Divider(height: 32),
                                  Row(
                                    children: [
                                      const Icon(Icons.menu_book_rounded, size: 16, color: Colors.black54),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Referência: ${session.currentQuestion?.reference ?? ""}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (snapshot.connectionState == ConnectionState.waiting)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 12.0),
                                      child: LinearProgressIndicator(),
                                    )
                                  else if (verseText != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Text(
                                        '"${verseText.trim()}"',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryBlue,
                                AppTheme.primaryBlue.withValues(alpha: 0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => ref.read(quizProvider.notifier).nextQuestion(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome_rounded, color: AppTheme.divineGold, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  session.isLastQuestion ? 'VER RESULTADO FINAL' : 'PRÓXIMA PERGUNTA',
                                  style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.auto_awesome_rounded, color: AppTheme.divineGold, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
