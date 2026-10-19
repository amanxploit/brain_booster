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
  final Random _random = Random.secure();
  Difficulty _baseDifficulty = Difficulty.easy;
  final List<QuestionResult> _questionResults = [];

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
    // Slower adaptive difficulty: increase after 5 correct, decrease after 3 wrong
    if (_consecutiveCorrect >= 5 && _selectedDifficulty.index < Difficulty.values.length - 1) {
      return Difficulty.values[_selectedDifficulty.index + 1];
    } else if (_consecutiveWrong >= 3 && _selectedDifficulty.index > 0) {
      return Difficulty.values[_selectedDifficulty.index - 1];
    }
    return _selectedDifficulty;
  }

  void _updateAdaptiveDifficulty(bool isCorrect) {
    if (isCorrect) {
      _consecutiveCorrect++;
      _consecutiveWrong = 0;
      // Increase difficulty after 5 consecutive correct (slower progression)
      if (_consecutiveCorrect >= 5 && _selectedDifficulty.index < Difficulty.values.length - 1) {
        _selectedDifficulty = Difficulty.values[_selectedDifficulty.index + 1];
        _consecutiveCorrect = 0;
      }
    } else {
      _consecutiveWrong++;
      _consecutiveCorrect = 0;
      // Decrease difficulty after 3 consecutive wrong
      if (_consecutiveWrong >= 3 && _selectedDifficulty.index > 0) {
        _selectedDifficulty = Difficulty.values[_selectedDifficulty.index - 1];
        _consecutiveWrong = 0;
      }
    }
  }

  void startGame() {
    _questions = [];
    _questionResults.clear();
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _totalScore = 0;
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
    final question = MathQuestion.generate(
      operation: _selectedOperation,
      difficulty: difficulty,
      random: _random,
    );
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
      _totalScore += question.difficulty.pointsMultiplier * 10;
    } else {
      _wrongCount++;
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
    _currentQuestionIndex = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _totalScore = 0;
    _isGameActive = false;
    _showResult = false;
    _lastAnswerCorrect = false;
    _selectedAnswer = -1;
    _timeSpentOnCurrentQuestion = 0;
    _consecutiveCorrect = 0;
    _consecutiveWrong = 0;
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