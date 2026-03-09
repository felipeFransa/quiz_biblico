class UserStats {
  final int xp;
  final int streak;
  final int lastLoginTimestamp;
  final int totalQuestionsAnswered;
  final int totalCorrectAnswers;
  final int totalShares;
  final int lastQuizTimestamp;
  final List<String> playedCategories;

  UserStats({
    this.xp = 0,
    this.streak = 0,
    this.lastLoginTimestamp = 0,
    this.totalQuestionsAnswered = 0,
    this.totalCorrectAnswers = 0,
    this.totalShares = 0,
    this.lastQuizTimestamp = 0,
    this.playedCategories = const [],
  });

  int get level => (xp / 150).floor() + 1;
  double get xpProgress => (xp % 150) / 150;

  double get accuracy => totalQuestionsAnswered > 0 
      ? totalCorrectAnswers / totalQuestionsAnswered 
      : 0.0;

  UserStats copyWith({
    int? xp,
    int? streak,
    int? lastLoginTimestamp,
    int? totalQuestionsAnswered,
    int? totalCorrectAnswers,
    int? totalShares,
    int? lastQuizTimestamp,
    List<String>? playedCategories,
  }) {
    return UserStats(
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      lastLoginTimestamp: lastLoginTimestamp ?? this.lastLoginTimestamp,
      totalQuestionsAnswered: totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalShares: totalShares ?? this.totalShares,
      lastQuizTimestamp: lastQuizTimestamp ?? this.lastQuizTimestamp,
      playedCategories: playedCategories ?? this.playedCategories,
    );
  }
}
