import 'package:uuid/uuid.dart';

class UserStats {
  final String id;
  int totalQuestions;
  int correctAnswers;
  int wrongAnswers;
  int currentStreak;
  int bestStreak;
  int totalScore;
  int totalTimeSpent; // in seconds
  Map<String, int> operationCorrect; // operation -> correct count
  Map<String, int> operationWrong; // operation -> wrong count
  Map<String, int> difficultyCorrect; // difficulty -> correct count
  Map<String, int> difficultyWrong; // difficulty -> wrong count
  DateTime lastPlayedDate;
  List<DailyContribution> dailyContributions;

  UserStats({
    String? id,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalScore = 0,
    this.totalTimeSpent = 0,
    Map<String, int>? operationCorrect,
    Map<String, int>? operationWrong,
    Map<String, int>? difficultyCorrect,
    Map<String, int>? difficultyWrong,
    DateTime? lastPlayedDate,
    List<DailyContribution>? dailyContributions,
  })  : id = id ?? const Uuid().v4(),
        operationCorrect = operationCorrect ?? {},
        operationWrong = operationWrong ?? {},
        difficultyCorrect = difficultyCorrect ?? {},
        difficultyWrong = difficultyWrong ?? {},
        lastPlayedDate = lastPlayedDate ?? DateTime.now(),
        dailyContributions = dailyContributions ?? [];

  double get accuracy => totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;

  int get brainStrength {
    // Calculate brain strength based on accuracy, streak, and consistency
    double strength = 0;
    strength += accuracy * 0.4; // 40% weight for accuracy
    strength += (currentStreak / 100).clamp(0.0, 1.0) * 100 * 0.3; // 30% weight for streak
    strength += (dailyContributions.length / 30).clamp(0.0, 1.0) * 100 * 0.3; // 30% weight for consistency
    return strength.round().clamp(0, 100);
  }

  String get brainStrengthLabel {
    final strength = brainStrength;
    if (strength >= 90) return 'Genius';
    if (strength >= 75) return 'Expert';
    if (strength >= 60) return 'Advanced';
    if (strength >= 40) return 'Intermediate';
    if (strength >= 20) return 'Beginner';
    return 'Novice';
  }

  void recordAnswer({
    required bool isCorrect,
    required MathOperation operation,
    required Difficulty difficulty,
    required int timeSpent,
  }) {
    totalQuestions++;
    totalTimeSpent += timeSpent;

    final today = DateTime.now();
    final todayKey = _dateKey(today);

    if (isCorrect) {
      correctAnswers++;
      currentStreak++;
      bestStreak = bestStreak > currentStreak ? bestStreak : currentStreak;
      totalScore += difficulty.pointsMultiplier * 10;
      operationCorrect[operation.name] = (operationCorrect[operation.name] ?? 0) + 1;
      difficultyCorrect[difficulty.name] = (difficultyCorrect[difficulty.name] ?? 0) + 1;
    } else {
      wrongAnswers++;
      currentStreak = 0;
      operationWrong[operation.name] = (operationWrong[operation.name] ?? 0) + 1;
      difficultyWrong[difficulty.name] = (difficultyWrong[difficulty.name] ?? 0) + 1;
    }

    // Update daily contribution
    _updateDailyContribution(today, isCorrect);

    lastPlayedDate = today;
  }

  void _updateDailyContribution(DateTime date, bool isCorrect) {
    final key = _dateKey(date);
    final existingIndex = dailyContributions.indexWhere((c) => c.dateKey == key);

    if (existingIndex >= 0) {
      dailyContributions[existingIndex] = dailyContributions[existingIndex].copyWith(
        questionsAnswered: dailyContributions[existingIndex].questionsAnswered + 1,
        correctAnswers: dailyContributions[existingIndex].correctAnswers + (isCorrect ? 1 : 0),
      );
    } else {
      dailyContributions.add(DailyContribution(
        dateKey: key,
        date: date,
        questionsAnswered: 1,
        correctAnswers: isCorrect ? 1 : 0,
      ));
    }

    // Keep only last 90 days
    final cutoffDate = DateTime.now().subtract(const Duration(days: 90));
    dailyContributions.removeWhere((c) => c.date.isBefore(cutoffDate));
    dailyContributions.sort((a, b) => b.date.compareTo(a.date));
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'totalScore': totalScore,
        'totalTimeSpent': totalTimeSpent,
        'operationCorrect': operationCorrect,
        'operationWrong': operationWrong,
        'difficultyCorrect': difficultyCorrect,
        'difficultyWrong': difficultyWrong,
        'lastPlayedDate': lastPlayedDate.toIso8601String(),
        'dailyContributions': dailyContributions.map((c) => c.toJson()).toList(),
      };

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        id: json['id'],
        totalQuestions: json['totalQuestions'] ?? 0,
        correctAnswers: json['correctAnswers'] ?? 0,
        wrongAnswers: json['wrongAnswers'] ?? 0,
        currentStreak: json['currentStreak'] ?? 0,
        bestStreak: json['bestStreak'] ?? 0,
        totalScore: json['totalScore'] ?? 0,
        totalTimeSpent: json['totalTimeSpent'] ?? 0,
        operationCorrect: Map<String, int>.from(json['operationCorrect'] ?? {}),
        operationWrong: Map<String, int>.from(json['operationWrong'] ?? {}),
        difficultyCorrect: Map<String, int>.from(json['difficultyCorrect'] ?? {}),
        difficultyWrong: Map<String, int>.from(json['difficultyWrong'] ?? {}),
        lastPlayedDate: DateTime.parse(json['lastPlayedDate']),
        dailyContributions: (json['dailyContributions'] as List?)
                ?.map((e) => DailyContribution.fromJson(e))
                .toList() ??
            [],
      );
}

class DailyContribution {
  final String dateKey;
  final DateTime date;
  int questionsAnswered;
  int correctAnswers;

  DailyContribution({
    required this.dateKey,
    required this.date,
    this.questionsAnswered = 0,
    this.correctAnswers = 0,
  });

  double get accuracy => questionsAnswered > 0 ? (correctAnswers / questionsAnswered) * 100 : 0.0;

  DailyContribution copyWith({
    int? questionsAnswered,
    int? correctAnswers,
  }) =>
      DailyContribution(
        dateKey: dateKey,
        date: date,
        questionsAnswered: questionsAnswered ?? this.questionsAnswered,
        correctAnswers: correctAnswers ?? this.correctAnswers,
      );

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'date': date.toIso8601String(),
        'questionsAnswered': questionsAnswered,
        'correctAnswers': correctAnswers,
      };

  factory DailyContribution.fromJson(Map<String, dynamic> json) => DailyContribution(
        dateKey: json['dateKey'],
        date: DateTime.parse(json['date']),
        questionsAnswered: json['questionsAnswered'] ?? 0,
        correctAnswers: json['correctAnswers'] ?? 0,
      );
}