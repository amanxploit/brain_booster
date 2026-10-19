import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../services/storage_service.dart';
import '../models/math_question.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Game History'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => appProvider.initialize(),
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: FutureBuilder<List<GameSession>>(
            future: _loadHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error loading history'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => appProvider.initialize(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              
              final sessions = snapshot.data ?? [];
              
              if (sessions.isEmpty) {
                return _buildEmptyState(context);
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return _buildSessionCard(context, session);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<List<GameSession>> _loadHistory() async {
    final storage = await StorageService.getInstance();
    return storage.getGameHistory();
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.history,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Game History Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start playing to see your game history here!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/game'),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, GameSession session) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');
    final durationFormat = DateFormat('mm:ss');
    final accuracyColor = _getAccuracyColor(session.accuracy);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getOperationColor(session.operation).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getOperationIcon(session.operation),
                  color: _getOperationColor(session.operation),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.operation.name.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      dateFormat.format(session.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(session.difficulty).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  session.difficulty.name.toUpperCase(),
                  style: TextStyle(
                    color: _getDifficultyColor(session.difficulty),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Score',
                  '${session.totalScore}',
                  Icons.star,
                  Colors.amber,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Accuracy',
                  '${session.accuracy.toStringAsFixed(1)}%',
                  Icons.assessment_outlined,
                  accuracyColor,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Time',
                  durationFormat.format(
                    DateTime.fromMillisecondsSinceEpoch(session.timeSpent * 1000, isUtc: true),
                  ),
                  Icons.timer_outlined,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Questions',
                  '${session.correctAnswers}/${session.totalQuestions}',
                  Icons.quiz_outlined,
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: session.accuracy / 100,
                    minHeight: 8,
                    backgroundColor: accuracyColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(accuracyColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${session.correctAnswers} correct, ${session.wrongAnswers} wrong',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 90) return Colors.green;
    if (accuracy >= 70) return Colors.lightGreen;
    if (accuracy >= 50) return Colors.orange;
    return Colors.red;
  }

  Color _getOperationColor(MathOperation operation) {
    switch (operation) {
      case MathOperation.addition:
        return Colors.blue;
      case MathOperation.subtraction:
        return Colors.green;
      case MathOperation.multiplication:
        return Colors.orange;
      case MathOperation.division:
        return Colors.red;
      case MathOperation.modulo:
        return Colors.purple;
    }
  }

  IconData _getOperationIcon(MathOperation operation) {
    switch (operation) {
      case MathOperation.addition:
        return Icons.add;
      case MathOperation.subtraction:
        return Icons.remove;
      case MathOperation.multiplication:
        return Icons.close;
      case MathOperation.division:
        return Icons.percent;
      case MathOperation.modulo:
        return Icons.shuffle;
    }
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
      case Difficulty.expert:
        return Colors.purple;
    }
  }
}