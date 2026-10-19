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
        final maxFactor = (difficulty.maxValue / 10).floor();
        operand1 = randomInRange(difficulty.minValue, maxFactor.clamp(difficulty.minValue, 20));
        operand2 = randomInRange(difficulty.minValue, maxFactor.clamp(difficulty.minValue, 20));
        correctAnswer = operand1 * operand2;
        break;
      case MathOperation.division:
        operand2 = randomInRange(difficulty.minValue, (difficulty.maxValue / 10).floor().clamp(difficulty.minValue, 20));
        if (operand2 == 0) operand2 = 1;
        correctAnswer = randomInRange(difficulty.minValue, (difficulty.maxValue / 10).floor().clamp(difficulty.minValue, 20));
        operand1 = correctAnswer * operand2;
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