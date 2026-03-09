class UserState {
  final String currentThemeId;
  final List<String> unlockedThemeIds;
  final double fontSizeScale;
  final String language;

  UserState({
    required this.currentThemeId,
    required this.unlockedThemeIds,
    this.fontSizeScale = 1.0,
    this.language = 'pt',
  });

  UserState copyWith({
    String? currentThemeId,
    List<String>? unlockedThemeIds,
    double? fontSizeScale,
    String? language,
  }) {
    return UserState(
      currentThemeId: currentThemeId ?? this.currentThemeId,
      unlockedThemeIds: unlockedThemeIds ?? this.unlockedThemeIds,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
      language: language ?? this.language,
    );
  }
}
