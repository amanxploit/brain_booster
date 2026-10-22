import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/app_provider.dart';
import '../providers/game_provider.dart';
import '../models/math_question.dart';
import '../models/user_stats.dart';
import '../widgets/widgets.dart';
import '../theme/design_tokens.dart';

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
                expandedHeight: 180,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: DesignTokens.pageMargin, bottom: 12),
                  background: _buildHeaderBackground(context, isDark, stats),
                ),
                actions: _buildAppBarActions(context, appProvider, isDark),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: DesignTokens.pageMargin,
                    right: DesignTokens.pageMargin,
                    bottom: DesignTokens.spacing3xl + kBottomNavigationBarHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: DesignTokens.spacingLg),

                      // Welcome Section
                      _buildWelcomeSection(context, stats),
                      const SizedBox(height: DesignTokens.sectionGap),

                      // Progress Metrics Grid
                      _buildProgressMetrics(context, stats),
                      const SizedBox(height: DesignTokens.sectionGap),

                      // Training Operations
                      _buildOperationsSection(context, gameProvider),
                      const SizedBox(height: DesignTokens.sectionGap),

                      // Difficulty Selection
                      _buildDifficultySection(context, gameProvider),
                      const SizedBox(height: DesignTokens.sectionGap),

                      // Quick Actions
                      _buildQuickActions(context, gameProvider),
                      const SizedBox(height: DesignTokens.spacing3xl),
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
    final primaryColor = DesignTokens.getPrimaryAccent(context);
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final strengthColor = _getStrengthColor(stats.brainStrength);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0F172A), // Slate 900
                  const Color(0xFF1E1B4B), // Indigo 900
                  const Color(0xFF1E293B), // Slate 800
                ]
              : [
                  primaryColor.withValues(alpha: 0.08),
                  primaryColor.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Subtle decorative shapes
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    strengthColor.withValues(alpha: 0.08),
                    strengthColor.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    secondaryColor.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // App Title at top
          Positioned(
            top: 50,
            left: DesignTokens.pageMargin,
            right: DesignTokens.pageMargin,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.white, const Color(0xFFE0E7FF)]
                    : [const Color(0xFF1E293B), const Color(0xFF312E81)],
              ).createShader(bounds),
              child: const Text(
                'Brain Booster',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Brain strength indicator at bottom of header
          Positioned(
            bottom: 16,
            left: DesignTokens.pageMargin,
            right: DesignTokens.pageMargin,
            child: _buildHeaderBrainStrength(context, stats, strengthColor, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBrainStrength(BuildContext context, UserStats stats, Color strengthColor, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingMd),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: strengthColor.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            children: [
              // Brain icon with strength color
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      strengthColor,
                      strengthColor.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: strengthColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
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
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingSm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignTokens.spacingSm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: strengthColor,
                            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                          ),
                          child: Text(
                            stats.brainStrengthLabel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    // Progress bar with label
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: stats.brainStrength / 100,
                              child: Container(
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
                          ),
                        ),
                        const SizedBox(width: DesignTokens.spacingSm),
                        Text(
                          '${stats.brainStrength}%',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              // Streak info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${stats.currentStreak}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: DesignTokens.amber.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '🔥 ${stats.currentStreak == 1 ? 'day' : 'day'} streak',
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
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, AppProvider appProvider, bool isDark) {
    return [
      // History button
      IconButton(
        icon: Icon(
          Icons.history_rounded,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
          size: 26,
        ),
        onPressed: () => Navigator.pushNamed(context, '/history'),
        tooltip: 'History',
        style: IconButton.styleFrom(
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          ),
        ),
      ),
      // Theme toggle with animated icon
      Container(
        margin: const EdgeInsets.only(right: DesignTokens.spacingSm),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: IconButton(
          icon: AnimatedSwitcher(
            duration: DesignTokens.animationNormal,
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
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
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
    final primaryColor = DesignTokens.getPrimaryAccent(context);
    final textPrimary = DesignTokens.getTextPrimary(context);
    final textSecondary = DesignTokens.getTextSecondary(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  primaryColor.withValues(alpha: 0.1),
                  primaryColor.withValues(alpha: 0.05),
                ]
              : [
                  primaryColor.withValues(alpha: 0.06),
                  primaryColor.withValues(alpha: 0.03),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
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
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Expanded(
                      child: Text(
                        '$greeting!',
                        style: DesignTokens.headline3.copyWith(
                          color: textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  'Ready to train your brain?',
                  style: DesignTokens.bodyMedium.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Start Training Button - Primary CTA
          _buildStartTrainingButton(context, primaryColor, stats),
        ],
      ),
    );
  }

  Widget _buildStartTrainingButton(BuildContext context, Color primaryColor, UserStats stats) {
    final hasPlayedBefore = stats.totalQuestions > 0;

    return Semantics(
      label: hasPlayedBefore ? 'Continue training' : 'Start training',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final gameProvider = context.read<GameProvider>();
            gameProvider.setQuestionsPerSession(10);
            gameProvider.setOperation(MathOperation.addition);
            gameProvider.setDifficulty(Difficulty.medium);
            Navigator.pushNamed(context, '/game');
          },
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingLg,
              vertical: DesignTokens.spacingMd,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasPlayedBefore ? Icons.play_arrow_rounded : Icons.rocket_launch_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Text(
                  hasPlayedBefore ? 'Continue Training' : 'Start Training',
                  style: DesignTokens.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressMetrics(BuildContext context, UserStats stats) {
    final textPrimary = DesignTokens.getTextPrimary(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Progress',
              style: DesignTokens.headline3.copyWith(color: textPrimary),
            ),
            if (stats.totalQuestions > 0)
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                child: Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DesignTokens.getPrimaryAccent(context),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingMd),

        if (stats.totalQuestions == 0)
          _buildEmptyProgressState(context)
        else
          _buildMetricsGrid(context, stats, isDark),
      ],
    );
  }

  Widget _buildEmptyProgressState(BuildContext context) {
    final textSecondary = DesignTokens.getTextSecondary(context);
    final primaryColor = DesignTokens.getPrimaryAccent(context);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacing3xl),
      decoration: BoxDecoration(
        color: DesignTokens.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        border: Border.all(
          color: DesignTokens.getBorderColor(context),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.psychology_rounded,
              size: 40,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          Text(
            'No Training Data Yet',
            style: DesignTokens.titleMedium.copyWith(
              color: DesignTokens.getTextPrimary(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          Text(
            'Complete your first training session to see your progress here.',
            style: DesignTokens.bodyMedium.copyWith(
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingLg),
          _buildStartTrainingButton(context, primaryColor, UserStats()),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, UserStats stats, bool isDark) {
    final primaryColor = DesignTokens.getPrimaryAccent(context);
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final crossAxisCount = isWide ? 4 : 2;
        final childAspectRatio = isWide ? 1.3 : 1.15;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: DesignTokens.componentGap,
          crossAxisSpacing: DesignTokens.componentGap,
          childAspectRatio: childAspectRatio,
          children: [
            StatCard(
              title: 'Accuracy',
              value: '${stats.accuracy.toStringAsFixed(1)}%',
              icon: Icons.psychology_rounded,
              color: primaryColor,
              subtitle: '${stats.correctAnswers} of ${stats.totalQuestions} correct',
              trend: stats.accuracy >= 70 ? 'Strong' : stats.accuracy >= 50 ? 'Good' : 'Improving',
              trendPositive: stats.accuracy >= 50,
            ),
            StatCard(
              title: 'Questions',
              value: _formatNumber(stats.totalQuestions),
              icon: Icons.quiz_rounded,
              color: secondaryColor,
              subtitle: '${stats.correctAnswers} correct',
              trend: '+${stats.correctAnswers} this session',
              trendPositive: true,
            ),
            StatCard(
              title: 'Best Streak',
              value: '${stats.bestStreak}',
              icon: Icons.local_fire_department_rounded,
              color: DesignTokens.amber,
              subtitle: 'Current: ${stats.currentStreak}',
              trend: stats.currentStreak > 0 ? 'On fire!' : 'Start a streak',
              trendPositive: stats.currentStreak > 0,
            ),
            StatCard(
              title: 'Time Spent',
              value: _formatTime(stats.totalTimeSpent),
              icon: Icons.timer_rounded,
              color: DesignTokens.purple,
              subtitle: 'Total training time',
              trend: stats.totalTimeSpent >= 3600 ? '${(stats.totalTimeSpent / 3600).floor()}h total' : '${(stats.totalTimeSpent / 60).floor()}m total',
              trendPositive: true,
            ),
          ],
        );
      },
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatTime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${(seconds / 60).floor()} min';
    final hours = (seconds / 3600).floor();
    final minutes = ((seconds % 3600) / 60).floor();
    return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
  }

  Widget _buildOperationsSection(BuildContext context, GameProvider gameProvider) {
    final textPrimary = DesignTokens.getTextPrimary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Operation',
              style: DesignTokens.headline3.copyWith(color: textPrimary),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/game'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingSm,
                  vertical: DesignTokens.spacingXs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: DesignTokens.getPrimaryAccent(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MathOperation.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: DesignTokens.componentGap),
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
    final textPrimary = DesignTokens.getTextPrimary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Difficulty',
          style: DesignTokens.headline3.copyWith(color: textPrimary),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        DifficultySelector(
          selectedDifficulty: gameProvider.selectedDifficulty,
          onChanged: (difficulty) => gameProvider.setDifficulty(difficulty),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, GameProvider gameProvider) {
    final textPrimary = DesignTokens.getTextPrimary(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Start',
          style: DesignTokens.headline3.copyWith(color: textPrimary),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            if (isWide) {
              return Row(
                children: [
                  Expanded(child: _buildActionCard(context, 'Daily Challenge', '10 mixed questions', Icons.calendar_today_rounded, DesignTokens.amber, () {
                    _startPresetGame(context, gameProvider, 10, MathOperation.addition, Difficulty.medium);
                  })),
                  const SizedBox(width: DesignTokens.componentGap),
                  Expanded(child: _buildActionCard(context, 'Speed Run', '20 questions, 15s each', Icons.flash_on_rounded, DesignTokens.red, () {
                    _startPresetGame(context, gameProvider, 20, MathOperation.addition, Difficulty.easy, timeLimit: 15);
                  })),
                  const SizedBox(width: DesignTokens.componentGap),
                  Expanded(child: _buildActionCard(context, 'Practice Mode', 'No time limit', Icons.school_rounded, DesignTokens.emerald, () {
                    _startPresetGame(context, gameProvider, 15, MathOperation.addition, Difficulty.easy, timeLimit: 0);
                  })),
                  const SizedBox(width: DesignTokens.componentGap),
                  Expanded(child: _buildActionCard(context, 'Custom Game', 'Your settings', Icons.tune_rounded, DesignTokens.getPrimaryAccent(context), () {
                    Navigator.pushNamed(context, '/game');
                  })),
                ],
              );
            }
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildActionCard(context, 'Daily Challenge', '10 mixed questions', Icons.calendar_today_rounded, DesignTokens.amber, () {
                      _startPresetGame(context, gameProvider, 10, MathOperation.addition, Difficulty.medium);
                    })),
                    const SizedBox(width: DesignTokens.componentGap),
                    Expanded(child: _buildActionCard(context, 'Speed Run', '20 questions, 15s each', Icons.flash_on_rounded, DesignTokens.red, () {
                      _startPresetGame(context, gameProvider, 20, MathOperation.addition, Difficulty.easy, timeLimit: 15);
                    })),
                  ],
                ),
                const SizedBox(height: DesignTokens.componentGap),
                Row(
                  children: [
                    Expanded(child: _buildActionCard(context, 'Practice Mode', 'No time limit', Icons.school_rounded, DesignTokens.emerald, () {
                      _startPresetGame(context, gameProvider, 15, MathOperation.addition, Difficulty.easy, timeLimit: 0);
                    })),
                    const SizedBox(width: DesignTokens.componentGap),
                    Expanded(child: _buildActionCard(context, 'Custom Game', 'Your settings', Icons.tune_rounded, DesignTokens.getPrimaryAccent(context), () {
                      Navigator.pushNamed(context, '/game');
                    })),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _startPresetGame(
    BuildContext context,
    GameProvider gameProvider,
    int questions,
    MathOperation operation,
    Difficulty difficulty, {
    int? timeLimit,
  }) {
    gameProvider.setQuestionsPerSession(questions);
    gameProvider.setOperation(operation);
    gameProvider.setDifficulty(difficulty);
    if (timeLimit != null) {
      gameProvider.setTimeLimit(timeLimit);
    }
    Navigator.pushNamed(context, '/game');
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final surfaceColor = DesignTokens.getSurfaceColor(context);
    final borderColor = DesignTokens.getBorderColor(context);

    return Semantics(
      label: '$title, $subtitle',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.cardPadding),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            border: Border.all(
              color: borderColor,
            ),
            boxShadow: DesignTokens.shadowSubtle,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              Text(
                title,
                style: DesignTokens.titleSmall.copyWith(
                  color: DesignTokens.getTextPrimary(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              Text(
                subtitle,
                style: DesignTokens.bodySmall.copyWith(
                  color: DesignTokens.getTextTertiary(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStrengthColor(int strength) {
    if (strength >= 90) return DesignTokens.purple;
    if (strength >= 75) return DesignTokens.primaryBlue;
    if (strength >= 60) return DesignTokens.emerald;
    if (strength >= 40) return DesignTokens.amber;
    if (strength >= 20) return DesignTokens.amberDark;
    return DesignTokens.red;
  }
}