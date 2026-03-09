import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/user_stats.dart';
import '../../../shared/providers/app_providers.dart';
import '../../settings/providers/settings_provider.dart';

class ProgressNotifier extends Notifier<UserStats> {
  late SharedPreferences _prefs;

  @override
  UserStats build() {
    _prefs = ref.watch(sharedPrefsProvider);
    final stats = _loadInitialState(_prefs);
    
    // We can't call state = ... in build, so we calculate the initial state with streak updated
    return _updateStreak(stats);
  }

  static UserStats _loadInitialState(SharedPreferences prefs) {
    return UserStats(
      xp: prefs.getInt('xp') ?? 0,
      streak: prefs.getInt('streak') ?? 0,
      lastLoginTimestamp: prefs.getInt('lastLoginTimestamp') ?? 0,
      totalQuestionsAnswered: prefs.getInt('totalQuestionsAnswered') ?? 0,
      totalCorrectAnswers: prefs.getInt('totalCorrectAnswers') ?? 0,
      totalShares: prefs.getInt('totalShares') ?? 0,
      lastQuizTimestamp: prefs.getInt('lastQuizTimestamp') ?? 0,
      playedCategories: prefs.getStringList('playedCategories') ?? [],
    );
  }

  UserStats _updateStreak(UserStats currentStats) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastLoginDate = DateTime.fromMillisecondsSinceEpoch(currentStats.lastLoginTimestamp);
    final lastLoginDay = DateTime(lastLoginDate.year, lastLoginDate.month, lastLoginDate.day);

    final difference = today.difference(lastLoginDay).inDays;

    UserStats newStats = currentStats;
    if (difference == 1) {
      // Consecutive day
      newStats = currentStats.copyWith(streak: currentStats.streak + 1, lastLoginTimestamp: now.millisecondsSinceEpoch);
    } else if (difference > 1) {
      // Streak broken
      newStats = currentStats.copyWith(streak: 1, lastLoginTimestamp: now.millisecondsSinceEpoch);
    } else if (currentStats.lastLoginTimestamp == 0) {
      // First time
      newStats = currentStats.copyWith(streak: 1, lastLoginTimestamp: now.millisecondsSinceEpoch);
    }

    if (newStats != currentStats) {
      _saveState(newStats);
    }
    return newStats;
  }

  void addXp(int amount) {
    final oldLevel = state.level;
    final newXp = state.xp + amount;
    final newState = state.copyWith(xp: newXp);
    _updateState(newState);
    
    final newLevel = newState.level;
    if (newLevel > oldLevel) {
      ref.read(audioServiceProvider).playLevelUp();
    }
  }

  void completeQuiz(int correct, int total, String category) {
    final newQuestionsAnswered = state.totalQuestionsAnswered + total;
    final newCorrectAnswers = state.totalCorrectAnswers + correct;
    
    List<String> newCategories = List.from(state.playedCategories);
    if (!newCategories.contains(category)) {
      newCategories.add(category);
    }

    int xpGained = 30; // Base quiz completion XP
    xpGained += (correct * 10); // 10 XP per correct answer
    if (correct == total) xpGained += 50; // Perfect bonus

    _updateState(state.copyWith(
      xp: state.xp + xpGained,
      totalQuestionsAnswered: newQuestionsAnswered,
      totalCorrectAnswers: newCorrectAnswers,
      lastQuizTimestamp: DateTime.now().millisecondsSinceEpoch,
      playedCategories: newCategories,
    ));
  }

  void _updateState(UserStats newState) {
    state = newState;
    _saveState(newState);
  }

  void _saveState(UserStats s) {
    _prefs.setInt('xp', s.xp);
    _prefs.setInt('streak', s.streak);
    _prefs.setInt('lastLoginTimestamp', s.lastLoginTimestamp);
    _prefs.setInt('totalQuestionsAnswered', s.totalQuestionsAnswered);
    _prefs.setInt('totalCorrectAnswers', s.totalCorrectAnswers);
    _prefs.setInt('totalShares', s.totalShares);
    _prefs.setInt('lastQuizTimestamp', s.lastQuizTimestamp);
    _prefs.setStringList('playedCategories', s.playedCategories);
  }
}

final progressProvider = NotifierProvider<ProgressNotifier, UserStats>(() {
  return ProgressNotifier();
});
