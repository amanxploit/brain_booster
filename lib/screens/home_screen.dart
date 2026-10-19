import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/game_provider.dart';
import '../models/math_question.dart';
import '../models/user_stats.dart';
import '../widgets/widgets.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final stats = appProvider.userStats;
        final gameProvider = context.watch<GameProvider>();
        
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Brain Booster'),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () => Navigator.pushNamed(context, '/history'),
                    tooltip: 'History',
                  ),
                  IconButton(
                    icon: Icon(appProvider.settings.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () => appProvider.toggleDarkMode(),
                    tooltip: 'Toggle Theme',
                  ),
                ],
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      _buildWelcomeSection(context, stats),
                      const SizedBox(height: 24),
                      
                      // Quick Stats
                      _buildQuickStats(context, stats),
                      const SizedBox(height: 24),
                      
                      // Operations
                      _buildOperationsSection(context, gameProvider),
                      const SizedBox(height: 24),
                      
                      // Difficulty
                      _buildDifficultySection(context, gameProvider),
                      const SizedBox(height: 24),
                      
                      // Quick Actions
                      _buildQuickActions(context, gameProvider),
                      const SizedBox(height: 24),
                      
                      // Brain Strength
                      _buildBrainStrength(context, stats),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context, UserStats stats) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) greeting = 'Good Morning';
    else if (hour < 17) greeting = 'Good Afternoon';
    else greeting = 'Good Evening';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.15),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting! 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready to train your brain?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMiniStat(
                      context,
                      Icons.psychology,
                      '${stats.brainStrength}%',
                      'Brain Power',
                    ),
                    const SizedBox(width: 16),
                    _buildMiniStat(
                      context,
                      Icons.local_fire_department,
                      '${stats.currentStreak}',
                      'Day Streak',
                    ),
                    const SizedBox(width: 16),
                    _buildMiniStat(
                      context,
                      Icons.star,
                      '${stats.totalScore}',
                      'Total Score',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, UserStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Accuracy',
                value: '${stats.accuracy.toStringAsFixed(1)}%',
                icon: Icons.assessment_outlined,
                color: Theme.of(context).colorScheme.primary,
                trend: stats.accuracy >= 70 ? 'Great!' : 'Keep practicing',
                trendPositive: stats.accuracy >= 70,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Questions',
                value: '${stats.totalQuestions}',
                icon: Icons.quiz_outlined,
                color: Theme.of(context).colorScheme.secondary,
                trend: '${stats.correctAnswers} correct',
                trendPositive: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Best Streak',
                value: '${stats.bestStreak}',
                icon: Icons.trending_up,
                color: Theme.of(context).colorScheme.tertiary,
                trend: 'Current: ${stats.currentStreak}',
                trendPositive: stats.currentStreak > 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Time Spent',
                value: _formatTime(stats.totalTimeSpent),
                icon: Icons.timer_outlined,
                color: Colors.purple,
                trend: 'Total training',
                trendPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${(seconds / 60).floor()}m';
    return '${(seconds / 3600).floor()}h ${((seconds % 3600) / 60).floor()}m';
  }

  Widget _buildOperationsSection(BuildContext context, GameProvider gameProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Operation',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/game'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MathOperation.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final operation = MathOperation.values[index];
              return OperationCard(
                operation: operation,
                isSelected: gameProvider.selectedOperation == operation,
                onTap: () => gameProvider.setOperation(operation),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySection(BuildContext context, GameProvider gameProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Difficulty',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: Difficulty.values.map((difficulty) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: difficulty != Difficulty.values.last ? 12 : 0),
                child: DifficultyCard(
                  difficulty: difficulty,
                  isSelected: gameProvider.selectedDifficulty == difficulty,
                  onTap: () => gameProvider.setDifficulty(difficulty),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, GameProvider gameProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Start',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Daily Challenge',
                '10 mixed questions',
                Icons.calendar_today,
                Colors.orange,
                () {
                  gameProvider.setQuestionsPerSession(10);
                  gameProvider.setOperation(MathOperation.addition);
                  gameProvider.setDifficulty(Difficulty.medium);
                  Navigator.pushNamed(context, '/game');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Speed Run',
                '20 questions, 15s each',
                Icons.speed,
                Colors.red,
                () {
                  gameProvider.setQuestionsPerSession(20);
                  gameProvider.setTimeLimit(15);
                  gameProvider.setDifficulty(Difficulty.easy);
                  Navigator.pushNamed(context, '/game');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Practice Mode',
                'No time limit',
                Icons.school,
                Colors.green,
                () {
                  gameProvider.setQuestionsPerSession(15);
                  gameProvider.setTimeLimit(0);
                  Navigator.pushNamed(context, '/game');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Custom Game',
                'Your settings',
                Icons.tune,
                Theme.of(context).colorScheme.primary,
                () => Navigator.pushNamed(context, '/game'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrainStrength(BuildContext context, UserStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Brain Strength',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStrengthColor(stats.brainStrength).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                stats.brainStrengthLabel,
                style: TextStyle(
                  color: _getStrengthColor(stats.brainStrength),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: stats.brainStrength / 100,
                      strokeWidth: 12,
                      backgroundColor: Theme.of(context).dividerTheme.color,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStrengthColor(stats.brainStrength),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${stats.brainStrength}%',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _getStrengthColor(stats.brainStrength),
                        ),
                      ),
                      Text(
                        'Brain Power',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStrengthMetric(context, 'Accuracy', '${stats.accuracy.toStringAsFixed(0)}%', Icons.assessment),
                  _buildStrengthMetric(context, 'Consistency', '${stats.dailyContributions.length} days', Icons.calendar_month),
                  _buildStrengthMetric(context, 'Streak', '${stats.currentStreak}', Icons.local_fire_department),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStrengthMetric(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Color _getStrengthColor(int strength) {
    if (strength >= 90) return Colors.purple;
    if (strength >= 75) return Colors.blue;
    if (strength >= 60) return Colors.green;
    if (strength >= 40) return Colors.orange;
    if (strength >= 20) return Colors.deepOrange;
    return Colors.red;
  }
}