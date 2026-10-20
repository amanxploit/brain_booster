import 'dart:math';
import 'package:flutter/material.dart';
import '../models/math_question.dart';
import '../models/app_settings.dart';
import '../services/storage_service.dart';

class GameProvider extends ChangeNotifier {
  MathOperation _selectedOperation = MathOperation.addition;
  Difficulty _selectedDifficulty = Difficulty.easy;
  int _questionsPerSession = 10;
  int _timeLimit = 30;
  bool _isEndlessMode = false;

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
  
  // Adaptive difficulty tracking
  int _consecutiveCorrect = 0;
  int _consecutiveWrong = 0;
  
  // Addictive features: Streak, Combo, XP
  int _currentStreak = 0;
  int _bestStreakThisSession = 0;
  int _comboCount = 0; // Consecutive fast correct answers
  int _totalXpEarned = 0;
  int _currentLevel = 1;
  final Random _random = Random.secure();
  Difficulty _baseDifficulty = Difficulty.easy;
  final List<QuestionResult> _questionResults = [];
  
  // Question history to avoid repetition
  final List<String> _recentQuestions = [];
  static const int _maxRecentQuestions = 20;

  MathOperation get selectedOperation => _selectedOperation;
  Difficulty get selectedDifficulty => _selectedDifficulty;
  int get questionsPerSession => _questionsPerSession;
  int get timeLimit => _timeLimit;
  bool get isEndlessMode => _isEndlessMode;

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
  
  // For endless mode, remaining is always "∞", for limited mode it's the difference
  int get remainingQuestions => _isEndlessMode ? -1 : (_questionsPerSession - _currentQuestionIndex);
  
  // Progress: for endless mode, show based on a reasonable cap (e.g., 50 questions = 100%)
  double get progress {
    if (_isEndlessMode) {
      return (_currentQuestionIndex / 50).clamp(0.0, 1.0);
    }
    return _questionsPerSession == 0 ? 0.0 : (_currentQuestionIndex / _questionsPerSession).clamp(0.0, 1.0);
  }

  // Addictive features getters
  int get currentStreak => _currentStreak;
  int get bestStreakThisSession => _bestStreakThisSession;
  int get comboCount => _comboCount;
  int get totalXpEarned => _totalXpEarned;
  int get currentLevel => _currentLevel;
  bool get isOnFire => _currentStreak >= 5; // Visual indicator for hot streak
  bool get isComboActive => _comboCount >= 3; // Visual indicator for combo

  void setOperation(MathOperation operation) {
    _selectedOperation = operation;
    notifyListeners();
  }

  void setDifficulty(Difficulty difficulty) {
    _selectedDifficulty = difficulty;
    _baseDifficulty = difficulty;
    notifyListeners();
  }

  void setQuestionsPerSession(int count) {
    // 0 = endless mode
    _isEndlessMode = count == 0;
    _questionsPerSession = count.clamp(0, 999);
    notifyListeners();
  }

  void setTimeLimit(int seconds) {
    _timeLimit = seconds.clamp(0, 120);
    notifyListeners();
  }

  // Initialize from AppSettings
  void initializeFromSettings(AppSettings settings) {
    _selectedOperation = settings.preferredOperation;
    _selectedDifficulty = settings.preferredDifficulty;
    _questionsPerSession = settings.questionsPerSession;
    _timeLimit = settings.questionTimeLimit;
    _isEndlessMode = settings.questionsPerSession == 0;
    _baseDifficulty = settings.preferredDifficulty;
    notifyListeners();
  }

  Difficulty _getAdaptiveDifficulty() {
    // Faster adaptive difficulty: increase after 3 correct, decrease after 2 wrong
    if (_consecutiveCorrect >= 3 && _selectedDifficulty.index < Difficulty.values.length - 1) {
      return Difficulty.values[_selectedDifficulty.index + 1];
    } else if (_consecutiveWrong >= 2 && _selectedDifficulty.index > 0) {
      return Difficulty.values[_selectedDifficulty.index - 1];
    }
    return _selectedDifficulty;
  }

  void _updateAdaptiveDifficulty(bool isCorrect) {
    if (isCorrect) {
      _consecutiveCorrect++;
      _consecutiveWrong = 0;
      // Increase difficulty after 3 consecutive correct (faster progression)
      if (_consecutiveCorrect >= 3 && _selectedDifficulty.index < Difficulty.values.length - 1) {
        _selectedDifficulty = Difficulty.values[_selectedDifficulty.index + 1];
        _consecutiveCorrect = 0;
      }
    } else {
      _consecutiveWrong++;
      _consecutiveCorrect = 0;
      // Decrease difficulty after 2 consecutive wrong
      if (_consecutiveWrong >= 2 && _selectedDifficulty.index > 0) {
        _selectedDifficulty = Difficulty.values[_selectedDifficulty.index - 1];
        _consecutiveWrong = 0;
      }
    }
  }

  void startGame() {
    _questions = [];
    _questionResults.clear();
    _recentQuestions.clear();
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _totalScore = 0;
    _totalXpEarned = 0;
    _currentLevel = 1;
    _currentStreak = 0;
    _bestStreakThisSession = 0;
    _comboCount = 0;
    _sessionStartTime = DateTime.now().millisecondsSinceEpoch;
    _isGameActive = true;
    _showResult = false;
    _selectedAnswer = -1;
    _timeSpentOnCurrentQuestion = 0;
    _consecutiveCorrect = 0;
    _consecutiveWrong = 0;
    
    // Generate first question
    _generateNextQuestion();
    notifyListeners();
  }

  void _generateNextQuestion() {
    final difficulty = _getAdaptiveDifficulty();
    MathQuestion question;
    int attempts = 0;
    
    // Generate unique question (avoid recent repetitions)
    do {
      question = MathQuestion.generate(
        operation: _selectedOperation,
        difficulty: difficulty,
        random: _random,
      );
      attempts++;
    } while (_recentQuestions.contains(question.questionText) && attempts < 10);
    
    _questions.add(question);
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
      
      // Streak system
      _currentStreak++;
      if (_currentStreak > _bestStreakThisSession) {
        _bestStreakThisSession = _currentStreak;
      }
      
      // Combo system: fast correct answers (under 5 seconds)
      if (timeSpent <= 5) {
        _comboCount++;
      } else {
        _comboCount = 0;
      }
      
      // XP calculation with bonuses
      int baseXp = question.difficulty.pointsMultiplier * 10;
      int streakBonus = (_currentStreak / 5).floor() * 5; // +5 XP every 5 streak
      int comboBonus = _comboCount >= 3 ? _comboCount * 2 : 0; // +2 XP per combo after 3
      int speedBonus = timeSpent <= 3 ? 5 : (timeSpent <= 5 ? 2 : 0);
      int xpEarned = baseXp + streakBonus + comboBonus + speedBonus;
      
      _totalScore += xpEarned;
      _totalXpEarned += xpEarned;
      
      // Level up every 100 XP
      _currentLevel = (_totalXpEarned / 100).floor() + 1;
      
    } else {
      _wrongCount++;
      _currentStreak = 0;
      _comboCount = 0;
    }

    // Track question to avoid repetition
    _recentQuestions.add(question.questionText);
    if (_recentQuestions.length > _maxRecentQuestions) {
      _recentQuestions.removeAt(0);
    }

    _questionResults.add(QuestionResult(
      questionId: question.id,
      question: question,
      selectedAnswer: _selectedAnswer,
      isCorrect: isCorrect,
      timeSpent: timeSpent,
    ));

    _updateAdaptiveDifficulty(isCorrect);
    _showResult = true;
    notifyListeners();
  }

  void nextQuestion() {
    if (!_isGameActive) return;

    _currentQuestionIndex++;
    _showResult = false;
    _selectedAnswer = -1;
    _timeSpentOnCurrentQuestion = 0;

    // Check if we should end (only for non-endless mode)
    if (!_isEndlessMode && _currentQuestionIndex >= _questionsPerSession) {
      endGame();
    } else {
      // Generate next question with adaptive difficulty
      _generateNextQuestion();
    }
    notifyListeners();
  }

  void endGame() {
    _isGameActive = false;
    notifyListeners();
  }

  void resetGame() {
    _questions = [];
    _questionResults.clear();
    _recentQuestions.clear();
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _totalScore = 0;
    _totalXpEarned = 0;
    _currentLevel = 1;
    _isGameActive = false;
    _showResult = false;
    _lastAnswerCorrect = false;
    _selectedAnswer = -1;
    _timeSpentOnCurrentQuestion = 0;
    _consecutiveCorrect = 0;
    _consecutiveWrong = 0;
    _currentStreak = 0;
    _bestStreakThisSession = 0;
    _comboCount = 0;
    _selectedDifficulty = _baseDifficulty;
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
      questionResults: List.from(_questionResults),
    );
  }

  void updateTimeSpent(int seconds) {
    _timeSpentOnCurrentQuestion = seconds;
    notifyListeners();
  }
}