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
  }) {
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    int operand1, operand2, correctAnswer;
    List<int> options = [];

    switch (operation) {
      case MathOperation.addition:
        operand1 = difficulty.minValue + (random % (difficulty.maxValue - difficulty.minValue + 1));
        operand2 = difficulty.minValue + ((random * 7) % (difficulty.maxValue - difficulty.minValue + 1));
        correctAnswer = operand1 + operand2;
        break;
      case MathOperation.subtraction:
        operand1 = difficulty.minValue + (random % (difficulty.maxValue - difficulty.minValue + 1));
        operand2 = difficulty.minValue + ((random * 11) % (operand1 - difficulty.minValue + 1));
        correctAnswer = operand1 - operand2;
        break;
      case MathOperation.multiplication:
        operand1 = difficulty.minValue + (random % ((difficulty.maxValue ~/ 10) - difficulty.minValue + 1));
        operand2 = difficulty.minValue + ((random * 13) % ((difficulty.maxValue ~/ 10) - difficulty.minValue + 1));
        correctAnswer = operand1 * operand2;
        break;
      case MathOperation.division:
        operand2 = difficulty.minValue + (random % ((difficulty.maxValue ~/ 10) - difficulty.minValue + 1));
        if (operand2 == 0) operand2 = 1;
        correctAnswer = difficulty.minValue + ((random * 17) % ((difficulty.maxValue ~/ 10) - difficulty.minValue + 1));
        operand1 = correctAnswer * operand2;
        break;
      case MathOperation.modulo:
        operand1 = difficulty.minValue + (random % (difficulty.maxValue - difficulty.minValue + 1));
        operand2 = difficulty.minValue + ((random * 19) % (difficulty.maxValue - difficulty.minValue + 1));
        if (operand2 == 0) operand2 = 1;
        correctAnswer = operand1 % operand2;
        break;
    }

    // Generate options (1 correct + 3 wrong)
    options.add(correctAnswer);
    final wrongAnswers = <int>{};
    while (wrongAnswers.length < 3) {
      int offset = (random * 23 + wrongAnswers.length * 5) % 20 - 10;
      int wrong = correctAnswer + offset;
      if (wrong != correctAnswer && wrong >= 0 && !wrongAnswers.contains(wrong)) {
        wrongAnswers.add(wrong);
      }
    }
    options.addAll(wrongAnswers);
    options.shuffle();

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