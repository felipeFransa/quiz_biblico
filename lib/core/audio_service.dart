import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playCorrect() async {
    await _player.play(AssetSource('audio/correct.mp3'));
  }

  Future<void> playIncorrect() async {
    await _player.play(AssetSource('audio/incorrect.mp3'));
  }

  Future<void> playLevelUp() async {
    await _player.play(AssetSource('audio/level_up.mp3'));
  }
}
