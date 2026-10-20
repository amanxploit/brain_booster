import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

/// Service for haptic feedback and sound effects
class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  /// Initialize the audio player with sound assets
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      // Preload sounds
      await _audioPlayer.setSourceAsset('assets/sounds/correct.mp3');
      _isInitialized = true;
    } catch (e) {
      // Sounds not available, will use system sounds
      _isInitialized = false;
    }
  }

  /// Play correct answer sound
  Future<void> playCorrectSound() async {
    try {
      // Try custom sound first
      await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Play wrong answer sound
  Future<void> playWrongSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Trigger vibration for wrong answer
  Future<void> vibrateWrong() async {
    await HapticFeedback.heavyImpact();
  }

  /// Trigger light vibration for correct answer
  Future<void> vibrateCorrect() async {
    await HapticFeedback.lightImpact();
  }

  /// Trigger vibration for streak milestones
  Future<void> vibrateStreak() async {
    await HapticFeedback.mediumImpact();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}