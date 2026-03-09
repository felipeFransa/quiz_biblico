import '../../../shared/models/question.dart';

enum QuizStatus { initial, loading, inProgress, completed, error }

class QuizSession {
  final List<Question> questions;
  final int currentIndex;
  final int score;
  final QuizStatus status;
  final String? selectedOption;
  final bool isCorrect;
  final bool hasAnswered;
  final String? inspirationVerse;
  final String? inspirationReference;

  QuizSession({
    this.questions = const [],
    this.currentIndex = 0,
    this.score = 0,
    this.status = QuizStatus.initial,
    this.selectedOption,
    this.isCorrect = false,
    this.hasAnswered = false,
    this.inspirationVerse,
    this.inspirationReference,
  });

  Question? get currentQuestion => 
      questions.isNotEmpty && currentIndex < questions.length 
          ? questions[currentIndex] 
          : null;

  bool get isLastQuestion => currentIndex == questions.length - 1;

  QuizSession copyWith({
    List<Question>? questions,
    int? currentIndex,
    int? score,
    QuizStatus? status,
    String? selectedOption,
    bool? isCorrect,
    bool? hasAnswered,
    String? inspirationVerse,
    String? inspirationReference,
  }) {
    return QuizSession(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      status: status ?? this.status,
      selectedOption: selectedOption, // Can be null
      isCorrect: isCorrect ?? this.isCorrect,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      inspirationVerse: inspirationVerse ?? this.inspirationVerse,
      inspirationReference: inspirationReference ?? this.inspirationReference,
    );
  }
}
