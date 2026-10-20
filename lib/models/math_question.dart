import 'dart:math';
import 'package:uuid/uuid.dart';

enum MathOperation {
  addition('+', 'Addition'),
  subtraction('-', 'Subtraction'),
  multiplication('×', 'Multiplication'),
  division('÷', 'Division'),
  modulo('%', 'Modulo');

  const MathOperation(this.symbol, this.name);
  final String symbol;
  final String name;
}

enum Difficulty {
  easy('Easy', 1, 10, 1),
  medium('Medium', 10, 50, 2),
  hard('Hard', 50, 100, 3),
  expert('Expert', 100, 500, 4);

  const Difficulty(this.name, this.minValue, this.maxValue, this.pointsMultiplier);
  final String name;
  final int minValue;
  final int maxValue;
  final int pointsMultiplier;
}

/// Progressive difficulty system that adapts based on question count and accuracy
class ProgressiveDifficulty {
  final int questionsAnswered;
  final int correctAnswers;
  final int totalQuestions;
  final Difficulty baseDifficulty;
  
  ProgressiveDifficulty({
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.baseDifficulty,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 1.0;

  /// Get the current digit level (1 = 1-digit, 2 = 2-digit, 3 = 3-digit, etc.)
  int get digitLevel {
    if (questionsAnswered < 20) return 1;
    if (questionsAnswered < 50) return 2;
    if (questionsAnswered < 100) return 3;
    if (questionsAnswered < 200) return 4;
    return 5;
  }

  /// Get the effective difficulty based on accuracy
  Difficulty get effectiveDifficulty {
    if (accuracy >= 0.9) {
      // Excellent accuracy - increase difficulty
      final index = (baseDifficulty.index + 1).clamp(0, Difficulty.values.length - 1);
      return Difficulty.values[index];
    } else if (accuracy >= 0.7) {
      // Good accuracy - maintain or slight increase
      return baseDifficulty;
    } else if (accuracy >= 0.5) {
      // Average accuracy - slight decrease
      final index = (baseDifficulty.index - 1).clamp(0, Difficulty.values.length - 1);
      return Difficulty.values[index];
    } else {
      // Poor accuracy - decrease difficulty
      final index = (baseDifficulty.index - 2).clamp(0, Difficulty.values.length - 1);
      return Difficulty.values[index];
    }
  }

  /// Get the range for the current digit level
  (int min, int max) get digitRange {
    switch (digitLevel) {
      case 1:
        return (1, 9);      // 1-digit: 1-9
      case 2:
        return (10, 99);    // 2-digit: 10-99
      case 3:
        return (100, 999);  // 3-digit: 100-999
      case 4:
        return (1000, 9999); // 4-digit: 1000-9999
      case 5:
        return (10000, 99999); // 5-digit: 10000-99999
      default:
        return (1, 9);
    }
  }

  /// Get multiplier for XP based on progression
  double get progressionMultiplier => 1.0 + (digitLevel - 1) * 0.25;
}

class MathQuestion {
  final String id;
  final MathOperation operation;
  final Difficulty difficulty;
  final int operand1;
  final int operand2;
  final int correctAnswer;
  final List<int> options;
  final DateTime createdAt;

  MathQuestion({
    String? id,
    required this.operation,
    required this.difficulty,
    required this.operand1,
    required this.operand2,
    required this.correctAnswer,
    required this.options,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  String get questionText {
    return '$operand1 ${operation.symbol} $operand2';
  }

  factory MathQuestion.generate({
    required MathOperation operation,
    required Difficulty difficulty,
    Random? random,
  }) {
    final rng = random ?? Random.secure();
    int operand1, operand2, correctAnswer;
    List<int> options = [];

    int randomInRange(int min, int max) {
      return min + rng.nextInt(max - min + 1);
    }

    switch (operation) {
      case MathOperation.addition:
        operand1 = randomInRange(difficulty.minValue, difficulty.maxValue);
        operand2 = randomInRange(difficulty.minValue, difficulty.maxValue);
        correctAnswer = operand1 + operand2;
        break;
      case MathOperation.subtraction:
        operand1 = randomInRange(difficulty.minValue, difficulty.maxValue);
        operand2 = randomInRange(difficulty.minValue, operand1);
        correctAnswer = operand1 - operand2;
        break;
      case MathOperation.multiplication:
        // Better range for multiplication to avoid repetition
        // Easy: 1-10 × 1-10, Medium: 2-12 × 2-12, Hard: 3-15 × 3-15, Expert: 5-20 × 5-20
        int minFactor, maxFactor;
        switch (difficulty) {
          case Difficulty.easy:
            minFactor = 1; maxFactor = 10;
            break;
          case Difficulty.medium:
            minFactor = 2; maxFactor = 12;
            break;
          case Difficulty.hard:
            minFactor = 3; maxFactor = 15;
            break;
          case Difficulty.expert:
            minFactor = 5; maxFactor = 20;
            break;
        }
        operand1 = randomInRange(minFactor, maxFactor);
        operand2 = randomInRange(minFactor, maxFactor);
        correctAnswer = operand1 * operand2;
        break;
      case MathOperation.division:
        // Division: generate dividend and divisor, ensure clean division
        int minDiv, maxDiv;
        switch (difficulty) {
          case Difficulty.easy:
            minDiv = 1; maxDiv = 10;
            break;
          case Difficulty.medium:
            minDiv = 2; maxDiv = 12;
            break;
          case Difficulty.hard:
            minDiv = 3; maxDiv = 15;
            break;
          case Difficulty.expert:
            minDiv = 5; maxDiv = 20;
            break;
        }
        operand2 = randomInRange(minDiv, maxDiv); // divisor
        if (operand2 == 0) operand2 = 1;
        correctAnswer = randomInRange(minDiv, maxDiv); // quotient
        operand1 = correctAnswer * operand2; // dividend
        break;
      case MathOperation.modulo:
        operand1 = randomInRange(difficulty.minValue, difficulty.maxValue);
        operand2 = randomInRange(difficulty.minValue, difficulty.maxValue);
        if (operand2 == 0) operand2 = 1;
        correctAnswer = operand1 % operand2;
        break;
    }

    // Generate options (1 correct + 3 wrong)
    options.add(correctAnswer);
    final wrongAnswers = <int>{};
    while (wrongAnswers.length < 3) {
      int offset = rng.nextInt(20) - 10; // -10 to +9
      int wrong = correctAnswer + offset;
      if (wrong != correctAnswer && wrong >= 0 && !wrongAnswers.contains(wrong)) {
        wrongAnswers.add(wrong);
      }
    }
    options.addAll(wrongAnswers);
    options.shuffle(rng);

    return MathQuestion(
      operation: operation,
      difficulty: difficulty,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: correctAnswer,
      options: options,
    );
  }

  /// Generate a question using progressive difficulty system
  /// Starts with 1-digit, moves to 2-digit after 20 questions, adapts based on accuracy
  factory MathQuestion.generateProgressive({
    required MathOperation operation,
    required Difficulty baseDifficulty,
    required int questionsAnswered,
    required int correctAnswers,
    required int totalQuestions,
    Random? random,
  }) {
    final progressive = ProgressiveDifficulty(
      questionsAnswered: questionsAnswered,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      baseDifficulty: baseDifficulty,
    );
    
    final rng = random ?? Random.secure();
    int operand1, operand2, correctAnswer;
    List<int> options = [];

    int randomInRange(int min, int max) {
      return min + rng.nextInt(max - min + 1);
    }

    // Use digit range from progressive system
    final (minDigit, maxDigit) = progressive.digitRange;
    final effectiveDifficulty = progressive.effectiveDifficulty;

    switch (operation) {
      case MathOperation.addition:
        operand1 = randomInRange(minDigit, maxDigit);
        operand2 = randomInRange(minDigit, maxDigit);
        correctAnswer = operand1 + operand2;
        break;
      case MathOperation.subtraction:
        operand1 = randomInRange(minDigit, maxDigit);
        operand2 = randomInRange(minDigit, operand1); // Ensure positive result
        correctAnswer = operand1 - operand2;
        break;
      case MathOperation.multiplication:
        // For multiplication, use smaller ranges to keep manageable
        int minFactor, maxFactor;
        switch (progressive.digitLevel) {
          case 1:
            minFactor = 1; maxFactor = 10; // 1-10
            break;
          case 2:
            minFactor = 2; maxFactor = 12; // 2-12
            break;
          case 3:
            minFactor = 3; maxFactor = 15; // 3-15
            break;
          case 4:
            minFactor = 5; maxFactor = 20; // 5-20
            break;
          case 5:
            minFactor = 8; maxFactor = 25; // 8-25
            break;
          default:
            minFactor = 1; maxFactor = 10;
        }
        operand1 = randomInRange(minFactor, maxFactor);
        operand2 = randomInRange(minFactor, maxFactor);
        correctAnswer = operand1 * operand2;
        break;
      case MathOperation.division:
        // Division: generate clean division problems
        int minDiv, maxDiv;
        switch (progressive.digitLevel) {
          case 1:
            minDiv = 1; maxDiv = 10;
            break;
          case 2:
            minDiv = 2; maxDiv = 12;
            break;
          case 3:
            minDiv = 3; maxDiv = 15;
            break;
          case 4:
            minDiv = 5; maxDiv = 20;
            break;
          case 5:
            minDiv = 8; maxDiv = 25;
            break;
          default:
            minDiv = 1; maxDiv = 10;
        }
        operand2 = randomInRange(minDiv, maxDiv); // divisor
        if (operand2 == 0) operand2 = 1;
        correctAnswer = randomInRange(minDiv, maxDiv); // quotient
        operand1 = correctAnswer * operand2; // dividend
        break;
      case MathOperation.modulo:
        operand1 = randomInRange(minDigit, maxDigit);
        operand2 = randomInRange(minDigit, maxDigit);
        if (operand2 == 0) operand2 = 1;
        correctAnswer = operand1 % operand2;
        break;
    }

    // Generate options (1 correct + 3 wrong)
    options.add(correctAnswer);
    final wrongAnswers = <int>{};
    while (wrongAnswers.length < 3) {
      // Scale offset based on digit level
      int offsetRange = (progressive.digitLevel * 5).clamp(10, 50);
      int offset = rng.nextInt(offsetRange) - (offsetRange ~/ 2);
      int wrong = correctAnswer + offset;
      if (wrong != correctAnswer && wrong >= 0 && !wrongAnswers.contains(wrong)) {
        wrongAnswers.add(wrong);
      }
    }
    options.addAll(wrongAnswers);
    options.shuffle(rng);

    return MathQuestion(
      operation: operation,
      difficulty: effectiveDifficulty,
      operand1: operand1,
      operand2: operand2,
      correctAnswer: correctAnswer,
      options: options,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'operation': operation.index,
        'difficulty': difficulty.index,
        'operand1': operand1,
        'operand2': operand2,
        'correctAnswer': correctAnswer,
        'options': options,
        'createdAt': createdAt.toIso8601String(),
      };

  factory MathQuestion.fromJson(Map<String, dynamic> json) => MathQuestion(
        id: json['id'],
        operation: MathOperation.values[json['operation']],
        difficulty: Difficulty.values[json['difficulty']],
        operand1: json['operand1'],
        operand2: json['operand2'],
        correctAnswer: json['correctAnswer'],
        options: List<int>.from(json['options']),
        createdAt: DateTime.parse(json['createdAt']),
      );
}