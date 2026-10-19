import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/math_question.dart';
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
              _buildSettingsCard(context, [
                _buildSwitchTile(
                  context,
                  'Dark Mode',
                  'Use dark theme',
                  Icons.dark_mode,
                  settings.isDarkMode,
                  (value) => appProvider.toggleDarkMode(),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  context,
                  'Sound Effects',
                  'Play sounds for correct/incorrect answers',
                  Icons.volume_up,
                  settings.soundEnabled,
                  (value) => appProvider.updateSettings(settings.copyWith(soundEnabled: value)),
                ),
                const Divider(height: 1),
                _buildSwitchTile(
                  context,
                  'Vibration',
                  'Vibrate on answer submission',
                  Icons.vibration,
                  settings.vibrationEnabled,
                  (value) => appProvider.updateSettings(settings.copyWith(vibrationEnabled: value)),
                ),
              ]),
              const SizedBox(height: 24),

              // Game Settings Section
              _buildSectionHeader(context, 'Game Settings'),
              const SizedBox(height: 12),
              _buildSettingsCard(context, [
                _buildSliderTile(
                  context,
                  'Questions per Session',
                  settings.questionsPerSession == 0 ? 'Endless' : '${settings.questionsPerSession} questions',
                  Icons.quiz,
                  settings.questionsPerSession.toDouble(),
                  0,
                  200,
                  1,
                  (value) => appProvider.updateSettings(settings.copyWith(questionsPerSession: value.round())),
                ),
                const Divider(height: 1),
                _buildSliderTile(
                  context,
                  'Time Limit per Question',
                  settings.questionTimeLimit > 0 ? '${settings.questionTimeLimit} seconds' : 'No limit',
                  Icons.timer,
                  settings.questionTimeLimit.toDouble(),
                  0,
                  120,
                  5,
                  (value) => appProvider.updateSettings(settings.copyWith(questionTimeLimit: value.round())),
                ),
              ]),
              const SizedBox(height: 24),

              // Default Game Settings
              _buildSectionHeader(context, 'Default Game Mode'),
              const SizedBox(height: 12),
              _buildSettingsCard(context, [
                _buildDropdownTile<MathOperation>(
                  context,
                  'Default Operation',
                  'Choose the default math operation',
                  Icons.calculate,
                  settings.preferredOperation,
                  MathOperation.values,
                  (op) => op.name,
                  (value) => appProvider.updateSettings(settings.copyWith(preferredOperation: value!)),
                ),
                const Divider(height: 1),
                _buildDropdownTile<Difficulty>(
                  context,
                  'Default Difficulty',
                  'Choose the default difficulty level',
                  Icons.trending_up,
                  settings.preferredDifficulty,
                  Difficulty.values,
                  (diff) => diff.name,
                  (value) => appProvider.updateSettings(settings.copyWith(preferredDifficulty: value!)),
                ),
              ]),
              const SizedBox(height: 24),

              // Data Management
              _buildSectionHeader(context, 'Data Management'),
              const SizedBox(height: 12),
              _buildSettingsCard(context, [
                _buildActionTile(
                  context,
                  'Export Data',
                  'Export your stats as JSON',
                  Icons.download,
                  () => _exportData(context, appProvider),
                ),
                const Divider(height: 1),
                _buildActionTile(
                  context,
                  'Reset All Data',
                  'Clear all statistics and history',
                  Icons.delete_forever,
                  () => _confirmReset(context, appProvider),
                  isDestructive: true,
                ),
              ]),
              const SizedBox(height: 24),

              // About
              _buildSectionHeader(context, 'About'),
              const SizedBox(height: 12),
              _buildSettingsCard(context, [
                _buildInfoTile(context, 'Version', '1.0.0', Icons.info),
                const Divider(height: 1),
                _buildInfoTile(context, 'Built with', 'Flutter', Icons.code),
                const Divider(height: 1),
                _buildActionTile(
                  context,
                  'Rate App',
                  'Rate us on the Play Store',
                  Icons.star_rate,
                  () {},
                ),
                const Divider(height: 1),
                _buildActionTile(
                  context,
                  'Privacy Policy',
                  'View our privacy policy',
                  Icons.privacy_tip,
                  () {},
                ),
              ]),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    double value,
    double min,
    double max,
    double divisions,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions == 1 ? null : ((max - min) / divisions).round(),
            label: value == 0 ? 'No limit' : value.toInt().toString(),
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile<T>(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    T value,
    List<T> items,
    String Function(T) getLabel,
    ValueChanged<T?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: title,
          hintText: subtitle,
          prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
          border: InputBorder.none,
          isDense: true,
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            getLabel(item),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: isDestructive ? Colors.red : Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDestructive ? Colors.red : null,
                      ),
                    ),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _exportData(BuildContext context, AppProvider appProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon!')),
    );
  }

  void _confirmReset(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will permanently delete all your statistics, game history, and daily contributions. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              appProvider.resetStats();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data has been reset')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}