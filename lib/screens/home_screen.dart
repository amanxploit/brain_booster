import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/game_provider.dart';
import '../models/math_question.dart';
import '../models/user_stats.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final stats = appProvider.userStats;
        final gameProvider = context.watch<GameProvider>();
        final isDark = appProvider.settings.isDarkMode;
        
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Modern App Bar with Gradient Header
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: _buildAppBarTitle(context, isDark),
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                  background: _buildHeaderBackground(context, isDark, stats),
                ),
                actions: _buildAppBarActions(context, appProvider, isDark),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section (now more compact since header has stats)
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
                      
                      // Brain Strength (moved to header, keep for detail view)
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

  Widget _buildHeaderBackground(BuildContext context, bool isDark, UserStats stats) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final strengthColor = _getStrengthColor(stats.brainStrength);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B), // Indigo 900
                  const Color(0xFF312E81), // Indigo 800
                  const Color(0xFF0F172A), // Slate 900
                ]
              : [
                  primaryColor.withValues(alpha: 0.9),
                  secondaryColor.withValues(alpha: 0.8),
                  primaryColor.withValues(alpha: 0.7),
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Decorative shapes
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    strengthColor.withValues(alpha: 0.3),
                    strengthColor.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    secondaryColor.withValues(alpha: 0.2),
                    secondaryColor.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Brain strength indicator at bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildHeaderBrainStrength(context, stats, strengthColor, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBrainStrength(BuildContext context, UserStats stats, Color strengthColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withValues(alpha: 0.1) 
            : Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.white.withValues(alpha: 0.2) 
              : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: strengthColor.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Brain icon with strength color
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  strengthColor,
                  strengthColor.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: strengthColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          // Strength info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Brain Power',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.8) 
                            : Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: strengthColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        stats.brainStrengthLabel.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Progress bar
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: isDark 
                            ? Colors.white.withValues(alpha: 0.2) 
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: stats.brainStrength / 100,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              strengthColor,
                              strengthColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Percentage
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${stats.brainStrength}%',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: strengthColor.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              Text(
                '${stats.currentStreak} 🔥 streak',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.7) 
                      : Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context, bool isDark) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: isDark
            ? [Colors.white, const Color(0xFFE0E7FF)]
            : [const Color(0xFF1E293B), const Color(0xFF312E81)],
      ).createShader(bounds),
      child: const Text(
        'Brain Booster',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, AppProvider appProvider, bool isDark) {
    return [
      // History button with badge
      Stack(
        children: [
          IconButton(
            icon: Icon(
              Icons.history_rounded,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              size: 26,
            ),
            onPressed: () => Navigator.pushNamed(context, '/history'),
            tooltip: 'History',
          ),
        ],
      ),
      // Theme toggle with animated icon
      Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isDark 
              ? Colors.white.withValues(alpha: 0.15) 
              : Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark 
                ? Colors.white.withValues(alpha: 0.2) 
                : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => RotationTransition(
              turns: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Icon(
              appProvider.settings.isDarkMode 
                  ? Icons.wb_sunny_rounded 
                  : Icons.nights_stay_rounded,
              key: ValueKey(appProvider.settings.isDarkMode),
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              size: 24,
            ),
          ),
          onPressed: () => appProvider.toggleDarkMode(),
          tooltip: appProvider.settings.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        ),
      ),
    ];
  }

  Widget _buildWelcomeSection(BuildContext context, UserStats stats) {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;
    if (hour < 12) {
      greeting = 'Good Morning';
      emoji = '☀️';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      emoji = '🌤️';
    } else {
      greeting = 'Good Evening';
      emoji = '🌙';
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
                ]
              : [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$greeting!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Ready to boost your brain?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Animated brain icon
          _buildAnimatedBrainIcon(context),
        ],
      ),
    );
  }

  Widget _buildAnimatedBrainIcon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              size: 34,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Color _getStrengthColor(int strength) {
    if (strength >= 90) return const Color(0xFF7C3AED); // Purple
    if (strength >= 75) return const Color(0xFF3B82F6); // Blue
    if (strength >= 60) return const Color(0xFF10B981); // Emerald
    if (strength >= 40) return const Color(0xFFF59E0B); // Amber
    if (strength >= 20) return const Color(0xFFF97316); // Orange
    return const Color(0xFFEF4444); // Red
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
              color: Colors.black.withValues(alpha: 0.05),
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
                color: color.withValues(alpha: 0.15),
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
                color: _getStrengthColor(stats.brainStrength).withValues(alpha: 0.15),
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
}