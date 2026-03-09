import 'package:flutter/foundation.dart';
import '../data/models/quiz_question.dart';
import '../data/models/enums.dart';
import '../data/repositories/question_repository.dart';
import '../core/constants/app_constants.dart';

enum QuizState { idle, loading, playing, answered, finished }

class QuizProvider extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _combo = 0;
  int _bestCombo = 0;
  int _correctAnswers = 0;
  int? _selectedAnswer;
  QuizState _state = QuizState.idle;
  QuizCategory? _category;
  Difficulty _difficulty = Difficulty.easy;

  // Getters
  QuizState get state => _state;
  QuizCategory? get category => _category;
  Difficulty get difficulty => _difficulty;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get score => _score;
  int get combo => _combo;
  int get bestCombo => _bestCombo;
  int get correctAnswers => _correctAnswers;
  int? get selectedAnswer => _selectedAnswer;
  bool get hasAnswered => _selectedAnswer != null;

  QuizQuestion? get currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  bool get isLastQuestion => _currentIndex >= _questions.length - 1;

  double get progressFraction =>
      _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length;

  QuizResult get result => QuizResult(
        totalQuestions: totalQuestions,
        correctAnswers: _correctAnswers,
        score: _score,
        bestCombo: _bestCombo,
        difficulty: _difficulty,
        category: _category,
      );

  Future<void> startQuiz({
    QuizCategory? category,
    Difficulty? difficulty,
  }) async {
    _state = QuizState.loading;
    notifyListeners();

    _category = category;
    _difficulty = difficulty ?? _difficulty;

    await QuestionRepository.instance.load();

    _questions = QuestionRepository.instance.getQuestions(
      category: _category,
      difficulty: _difficulty,
      limit: AppConstants.questionsPerRound,
    );

    _currentIndex = 0;
    _score = 0;
    _combo = 0;
    _bestCombo = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    _state = QuizState.playing;
    notifyListeners();
  }

  void answerQuestion(int selectedIndex) {
    if (_state != QuizState.playing || hasAnswered) return;

    _selectedAnswer = selectedIndex;
    final question = currentQuestion!;
    final isCorrect = selectedIndex == question.correctIndex;

    if (isCorrect) {
      _combo++;
      _correctAnswers++;
      if (_combo > _bestCombo) _bestCombo = _combo;
      final multiplier = _comboMultiplier;
      _score += (AppConstants.pointsPerCorrect * multiplier).round();
    } else {
      _combo = 0;
    }

    _state = QuizState.answered;
    notifyListeners();
  }

  void nextQuestion() {
    if (_state != QuizState.answered) return;

    if (isLastQuestion) {
      _state = QuizState.finished;
    } else {
      _currentIndex++;
      _selectedAnswer = null;
      _state = QuizState.playing;
    }
    notifyListeners();
  }

  void skipQuestion() {
    if (_state != QuizState.playing) return;
    _combo = 0;

    if (isLastQuestion) {
      _state = QuizState.finished;
    } else {
      _currentIndex++;
      _selectedAnswer = null;
    }
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    _difficulty = difficulty;
    notifyListeners();
  }

  void reset() {
    _state = QuizState.idle;
    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _combo = 0;
    _bestCombo = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    notifyListeners();
  }

  double get _comboMultiplier {
    if (_combo >= 6) return AppConstants.comboMultiplier6;
    if (_combo >= 4) return AppConstants.comboMultiplier4;
    if (_combo >= AppConstants.comboThreshold) return AppConstants.comboMultiplier2;
    return 1.0;
  }
}
