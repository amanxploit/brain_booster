import 'math_question.dart';

class AppSettings {
  final bool isDarkMode;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final int questionTimeLimit;
  final int questionsPerSession;
  final MathOperation preferredOperation;
  final Difficulty preferredDifficulty;

  AppSettings({
    this.isDarkMode = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.questionTimeLimit = 30,
    this.questionsPerSession = 10,
    this.preferredOperation = MathOperation.addition,
    this.preferredDifficulty = Difficulty.easy,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? soundEnabled,
    bool? vibrationEnabled,
    int? questionTimeLimit,
    int? questionsPerSession,
    MathOperation? preferredOperation,
    Difficulty? preferredDifficulty,
  }) =>
      AppSettings(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        questionTimeLimit: questionTimeLimit ?? this.questionTimeLimit,
        questionsPerSession: questionsPerSession ?? this.questionsPerSession,
        preferredOperation: preferredOperation ?? this.preferredOperation,
        preferredDifficulty: preferredDifficulty ?? this.preferredDifficulty,
      );

  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
        'soundEnabled': soundEnabled,
        'vibrationEnabled': vibrationEnabled,
        'questionTimeLimit': questionTimeLimit,
        'questionsPerSession': questionsPerSession,
        'preferredOperation': preferredOperation.index,
        'preferredDifficulty': preferredDifficulty.index,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        isDarkMode: json['isDarkMode'] ?? false,
        soundEnabled: json['soundEnabled'] ?? true,
        vibrationEnabled: json['vibrationEnabled'] ?? true,
        questionTimeLimit: json['questionTimeLimit'] ?? 30,
        questionsPerSession: json['questionsPerSession'] ?? 10,
        preferredOperation: MathOperation.values[json['preferredOperation'] ?? 0],
        preferredDifficulty: Difficulty.values[json['preferredDifficulty'] ?? 0],
      );
}