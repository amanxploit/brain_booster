import 'package:flutter/material.dart';
import '../models/math_question.dart';
import '../theme/design_tokens.dart';

/// Clean, accessible difficulty card with proper text handling
class DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;
  final bool compact;

  const DifficultyCard({
    super.key,
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = DesignTokens.getSurfaceColor(context);
    final borderColor = DesignTokens.getBorderColor(context);
    final textPrimary = DesignTokens.getTextPrimary(context);
    final textSecondary = DesignTokens.getTextSecondary(context);
    final textTertiary = DesignTokens.getTextTertiary(context);
    
    final color = _getDifficultyColor(difficulty);

    return Semantics(
      label: '${difficulty.name} difficulty${isSelected ? ', selected' : ''}',
      button: true,
      child: AnimatedContainer(
        duration: DesignTokens.animationNormal,
        curve: DesignTokens.curveDefault,
        padding: compact
            ? const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingSm,
              )
            : const EdgeInsets.all(DesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: isSelected ? color : surfaceColor,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: isSelected ? color : borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? DesignTokens.shadowColored(color, alpha: 0.2)
              : DesignTokens.shadowSubtle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            child: compact
                ? _buildCompactLayout(context, color, textPrimary, textSecondary, textTertiary)
                : _buildFullLayout(context, color, textPrimary, textSecondary, textTertiary),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLayout(
    BuildContext context,
    Color color,
    Color textPrimary,
    Color textSecondary,
    Color textTertiary,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Difficulty indicator dot
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        // Name
        Text(
          difficulty.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
            height: 1.3,
          ),
        ),
        const SizedBox(width: DesignTokens.spacingSm),
        // Range
        Text(
          '${difficulty.minValue}–${difficulty.maxValue}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSelected 
                ? Colors.white.withValues(alpha: 0.8) 
                : textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildFullLayout(
    BuildContext context,
    Color color,
    Color textPrimary,
    Color textSecondary,
    Color textTertiary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with name and points
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Colored indicator bar
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingSm),
            Expanded(
              child: Text(
                difficulty.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : textPrimary,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Points multiplier badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingSm,
                vertical: DesignTokens.spacingXs,
              ),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white.withValues(alpha: 0.15) 
                    : color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Text(
                '${difficulty.pointsMultiplier}x pts',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : color,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        // Range
        Text(
          '${difficulty.minValue} – ${difficulty.maxValue}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected 
                ? Colors.white.withValues(alpha: 0.8) 
                : textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        // Description
        Text(
          _getDifficultyDescription(difficulty),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: isSelected 
                ? Colors.white.withValues(alpha: 0.7) 
                : textTertiary,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getDifficultyDescription(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Perfect for beginners';
      case Difficulty.medium:
        return 'Balanced challenge';
      case Difficulty.hard:
        return 'For experienced players';
      case Difficulty.expert:
        return 'Maximum difficulty';
    }
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return DesignTokens.emerald;
      case Difficulty.medium:
        return DesignTokens.primaryBlue;
      case Difficulty.hard:
        return DesignTokens.amber;
      case Difficulty.expert:
        return DesignTokens.red;
    }
  }
}

/// Difficulty selector row for compact display
class DifficultySelector extends StatelessWidget {
  final Difficulty selectedDifficulty;
  final ValueChanged<Difficulty> onChanged;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Difficulty.values.map((difficulty) {
          final isSelected = difficulty == selectedDifficulty;
          return Padding(
            padding: EdgeInsets.only(
              right: difficulty != Difficulty.values.last ? DesignTokens.spacingSm : 0,
            ),
            child: DifficultyCard(
              difficulty: difficulty,
              isSelected: isSelected,
              onTap: () => onChanged(difficulty),
              compact: true,
            ),
          );
        }).toList(),
      ),
    );
  }
}