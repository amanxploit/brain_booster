import 'package:flutter/material.dart';
import 'dart:async';
import '../models/user_stats.dart';
import '../models/math_question.dart';
import '../models/app_settings.dart';
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

    try {
      // Add timeout to prevent hanging
      debugPrint('Initializing StorageService...');
      _storage = await StorageService.getInstance().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('StorageService.getInstance() timed out');
          throw TimeoutException('StorageService.getInstance() timed out');
        },
      );
      
      debugPrint('StorageService initialized, loading user stats...');
      // Load user stats with timeout
      _userStats = await _storage!.getUserStats().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('getUserStats timed out, using defaults');
          return UserStats();
        },
      );
      
      debugPrint('User stats loaded, loading settings...');
      // Load settings with timeout
      _settings = await _storage!.getSettings().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('getSettings timed out, using defaults');
          return AppSettings();
        },
      );
      
      debugPrint('AppProvider initialized successfully');
    } catch (e, stack) {
      debugPrint('AppProvider initialization error: $e');
      debugPrint('Stack trace: $stack');
      // Ensure we have valid defaults even on error
      _userStats = UserStats();
      _settings = AppSettings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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