class AppConstants {
  AppConstants._();

  // Quiz
  static const int questionsPerRound = 10;
  static const int pointsPerCorrect = 10;
  static const int comboThreshold = 2; // streak needed to activate combo

  // Combo multipliers
  static const double comboMultiplier2 = 1.5;
  static const double comboMultiplier4 = 2.0;
  static const double comboMultiplier6 = 2.5;

  // Ads
  static const int gamesBeforeInterstitial = 3;

  // AdMob test IDs  (replace with real IDs before publishing)
  static const String androidInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  static const String androidRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String iosRewardedAdUnitId =
      'ca-app-pub-3940256099942544/1712485313';

  // Shared Preferences keys
  static const String keyTotalGames = 'total_games';
  static const String keyTotalCorrect = 'total_correct';
  static const String keyBestStreak = 'best_streak';
  static const String keyBestScore = 'best_score';
  static const String keyDifficulty = 'difficulty';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyGamesCompleted = 'games_completed';
}
