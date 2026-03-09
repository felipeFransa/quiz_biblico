import 'enums.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final Difficulty difficulty;
  final QuizCategory category;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
    required this.category,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      difficulty:
          DifficultyExtension.fromJson(json['difficulty'] as String) ??
              Difficulty.easy,
      category:
          QuizCategoryExtension.fromJson(json['category'] as String) ??
              QuizCategory.oldTestament,
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
        'difficulty': difficulty.jsonValue,
        'category': category.jsonValue,
      };
}

class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int score;
  final int bestCombo;
  final Difficulty difficulty;
  final QuizCategory? category;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.bestCombo,
    required this.difficulty,
    this.category,
  });

  double get accuracy => totalQuestions == 0
      ? 0
      : correctAnswers / totalQuestions;

  int get stars {
    if (accuracy >= 0.9) return 3;
    if (accuracy >= 0.6) return 2;
    if (accuracy >= 0.3) return 1;
    return 0;
  }
}
