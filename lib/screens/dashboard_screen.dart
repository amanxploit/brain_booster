import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/user_stats.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final stats = appProvider.userStats;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {}, // Consumer will rebuild automatically
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: stats.totalQuestions == 0
              ? _buildEmptyState(context)
              : CustomScrollView(
                  slivers: [
                    // Overview Stats
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overview',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _buildOverviewStats(context, stats),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    
                    // Accuracy Chart
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accuracy Trend (Last 14 Days)',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _buildAccuracyChart(context, stats),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    
                    // Operation Performance
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Operation Performance',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _buildOperationPerformance(context, stats),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    
                    // Difficulty Performance
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Difficulty Performance',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _buildDifficultyPerformance(context, stats),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    
                    // Contribution Calendar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Contributions',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _buildContributionCalendar(context, stats),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    
                    // Recent Activity
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Activity',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _buildRecentActivity(context, stats),
                            const SizedBox(height: 24),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Data Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Start playing games to see your brain training analytics here!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Training'),
              onPressed: () {
                // Navigate to game tab
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats(BuildContext context, UserStats stats) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Total Questions',
            value: stats.totalQuestions.toString(),
            icon: Icons.quiz_outlined,
            color: Theme.of(context).colorScheme.primary,
            trend: '${stats.correctAnswers} correct • ${stats.wrongAnswers} wrong',
            trendPositive: stats.correctAnswers > stats.wrongAnswers,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Accuracy',
            value: '${stats.accuracy.toStringAsFixed(1)}%',
            icon: Icons.assessment_outlined,
            color: stats.accuracy >= 70 ? Colors.green : (stats.accuracy >= 50 ? Colors.orange : Colors.red),
            trend: stats.accuracy >= 70 ? 'Excellent!' : (stats.accuracy >= 50 ? 'Good' : 'Needs Work'),
            trendPositive: stats.accuracy >= 50,
          ),
        ),
      ],
    );
  }

  Widget _buildAccuracyChart(BuildContext context, UserStats stats) {
    final last14Days = stats.dailyContributions
        .where((c) => c.date.isAfter(DateTime.now().subtract(const Duration(days: 14))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (last14Days.isEmpty) {
      return _buildEmptyChart(context, 'No data for the last 14 days');
    }

    final spots = last14Days.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final contribution = entry.value;
      return FlSpot(index, contribution.accuracy);
    }).toList();

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade300,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < last14Days.length) {
                    final date = last14Days[value.toInt()].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        DateFormat('MM/dd').format(date),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (last14Days.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: Theme.of(context).cardTheme.color ?? Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.primary,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final contribution = last14Days[spot.spotIndex];
                  return LineTooltipItem(
                    '${DateFormat('MMM dd').format(contribution.date)}\n${spot.y.toStringAsFixed(1)}% Accuracy',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context, String message) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.transparent),
      ),
      child: Center(
        child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildOperationPerformance(BuildContext context, UserStats stats) {
    final operations = <Map<String, dynamic>>[];
    
    for (final op in ['addition', 'subtraction', 'multiplication', 'division', 'modulo']) {
      final correct = stats.operationCorrect[op] ?? 0;
      final wrong = stats.operationWrong[op] ?? 0;
      final total = correct + wrong;
      if (total > 0) {
        operations.add({
          'name': op,
          'correct': correct,
          'wrong': wrong,
          'total': total,
          'accuracy': (correct / total * 100),
        });
      }
    }

    if (operations.isEmpty) {
      return _buildEmptyChart(context, 'Play games to see operation stats');
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade300,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < operations.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        operations[value.toInt()]['name'].substring(0, 3).toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}%', style: Theme.of(context).textTheme.labelSmall);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: operations.asMap().entries.map((entry) {
            final index = entry.key;
            final op = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: op['accuracy'],
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDifficultyPerformance(BuildContext context, UserStats stats) {
    final difficulties = <Map<String, dynamic>>[];
    
    for (final diff in ['easy', 'medium', 'hard', 'expert']) {
      final correct = stats.difficultyCorrect[diff] ?? 0;
      final wrong = stats.difficultyWrong[diff] ?? 0;
      final total = correct + wrong;
      if (total > 0) {
        difficulties.add({
          'name': diff,
          'correct': correct,
          'wrong': wrong,
          'total': total,
          'accuracy': (correct / total * 100),
        });
      }
    }

    if (difficulties.isEmpty) {
      return _buildEmptyChart(context, 'Play games to see difficulty stats');
    }

    return Column(
      children: difficulties.map((diff) {
        final accuracy = diff['accuracy'] as double;
        Color color;
        if (accuracy >= 80) color = Colors.green;
        else if (accuracy >= 60) color = Colors.orange;
        else color = Colors.red;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.transparent),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                child: Text(
                  diff['name'].toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${diff['correct']}/${diff['total']} correct'),
                        Text('${accuracy.toStringAsFixed(1)}%', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: accuracy / 100,
                        minHeight: 8,
                        backgroundColor: color.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContributionCalendar(BuildContext context, UserStats stats) {
    final last90Days = stats.dailyContributions
        .where((c) => c.date.isAfter(DateTime.now().subtract(const Duration(days: 90))))
        .toList();

    if (last90Days.isEmpty) {
      return _buildEmptyChart(context, 'Start playing to see your contribution calendar');
    }

    // Group by week
    final weeks = <List<DailyContribution>>[];
    var currentWeek = <DailyContribution>[];
    
    for (var i = 0; i < 90; i++) {
      final date = DateTime.now().subtract(Duration(days: 89 - i));
      final contribution = last90Days.firstWhere(
        (c) => c.date.year == date.year && c.date.month == date.month && c.date.day == date.day,
        orElse: () => DailyContribution(
          dateKey: '',
          date: date,
          questionsAnswered: 0,
          correctAnswers: 0,
        ),
      );
      currentWeek.add(contribution);
      
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }
    if (currentWeek.isNotEmpty) weeks.add(currentWeek);

    return Column(
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(context, Colors.grey.shade300, '0'),
            const SizedBox(width: 8),
            _buildLegendItem(context, Theme.of(context).colorScheme.primary.withOpacity(0.3), 'Low'),
            const SizedBox(width: 8),
            _buildLegendItem(context, Theme.of(context).colorScheme.primary.withOpacity(0.6), 'Med'),
            const SizedBox(width: 8),
            _buildLegendItem(context, Theme.of(context).colorScheme.primary, 'High'),
          ],
        ),
        const SizedBox(height: 16),
        // Calendar Grid
        SizedBox(
          height: weeks.length * 32.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day labels
              Column(
                children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .map((day) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            day,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(width: 16),
              // Weeks
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: weeks.asMap().entries.map((entry) {
                    final weekIndex = entry.key;
                    final week = entry.value;
                    return Expanded(
                      child: Column(
                        children: week.asMap().entries.map((dayEntry) {
                          final dayIndex = dayEntry.key;
                          final contribution = dayEntry.value;
                          return Container(
                            margin: const EdgeInsets.all(2),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _getContributionColor(context, contribution),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Color _getContributionColor(BuildContext context, DailyContribution contribution) {
    if (contribution.questionsAnswered == 0) {
      return Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200;
    }
    final intensity = (contribution.questionsAnswered / 20).clamp(0.0, 1.0);
    return Color.lerp(
      Theme.of(context).colorScheme.primary.withOpacity(0.2),
      Theme.of(context).colorScheme.primary,
      intensity,
    )!;
  }

  Widget _buildRecentActivity(BuildContext context, UserStats stats) {
    // This would show recent game sessions
    // For now, show a summary
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.transparent),
      ),
      child: Column(
        children: [
          _buildActivityRow(context, 'Last Played', _formatDate(stats.lastPlayedDate), Icons.calendar_today),
          const Divider(height: 16),
          _buildActivityRow(context, 'Current Streak', '${stats.currentStreak} days', Icons.local_fire_department),
          const Divider(height: 16),
          _buildActivityRow(context, 'Best Streak', '${stats.bestStreak} days', Icons.emoji_events),
          const Divider(height: 16),
          _buildActivityRow(context, 'Total Score', stats.totalScore.toString(), Icons.star),
          const Divider(height: 16),
          _buildActivityRow(context, 'Active Days', stats.dailyContributions.length.toString(), Icons.calendar_month),
        ],
      ),
    );
  }

  Widget _buildActivityRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '${difference} days ago';
  }
}