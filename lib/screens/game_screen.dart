import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/game_provider.dart';
import '../providers/app_provider.dart';
import '../models/math_question.dart';
import '../models/user_stats.dart';
import '../services/storage_service.dart';
import '../widgets/widgets.dart';
import '../theme/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  Timer? _timer;
  int _secondsElapsed = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer(GameProvider gameProvider) {
    if (gameProvider.timeLimit > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _secondsElapsed++;
          gameProvider.updateTimeSpent(_secondsElapsed);
        });
        
        if (_secondsElapsed >= gameProvider.timeLimit) {
          timer.cancel();
          if (gameProvider.selectedAnswer == -1 && gameProvider.isGameActive && !gameProvider.showResult) {
            _handleTimeUp(gameProvider);
          }
        }
      });
    }
  }

  void _handleTimeUp(GameProvider gameProvider) {
    final question = gameProvider.currentQuestion!;
    // Auto-select a wrong answer to show result
    int wrongAnswer = question.options.firstWhere(
      (opt) => opt != question.correctAnswer,
      orElse: () => question.correctAnswer + 1,
    );
    gameProvider.selectAnswer(wrongAnswer);
    gameProvider.submitAnswer(_secondsElapsed);
  }

  void _resetTimer(GameProvider gameProvider) {
    _timer?.cancel();
    _secondsElapsed = 0;
    gameProvider.updateTimeSpent(0);
    if (gameProvider.isGameActive && gameProvider.timeLimit > 0) {
      _startTimer(gameProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameProvider, AppProvider>(
      builder: (context, gameProvider, appProvider, _) {
        if (!gameProvider.isGameActive && gameProvider.questions.isEmpty) {
          return _buildGameSetup(context, gameProvider);
        }

        final question = gameProvider.currentQuestion;
        if (question == null) return _buildGameSetup(context, gameProvider);

        final isLastQuestion = gameProvider.currentQuestionIndex == gameProvider.questions.length - 1;
        final progress = gameProvider.progress;

        // Start timer when game becomes active
        if (gameProvider.isGameActive && _timer == null && gameProvider.timeLimit > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startTimer(gameProvider);
          });
        }

        // Reset timer when question changes
        if (gameProvider.showResult && _timer != null) {
          _resetTimer(gameProvider);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${gameProvider.selectedOperation.name} - ${gameProvider.selectedDifficulty.name}',
              style: const TextStyle(fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              if (gameProvider.timeLimit > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TimerWidget(
                    timeLimit: gameProvider.timeLimit,
                    timeElapsed: _secondsElapsed,
                    pulseAnimation: _pulseAnimation,
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Progress Bar
                  _buildProgressSection(context, gameProvider, progress),
                  const SizedBox(height: 24),
                  
                  // Score & Stats
                  _buildScoreSection(context, gameProvider),
                  const SizedBox(height: 32),
                  
                  // Question Card
                  _buildQuestionCard(context, question, gameProvider),
                  const SizedBox(height: 24),
                  
                  // Answer Options
                  _buildAnswerOptions(context, question, gameProvider),
                  const SizedBox(height: 24),
                  
                  // Action Button
                  _buildActionButton(context, gameProvider, isLastQuestion),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameSetup(BuildContext context, GameProvider gameProvider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Game'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Icon(
                Icons.psychology,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Ready to Train?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Configure your game settings and start boosting your brain power!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Operation Selector
              Text(
                'Operation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: MathOperation.values.map((op) {
                  return ChoiceChip(
                    label: Text('${op.symbol} ${op.name}'),
                    selected: gameProvider.selectedOperation == op,
                    onSelected: (_) => gameProvider.setOperation(op),
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: gameProvider.selectedOperation == op
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              // Difficulty Selector
              Text(
                'Difficulty',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: Difficulty.values.map((diff) {
                  return ChoiceChip(
                    label: Text(diff.name),
                    selected: gameProvider.selectedDifficulty == diff,
                    onSelected: (_) => gameProvider.setDifficulty(diff),
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: gameProvider.selectedDifficulty == diff
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              // Settings
              Row(
                children: [
                  Expanded(
                    child: _buildSettingItem(
                      context,
                      'Questions',
                      gameProvider.questionsPerSession.toString(),
                      Icons.quiz,
                      () => _showQuestionsDialog(context, gameProvider),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSettingItem(
                      context,
                      'Time Limit',
                      gameProvider.timeLimit > 0 ? '${gameProvider.timeLimit}s' : 'None',
                      Icons.timer,
                      () => _showTimeLimitDialog(context, gameProvider),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Start Button
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow, size: 28),
                  label: const Text('Start Game', style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    gameProvider.startGame();
                    _secondsElapsed = 0;
                    _startTimer(gameProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String label, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showQuestionsDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Questions per Session'),
        content: StatefulBuilder(
          builder: (context, setState) => Slider(
            value: gameProvider.questionsPerSession.toDouble(),
            min: 5,
            max: 50,
            divisions: 9,
            label: gameProvider.questionsPerSession.toString(),
            onChanged: (value) {
              setState(() => gameProvider.setQuestionsPerSession(value.round()));
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ],
      ),
    );
  }

  void _showTimeLimitDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Limit per Question'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable Time Limit'),
                value: gameProvider.timeLimit > 0,
                onChanged: (value) {
                  setState(() => gameProvider.setTimeLimit(value ? 30 : 0));
                },
              ),
              if (gameProvider.timeLimit > 0)
                Slider(
                  value: gameProvider.timeLimit.toDouble(),
                  min: 10,
                  max: 120,
                  divisions: 11,
                  label: '${gameProvider.timeLimit}s',
                  onChanged: (value) {
                    setState(() => gameProvider.setTimeLimit(value.round()));
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, GameProvider gameProvider, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${gameProvider.currentQuestionIndex + 1} of ${gameProvider.questions.length}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection(BuildContext context, GameProvider gameProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildScoreCard(
            context,
            'Correct',
            gameProvider.correctCount.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildScoreCard(
            context,
            'Wrong',
            gameProvider.wrongCount.toString(),
            Icons.cancel,
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildScoreCard(
            context,
            'Score',
            gameProvider.totalScore.toString(),
            Icons.star,
            Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, MathQuestion question, GameProvider gameProvider) {
    return AnimatedScale(
      scale: gameProvider.showResult ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.15),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: gameProvider.showResult
                ? (gameProvider.lastAnswerCorrect ? Colors.green : Colors.red).withOpacity(0.5)
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 48,
                letterSpacing: 4,
              ),
              textAlign: TextAlign.center,
            ),
            if (gameProvider.showResult) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: gameProvider.lastAnswerCorrect ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      gameProvider.lastAnswerCorrect ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      gameProvider.lastAnswerCorrect ? 'Correct!' : 'Wrong!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                gameProvider.lastAnswerCorrect
                    ? 'Well done! +${gameProvider.selectedDifficulty.pointsMultiplier * 10} points'
                    : 'The answer was ${question.correctAnswer}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: gameProvider.lastAnswerCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(BuildContext context, MathQuestion question, GameProvider gameProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AnswerButton(
                text: question.options[0].toString(),
                isSelected: gameProvider.selectedAnswer == question.options[0],
                isCorrect: gameProvider.showResult && question.options[0] == question.correctAnswer,
                isWrong: gameProvider.showResult && gameProvider.selectedAnswer == question.options[0] && question.options[0] != question.correctAnswer,
                onTap: () => gameProvider.selectAnswer(question.options[0]),
                enabled: gameProvider.isGameActive && !gameProvider.showResult,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnswerButton(
                text: question.options[1].toString(),
                isSelected: gameProvider.selectedAnswer == question.options[1],
                isCorrect: gameProvider.showResult && question.options[1] == question.correctAnswer,
                isWrong: gameProvider.showResult && gameProvider.selectedAnswer == question.options[1] && question.options[1] != question.correctAnswer,
                onTap: () => gameProvider.selectAnswer(question.options[1]),
                enabled: gameProvider.isGameActive && !gameProvider.showResult,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AnswerButton(
                text: question.options[2].toString(),
                isSelected: gameProvider.selectedAnswer == question.options[2],
                isCorrect: gameProvider.showResult && question.options[2] == question.correctAnswer,
                isWrong: gameProvider.showResult && gameProvider.selectedAnswer == question.options[2] && question.options[2] != question.correctAnswer,
                onTap: () => gameProvider.selectAnswer(question.options[2]),
                enabled: gameProvider.isGameActive && !gameProvider.showResult,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnswerButton(
                text: question.options[3].toString(),
                isSelected: gameProvider.selectedAnswer == question.options[3],
                isCorrect: gameProvider.showResult && question.options[3] == question.correctAnswer,
                isWrong: gameProvider.showResult && gameProvider.selectedAnswer == question.options[3] && question.options[3] != question.correctAnswer,
                onTap: () => gameProvider.selectAnswer(question.options[3]),
                enabled: gameProvider.isGameActive && !gameProvider.showResult,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, GameProvider gameProvider, bool isLastQuestion) {
    if (!gameProvider.showResult) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: gameProvider.selectedAnswer != -1
              ? () => gameProvider.submitAnswer(_secondsElapsed)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            disabledBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          child: const Text(
            'Submit Answer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(isLastQuestion ? Icons.flag : Icons.arrow_forward, size: 24),
        label: Text(
          isLastQuestion ? 'Finish Game' : 'Next Question',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          if (isLastQuestion) {
            _finishGame(context, gameProvider);
          } else {
            gameProvider.nextQuestion();
            _secondsElapsed = 0;
            if (gameProvider.timeLimit > 0) {
              _startTimer(gameProvider);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _finishGame(BuildContext context, GameProvider gameProvider) async {
    _timer?.cancel();
    
    final session = gameProvider.createSession();
    final appProvider = context.read<AppProvider>();
    
    // Record each answer in user stats
    for (final result in session.questionResults) {
      appProvider.recordAnswer(
        isCorrect: result.isCorrect,
        operation: session.operation,
        difficulty: session.difficulty,
        timeSpent: result.timeSpent,
      );
    }
    
    await appProvider.saveGameSession(session);
    
    if (!mounted) return;
    
    // Show results dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildResultsDialog(context, session, gameProvider),
    );
  }

  Widget _buildResultsDialog(BuildContext context, GameSession session, GameProvider gameProvider) {
    final accuracy = session.accuracy;
    final isGreat = accuracy >= 80;
    final isGood = accuracy >= 60;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isGreat ? Colors.green : (isGood ? Colors.orange : Colors.red),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGreat ? Icons.emoji_events : (isGood ? Icons.thumb_up : Icons.sentiment_neutral),
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isGreat ? 'Excellent!' : (isGood ? 'Good Job!' : 'Keep Practicing!'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '${session.correctAnswers} out of ${session.totalQuestions} correct',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildResultRow(context, 'Accuracy', '${accuracy.toStringAsFixed(1)}%', Icons.assessment),
                  const Divider(height: 16),
                  _buildResultRow(context, 'Score', '+${session.totalScore}', Icons.star),
                  const Divider(height: 16),
                  _buildResultRow(context, 'Time', '${session.timeSpent}s', Icons.timer),
                  const Divider(height: 16),
                  _buildResultRow(context, 'Avg/Question', '${(session.timeSpent / session.totalQuestions).toStringAsFixed(1)}s', Icons.speed),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.replay),
                    label: const Text('Play Again'),
                    onPressed: () {
                      Navigator.pop(context);
                      gameProvider.startGame();
                      _secondsElapsed = 0;
                      _startTimer(gameProvider);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text('Home'),
                    onPressed: () {
                      Navigator.pop(context);
                      gameProvider.resetGame();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}