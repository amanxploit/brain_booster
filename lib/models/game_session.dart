import 'math_question.dart';

class GameSession {
  final String id;
  final DateTime date;
  final MathOperation operation;
  final Difficulty difficulty;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalScore;
  final int timeSpent;
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