import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, _) {
        final settings = appProvider.settings;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Appearance Section
              _buildSectionHeader(context, 'Appearance'),
              const SizedBox(height: 12),
              _buildSettingTile(
                context,
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                leading: Icon(
                  settings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: Switch(
                  value: settings.isDarkMode,
                  onChanged: (_) => appProvider.toggleDarkMode(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Sound & Vibration Section
              _buildSectionHeader(context, 'Sound & Feedback'),
              const SizedBox(height: 12),
              _buildSettingTile(
                context,
                title: 'Sound Effects',
                subtitle: 'Play sounds for correct/incorrect answers',
                leading: Icon(
                  settings.soundEnabled ? Icons.volume_up : Icons.volume_off,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: Switch(
                  value: settings.soundEnabled,
                  onChanged: (_) => _toggleSound(appProvider, settings),
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                title: 'Vibration',
                subtitle: 'Vibrate on answer submission',
                leading: Icon(
                  settings.vibrationEnabled ? Icons.vibration : Icons.vibration_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: Switch(
                  value: settings.vibrationEnabled,
                  onChanged: (_) => _toggleVibration(appProvider, settings),
                ),
              ),
              const SizedBox(height: 24),
              
              // Game Settings Section
              _buildSectionHeader(context, 'Game Preferences'),
              const SizedBox(height: 12),
              _buildSettingTile(
                context,
                title: 'Questions per Session',
                subtitle: 'Number of questions in each game',
                leading: Icon(
                  Icons.quiz_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: DropdownButton<int>(
                  value: settings.questionsPerSession,
                  items: [5, 10, 15, 20, 25, 30, 40, 50]
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateQuestionsPerSession(appProvider, settings, value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                title: 'Question Time Limit',
                subtitle: 'Seconds per question (0 = no limit)',
                leading: Icon(
                  Icons.timer_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: DropdownButton<int>(
                  value: settings.questionTimeLimit,
                  items: [0, 10, 15, 20, 30, 45, 60]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e == 0 ? 'No Limit' : '${e}s')))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateTimeLimit(appProvider, settings, value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                title: 'Preferred Operation',
                subtitle: 'Default operation for new games',
                leading: Icon(
                  Icons.calculate,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: DropdownButton<MathOperation>(
                  value: settings.preferredOperation,
                  items: MathOperation.values
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updatePreferredOperation(appProvider, settings, value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                title: 'Preferred Difficulty',
                subtitle: 'Default difficulty for new games',
                leading: Icon(
                  Icons.trending_up,
                  color: Theme.of(context).colorScheme.primary,
                ),
                trailing: DropdownButton<Difficulty>(
                  value: settings.preferredDifficulty,
                  items: Difficulty.values
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updatePreferredDifficulty(appProvider, settings, value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              
              // Data Section
              _buildSectionHeader(context, 'Data Management'),
              const SizedBox(height: 12),
              _buildSettingTile(
                context,
                title: 'Reset Statistics',
                subtitle: 'Clear all progress and start fresh',
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showResetConfirmation(context, appProvider),
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                title: 'Export Data',
                subtitle: 'Export your game history and stats',
                leading: Icon(Icons.download, color: Theme.of(context).colorScheme.primary),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showExportDialog(context, appProvider),
              ),
              const SizedBox(height: 32),
              
              // About Section
              _buildSectionHeader(context, 'About'),
              const SizedBox(height: 12),
              _buildSettingTile(
                context,
                title: 'Version',
                subtitle: '1.0.0',
                leading: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              _buildSettingTile(
                context,
                title: 'Privacy Policy',
                subtitle: 'View our privacy policy',
                leading: Icon(Icons.privacy_tip_outlined, color: Theme.of(context).colorScheme.primary),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: leading,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _toggleSound(AppProvider appProvider, AppSettings settings) {
    appProvider.updateSettings(settings.copyWith(soundEnabled: !settings.soundEnabled));
  }

  void _toggleVibration(AppProvider appProvider, AppSettings settings) {
    appProvider.updateSettings(settings.copyWith(vibrationEnabled: !settings.vibrationEnabled));
  }

  void _updateQuestionsPerSession(AppProvider appProvider, AppSettings settings, int value) {
    appProvider.updateSettings(settings.copyWith(questionsPerSession: value));
  }

  void _updateTimeLimit(AppProvider appProvider, AppSettings settings, int value) {
    appProvider.updateSettings(settings.copyWith(questionTimeLimit: value));
  }

  void _updatePreferredOperation(AppProvider appProvider, AppSettings settings, MathOperation value) {
    appProvider.updateSettings(settings.copyWith(preferredOperation: value));
  }

  void _updatePreferredDifficulty(AppProvider appProvider, AppSettings settings, Difficulty value) {
    appProvider.updateSettings(settings.copyWith(preferredDifficulty: value));
  }

  void _showResetConfirmation(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Statistics?'),
        content: const Text(
          'This will permanently delete all your progress, including game history, streaks, and scores. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              appProvider.resetStats();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Statistics reset successfully')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export functionality coming soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}