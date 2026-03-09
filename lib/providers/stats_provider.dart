import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../data/models/quiz_question.dart';

class StatsProvider extends ChangeNotifier {
  int _totalGames = 0;
  int _totalCorrect = 0;
  int _totalQuestions = 0;
  int _bestStreak = 0;
  int _bestScore = 0;

  int get totalGames => _totalGames;
  int get totalCorrect => _totalCorrect;
  int get bestStreak => _bestStreak;
  int get bestScore => _bestScore;

  double get overallAccuracy =>
      _totalQuestions == 0 ? 0 : _totalCorrect / _totalQuestions;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _totalGames = prefs.getInt(AppConstants.keyTotalGames) ?? 0;
    _totalCorrect = prefs.getInt(AppConstants.keyTotalCorrect) ?? 0;
    _totalQuestions = prefs.getInt('total_questions') ?? 0;
    _bestStreak = prefs.getInt(AppConstants.keyBestStreak) ?? 0;
    _bestScore = prefs.getInt(AppConstants.keyBestScore) ?? 0;
    notifyListeners();
  }

  Future<void> saveResult(QuizResult result) async {
    _totalGames++;
    _totalCorrect += result.correctAnswers;
    _totalQuestions += result.totalQuestions;
    if (result.bestCombo > _bestStreak) _bestStreak = result.bestCombo;
    if (result.score > _bestScore) _bestScore = result.score;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyTotalGames, _totalGames);
    await prefs.setInt(AppConstants.keyTotalCorrect, _totalCorrect);
    await prefs.setInt('total_questions', _totalQuestions);
    await prefs.setInt(AppConstants.keyBestStreak, _bestStreak);
    await prefs.setInt(AppConstants.keyBestScore, _bestScore);

    notifyListeners();
  }
}
