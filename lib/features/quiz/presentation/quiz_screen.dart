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
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('${session.currentIndex + 1} de ${session.questions.length}'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${session.score} acertos',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Sacred Watermark
          Positioned(
            bottom: -50,
            right: -50,
            child: Opacity(
              opacity: 0.03,
              child: Transform.rotate(
                angle: -0.2,
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 300,
                  color: AppTheme.divineGold,
                ),
              ),
            ),
          ),
          
          Column(
            children: [
              // Styled Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (session.currentIndex + 1) / session.questions.length,
                    minHeight: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.5),
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
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: theme.colorScheme.outline),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          question.text,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
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
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: borderColor, width: borderWidth),
                                boxShadow: isSelected && !showResult ? [
                                  BoxShadow(
                                    color: theme.primaryColor.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ] : null,
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
                                color: theme.primaryColor.withValues(alpha: 0.03),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: theme.primaryColor.withValues(alpha: 0.1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.info_outline_rounded, color: theme.primaryColor, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'SABIA QUE?',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
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
                        ElevatedButton(
                          onPressed: () => ref.read(quizProvider.notifier).nextQuestion(),
                          child: Text(session.isLastQuestion ? 'VER RESULTADO FINAL' : 'PRÓXIMA PERGUNTA'),
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
