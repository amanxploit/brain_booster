import 'package:flutter/material.dart';
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
  StorageService get storage {
    _storage ??= StorageService._();
    return _storage!;
  }

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

class GameProvider extends ChangeNotifier {
  MathOperation _selectedOperation = MathOperation.addition;
  Difficulty _selectedDifficulty = Difficulty.easy;
  int _questionsPerSession = 10;
  int _timeLimit = 30;

  List<MathQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  int _totalScore = 0;
  int _sessionStartTime = 0;
  bool _isGameActive = false;
  bool _showResult = false;
  bool _lastAnswerCorrect = false;
  int _selectedAnswer = -1;
  int _timeSpentOnCurrentQuestion = 0;

  MathOperation get selectedOperation => _selectedOperation;
  Difficulty get selectedDifficulty => _selectedDifficulty;
  int get questionsPerSession => _questionsPerSession;
  int get timeLimit => _timeLimit;

  List<MathQuestion> get questions => _questions;
  MathQuestion? get currentQuestion => _currentQuestionIndex < _questions.length ? _questions[_currentQuestionIndex] : null;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  int get totalScore => _totalScore;
  bool get isGameActive => _isGameActive;
  bool get showResult => _showResult;
  bool get lastAnswerCorrect => _lastAnswerCorrect;
  int get selectedAnswer => _selectedAnswer;
  int get timeSpentOnCurrentQuestion => _timeSpentOnCurrentQuestion;
  int get remainingQuestions => _questions.length - _currentQuestionIndex;
  double get progress => _questions.isEmpty ? 0.0 : (_currentQuestionIndex / _questions.length).clamp(0.0, 1.0);

  void setOperation(MathOperation operation) {
    _selectedOperation = operation;
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    _selectedDifficulty = difficulty;
    notifyListeners();
  }

  void setQuestionsPerSession(int count) {
    _questionsPerSession = count.clamp(5, 50);
    notifyListeners();
  }

  void setTimeLimit(int seconds) {
    _timeLimit = seconds.clamp(10, 120);
    notifyListeners();
  }

  void startGame() {
    _questions = List.generate(
      _questionsPerSession,
      (_) => MathQuestion.generate(
        operation: _selectedOperation,
        difficulty: _selectedDifficulty,
      ),
    );
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _totalScore = 0;
    _sessionStartTime = DateTime.now().millisecondsSinceEpoch;
    _isGameActive = true;
    _showResult = false;
    _selectedAnswer = -1;
    _timeSpentOnCurrentQuestion = 0;
    notifyListeners();
  }

  void selectAnswer(int answer) {
    if (_showResult || !_isGameActive) return;
    _selectedAnswer = answer;
    notifyListeners();
  }

  void submitAnswer(int timeSpent) {
    if (!_isGameActive || _selectedAnswer == -1 || _showResult) return;

    final question = currentQuestion!;
    final isCorrect = _selectedAnswer == question.correctAnswer;
    _lastAnswerCorrect = isCorrect;
    _timeSpentOnCurrentQuestion = timeSpent;

    if (isCorrect) {
      _correctCount++;
      _totalScore += _selectedDifficulty.pointsMultiplier * 10;
    } else {
      _wrongCount++;
    }

    _showResult = true;
    notifyListeners();
  }

  void nextQuestion() {
    if (!_isGameActive) return;

    _currentQuestionIndex++;
    _showResult = false;
    _selectedAnswer = -1;
    _timeSpentOnCurrentQuestion = 0;

    if (_currentQuestionIndex >= _questions.length) {
      endGame();
    }
    notifyListeners();
  }

  void endGame() {
    _isGameActive = false;
    notifyListeners();
  }

  void resetGame() {
    _questions = [];
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _totalScore = 0;
    _isGameActive = false;
    _showResult = false;
    _lastAnswerCorrect = false;
    _selectedAnswer = -1;
    _timeSpentOnCurrentQuestion = 0;
    notifyListeners();
  }

  GameSession createSession() {
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final timeSpent = ((endTime - _sessionStartTime) / 1000).round();

    return GameSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      operation: _selectedOperation,
      difficulty: _selectedDifficulty,
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
      wrongAnswers: _wrongCount,
      totalScore: _totalScore,
      timeSpent: timeSpent,
      questionResults: _questions.asMap().entries.map((entry) {
        final index = entry.key;
        final question = entry.value;
        return QuestionResult(
          questionId: question.id,
          question: question,
          selectedAnswer: index < _questions.length ? _selectedAnswer : -1,
          isCorrect: index < _correctCount + _wrongCount,
          timeSpent: timeSpent ~/ _questions.length,
        );
      }).toList(),
    );
  }

  void updateTimeSpent(int seconds) {
    _timeSpentOnCurrentQuestion = seconds;
    notifyListeners();
  }
}