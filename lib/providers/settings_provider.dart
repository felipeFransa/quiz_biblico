import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../data/models/enums.dart';

class SettingsProvider extends ChangeNotifier {
  Difficulty _difficulty = Difficulty.easy;
  bool _soundEnabled = true;

  Difficulty get difficulty => _difficulty;
  bool get soundEnabled => _soundEnabled;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final diffValue = prefs.getString(AppConstants.keyDifficulty) ?? 'easy';
    _difficulty = DifficultyExtension.fromJson(diffValue) ?? Difficulty.easy;
    _soundEnabled = prefs.getBool(AppConstants.keySoundEnabled) ?? true;
    notifyListeners();
  }

  Future<void> setDifficulty(Difficulty difficulty) async {
    _difficulty = difficulty;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyDifficulty, difficulty.jsonValue);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keySoundEnabled, enabled);
    notifyListeners();
  }
}
