import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/ads_provider.dart';
import '../../providers/stats_provider.dart';
import '../../widgets/answer_button.dart';
import '../../widgets/question_card.dart';
import '../../widgets/explanation_card.dart';
import '../../widgets/score_bar.dart';
import '../result/result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<QuizProvider>(
          builder: (context, quiz, _) {
            if (quiz.state == QuizState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (quiz.state == QuizState.finished) {
              // Save stats and navigate to result
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (context.mounted) {
                  await context
                      .read<StatsProvider>()
                      .saveResult(quiz.result);
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(result: quiz.result),
                      ),
                    );
                  }
                }
              });
              return const Center(child: CircularProgressIndicator());
            }

            final question = quiz.currentQuestion;
            if (question == null) return const SizedBox.shrink();

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.primaryMid, AppTheme.primaryDeep],
                ),
              ),
              child: Column(
                children: [
                  _buildTopBar(context, quiz),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuestionCard(
                            question: question.question,
                            currentIndex: quiz.currentIndex,
                            total: quiz.totalQuestions,
                          ),
                          const SizedBox(height: 20),
                          ...List.generate(question.options.length, (i) {
                            return AnswerButton(
                              text: question.options[i],
                              index: i,
                              isSelected: quiz.selectedAnswer == i,
                              isCorrect: i == question.correctIndex,
                              hasAnswered: quiz.hasAnswered,
                              onTap: quiz.hasAnswered
                                  ? null
                                  : () => quiz.answerQuestion(i),
                            );
                          }),
                          if (quiz.hasAnswered) ...[
                            ExplanationCard(
                              explanation: question.explanation,
                              isCorrect: quiz.selectedAnswer ==
                                  question.correctIndex,
                            ),
                            const SizedBox(height: 16),
                            _NextButton(
                              isLast: quiz.isLastQuestion,
                              onTap: quiz.nextQuestion,
                            ),
                          ],
                        ],
                      ),
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

  Widget _buildTopBar(BuildContext context, QuizProvider quiz) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white54),
                onPressed: () {
                  quiz.reset();
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ScoreBar(
                  score: quiz.score,
                  combo: quiz.combo,
                  progress: quiz.progressFraction,
                ),
              ),
              _SkipButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AdsProvider, QuizProvider>(
      builder: (context, ads, quiz, _) {
        if (quiz.hasAnswered) return const SizedBox(width: 48);
        return IconButton(
          icon: const Icon(Icons.skip_next_rounded, color: Colors.white38),
          tooltip: 'Pular (assistir anúncio)',
          onPressed: () {
            ads.showRewarded(onRewarded: quiz.skipQuestion);
          },
        );
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onTap;

  const _NextButton({required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(isLast ? 'Ver Resultado' : 'Próxima Pergunta'),
    );
  }
}
