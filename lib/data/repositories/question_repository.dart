import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';
import '../models/enums.dart';

class QuestionRepository {
  static QuestionRepository? _instance;
  List<QuizQuestion>? _allQuestions;

  QuestionRepository._();

  static QuestionRepository get instance {
    _instance ??= QuestionRepository._();
    return _instance!;
  }

  Future<void> load() async {
    if (_allQuestions != null) return;
    final jsonString =
        await rootBundle.loadString('assets/data/questions.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _allQuestions = jsonList
        .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<QuizQuestion> getQuestions({
    QuizCategory? category,
    Difficulty? difficulty,
    int limit = 10,
  }) {
    if (_allQuestions == null) {
      throw StateError('Repository not loaded. Call load() first.');
    }

    var filtered = _allQuestions!.where((q) {
      final categoryMatch = category == null || q.category == category;
      final difficultyMatch = difficulty == null || q.difficulty == difficulty;
      return categoryMatch && difficultyMatch;
    }).toList();

    filtered.shuffle();

    return filtered.take(limit).toList();
  }

  int get totalCount => _allQuestions?.length ?? 0;

  bool get isLoaded => _allQuestions != null;
}
