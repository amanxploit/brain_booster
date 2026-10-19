import 'package:flutter/material.dart';
import '../models/user_stats.dart';
import '../models/math_question.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  StorageService? _storage;
  
  UserStats _userStats = UserStats();
  AppSettings _settings = AppSettings();
  bool _isLoading = true;

  UserStats get userStats => _userStats;
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _storage = await StorageService.getInstance();
    _userStats = await _storage!.getUserStats();
    _settings = await _storage!.getSettings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    final storage = await StorageService.getInstance();
    await storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _settings = _settings.copyWith(isDarkMode: !_settings.isDarkMode);
    final storage = await StorageService.getInstance();
    await storage.saveSettings(_settings);
    notifyListeners();
  }

  void recordAnswer({
    required bool isCorrect,
    required MathOperation operation,
    required Difficulty difficulty,
    required int timeSpent,
  }) {
    _userStats.recordAnswer(
      isCorrect: isCorrect,
      operation: operation,
      difficulty: difficulty,
      timeSpent: timeSpent,
    );
    notifyListeners();
  }

  Future<void> saveGameSession(GameSession session) async {
    final storage = await StorageService.getInstance();
    await storage.saveGameSession(session);
    await storage.saveUserStats(_userStats);
    notifyListeners();
  }

  Future<void> resetStats() async {
    _userStats = UserStats();
    final storage = await StorageService.getInstance();
    await storage.saveUserStats(_userStats);
    await storage.clearGameHistory();
    notifyListeners();
  }
}