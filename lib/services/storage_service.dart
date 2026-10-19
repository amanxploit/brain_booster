import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_stats.dart';
import '../models/math_question.dart';
import '../models/app_settings.dart';

class StorageService {
  static const String _userStatsKey = 'user_stats';
  static const String _settingsKey = 'app_settings';
  static const String _gameHistoryKey = 'game_history';

  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance != null) return _instance!;
    _instance = StorageService._();
    _prefs = await SharedPreferences.getInstance();
    return _instance!;
  }

  // User Stats
  Future<UserStats> getUserStats() async {
    final jsonString = _prefs?.getString(_userStatsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return UserStats();
    }
    try {
      return UserStats.fromJson(jsonDecode(jsonString));
    } catch (e) {
      return UserStats();
    }
  }

  Future<void> saveUserStats(UserStats stats) async {
    await _prefs?.setString(_userStatsKey, jsonEncode(stats.toJson()));
  }

  Future<void> clearUserStats() async {
    await _prefs?.remove(_userStatsKey);
  }

  // Settings
  Future<AppSettings> getSettings() async {
    final jsonString = _prefs?.getString(_settingsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return AppSettings();
    }
    try {
      return AppSettings.fromJson(jsonDecode(jsonString));
    } catch (e) {
      return AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _prefs?.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  // Game History
  Future<List<GameSession>> getGameHistory() async {
    final jsonString = _prefs?.getString(_gameHistoryKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((e) => GameSession.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveGameSession(GameSession session) async {
    final history = await getGameHistory();
    history.insert(0, session);
    // Keep only last 100 sessions
    if (history.length > 100) {
      history.removeRange(100, history.length);
    }
    await _prefs?.setString(_gameHistoryKey, jsonEncode(history.map((e) => e.toJson()).toList()));
  }

  Future<void> clearGameHistory() async {
    await _prefs?.remove(_gameHistoryKey);
  }
}

class GameSession {
  final String id;
  final DateTime date;
  final MathOperation operation;
  final Difficulty difficulty;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalScore;
  final int timeSpent; // in seconds
  final List<QuestionResult> questionResults;

  GameSession({
    required this.id,
    required this.date,
    required this.operation,
    required this.difficulty,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalScore,
    required this.timeSpent,
    required this.questionResults,
  });

  double get accuracy => totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'operation': operation.index,
        'difficulty': difficulty.index,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
        'totalScore': totalScore,
        'timeSpent': timeSpent,
        'questionResults': questionResults.map((e) => e.toJson()).toList(),
      };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
        id: json['id'],
        date: DateTime.parse(json['date']),
        operation: MathOperation.values[json['operation']],
        difficulty: Difficulty.values[json['difficulty']],
        totalQuestions: json['totalQuestions'],
        correctAnswers: json['correctAnswers'],
        wrongAnswers: json['wrongAnswers'],
        totalScore: json['totalScore'],
        timeSpent: json['timeSpent'],
        questionResults: (json['questionResults'] as List)
            .map((e) => QuestionResult.fromJson(e))
            .toList(),
      );
}

class QuestionResult {
  final String questionId;
  final MathQuestion question;
  final int selectedAnswer;
  final bool isCorrect;
  final int timeSpent;

  QuestionResult({
    required this.questionId,
    required this.question,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timeSpent,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'question': question.toJson(),
        'selectedAnswer': selectedAnswer,
        'isCorrect': isCorrect,
        'timeSpent': timeSpent,
      };

  factory QuestionResult.fromJson(Map<String, dynamic> json) => QuestionResult(
        questionId: json['questionId'],
        question: MathQuestion.fromJson(json['question']),
        selectedAnswer: json['selectedAnswer'],
        isCorrect: json['isCorrect'],
        timeSpent: json['timeSpent'],
      );
}