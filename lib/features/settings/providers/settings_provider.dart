import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/user_state.dart';

class SettingsNotifier extends Notifier<UserState> {
  late SharedPreferences _prefs;

  @override
  UserState build() {
    _prefs = ref.watch(sharedPrefsProvider);
    return _loadInitialState(_prefs);
  }

  static UserState _loadInitialState(SharedPreferences prefs) {
    return UserState(
      currentThemeId: prefs.getString('currentThemeId') ?? 'holy_light',
      unlockedThemeIds: prefs.getStringList('unlockedThemeIds') ?? ['holy_light'],
      fontSizeScale: prefs.getDouble('fontSizeScale') ?? 1.0,
      language: prefs.getString('language') ?? 'pt',
    );
  }

  void setTheme(String themeId) {
    state = state.copyWith(currentThemeId: themeId);
    _prefs.setString('currentThemeId', themeId);
  }

  void unlockTheme(String themeId) {
    if (!state.unlockedThemeIds.contains(themeId)) {
      final newList = [...state.unlockedThemeIds, themeId];
      state = state.copyWith(unlockedThemeIds: newList);
      _prefs.setStringList('unlockedThemeIds', newList);
    }
  }

  void setFontSize(double scale) {
    state = state.copyWith(fontSizeScale: scale);
    _prefs.setDouble('fontSizeScale', scale);
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final settingsProvider = NotifierProvider<SettingsNotifier, UserState>(() {
  return SettingsNotifier();
});
