enum QuizCategory {
  oldTestament,
  newTestament,
  characters,
  miracles,
  prophets,
  women,
  parables,
}

extension QuizCategoryExtension on QuizCategory {
  String get displayName {
    switch (this) {
      case QuizCategory.oldTestament:
        return 'Antigo Testamento';
      case QuizCategory.newTestament:
        return 'Novo Testamento';
      case QuizCategory.characters:
        return 'Personagens';
      case QuizCategory.miracles:
        return 'Milagres';
      case QuizCategory.prophets:
        return 'Profetas';
      case QuizCategory.women:
        return 'Mulheres da Bíblia';
      case QuizCategory.parables:
        return 'Parábolas';
    }
  }

  String get emoji {
    switch (this) {
      case QuizCategory.oldTestament:
        return '📜';
      case QuizCategory.newTestament:
        return '✝️';
      case QuizCategory.characters:
        return '👤';
      case QuizCategory.miracles:
        return '✨';
      case QuizCategory.prophets:
        return '🔮';
      case QuizCategory.women:
        return '👸';
      case QuizCategory.parables:
        return '📖';
    }
  }

  String get jsonValue {
    switch (this) {
      case QuizCategory.oldTestament:
        return 'oldTestament';
      case QuizCategory.newTestament:
        return 'newTestament';
      case QuizCategory.characters:
        return 'characters';
      case QuizCategory.miracles:
        return 'miracles';
      case QuizCategory.prophets:
        return 'prophets';
      case QuizCategory.women:
        return 'women';
      case QuizCategory.parables:
        return 'parables';
    }
  }

  static QuizCategory? fromJson(String value) {
    for (final cat in QuizCategory.values) {
      if (cat.jsonValue == value) return cat;
    }
    return null;
  }
}

enum Difficulty {
  easy,
  medium,
  hard,
}

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Fácil';
      case Difficulty.medium:
        return 'Médio';
      case Difficulty.hard:
        return 'Difícil';
    }
  }

  String get jsonValue {
    switch (this) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.medium:
        return 'medium';
      case Difficulty.hard:
        return 'hard';
    }
  }

  static Difficulty? fromJson(String value) {
    for (final d in Difficulty.values) {
      if (d.jsonValue == value) return d;
    }
    return null;
  }
}
