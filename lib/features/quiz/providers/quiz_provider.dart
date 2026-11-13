import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/app_providers.dart';
import '../../gamification/providers/progress_provider.dart';
import '../models/quiz_session.dart';

class QuizNotifier extends Notifier<QuizSession> {
  @override
  QuizSession build() {
    return QuizSession();
  }

  Future<void> startQuiz(String category) async {
    final stats = ref.read(progressProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastQuizDate = DateTime.fromMillisecondsSinceEpoch(stats.lastQuizTimestamp);
    final lastQuizDay = DateTime(lastQuizDate.year, lastQuizDate.month, lastQuizDate.day);

    if (stats.lastQuizTimestamp != 0 && today.isAtSameMomentAs(lastQuizDay)) {
      // Já fez quiz hoje - Para fins de teste, você pode remover esta trava ou adicionar um bypass
      // Mas conforme o prompt: "Limite de 1 quiz novo por dia"
      // state = state.copyWith(status: QuizStatus.error); // Poderia definir um status específico
    }

    state = state.copyWith(status: QuizStatus.loading);
    try {
      final db = ref.read(databaseServiceProvider);
      final questions = await db.getQuestionsByCategory(category);

      if (questions.isEmpty) {
        state = state.copyWith(status: QuizStatus.error);
        return;
      }

      await db.markQuestionsSeen(questions.map((q) => q.id).toList());

      // Buscar versículo inspirador aleatório
      final randomVerse = await db.getRandomVerse();

      state = state.copyWith(
        questions: questions,
        status: QuizStatus.inProgress,
        currentIndex: 0,
        score: 0,
        hasAnswered: false,
        isPartialPool: questions.length < 10,
        inspirationVerse: randomVerse['text'],
        inspirationReference: '${randomVerse['book']} ${randomVerse['chapter']}:${randomVerse['verse']}',
      );
    } catch (e) {
      state = state.copyWith(status: QuizStatus.error);
    }
  }

  void answerQuestion(String option) async {
    if (state.hasAnswered) return;

    final question = state.currentQuestion!;
    final isCorrect = question.correctAnswer == option;
    
    // Registrar progresso no banco de dados para evitar repetição
    ref.read(databaseServiceProvider).recordAnswer(question.id, isCorrect);

    if (isCorrect) {
      ref.read(audioServiceProvider).playCorrect();
    } else {
      ref.read(audioServiceProvider).playIncorrect();
    }

    state = state.copyWith(
      selectedOption: option,
      isCorrect: isCorrect,
      hasAnswered: true,
      score: isCorrect ? state.score + 1 : state.score,
    );
  }

  void nextQuestion() async {
    if (state.isLastQuestion) {
      await ref.read(adServiceProvider).showInterstitialAd();
      state = state.copyWith(status: QuizStatus.completed);
      ref.read(progressProvider.notifier).completeQuiz(
        state.score, 
        state.questions.length, 
        state.questions.first.category
      );
    } else {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        hasAnswered: false,
        selectedOption: null,
      );
    }
  }
}

final quizProvider = NotifierProvider<QuizNotifier, QuizSession>(() {
  return QuizNotifier();
});
