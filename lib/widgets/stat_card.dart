import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// A clean, accessible stat card with proper text handling and no truncation
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final String? trend;
  final bool? trendPositive;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trend,
    this.trendPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = DesignTokens.getSurfaceColor(context);
    final borderColor = DesignTokens.getBorderColor(context);
    final textPrimary = DesignTokens.getTextPrimary(context);
    final textSecondary = DesignTokens.getTextSecondary(context);
    final textTertiary = DesignTokens.getTextTertiary(context);

    final hasTrend = trend != null && trend!.isNotEmpty;
    final trendColor = (trendPositive ?? true) ? DesignTokens.emerald : DesignTokens.red;
    final trendIcon = (trendPositive ?? true) ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return Semantics(
      label: '$title: $value${subtitle != null ? ', $subtitle' : ''}${hasTrend ? ', ${trendPositive == true ? 'positive' : 'negative'} trend' : ''}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.cardPadding),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: DesignTokens.getCardShadow(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with icon and trend
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon container
                  Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingSm),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMd),
                  // Trend badge - only show if meaningful
                  if (hasTrend)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingSm,
                          vertical: DesignTokens.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: trendColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              trendIcon,
                              size: 11,
                              color: trendColor,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                trend!,
                                style: DesignTokens.labelSmall.copyWith(
                                  color: trendColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: DesignTokens.spacingMd),
              // Value - use FittedBox to prevent overflow
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: DesignTokens.numberMedium.copyWith(
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: DesignTokens.spacingXs),
              // Title
              Text(
                title,
                style: DesignTokens.bodySmall.copyWith(
                  color: textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Optional subtitle
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: DesignTokens.spacingXs),
                Text(
                  subtitle!,
                  style: DesignTokens.labelSmall.copyWith(
                    color: textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact version of StatCard for tighter layouts
class CompactStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool? trendPositive;

  const CompactStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    this.trendPositive,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = DesignTokens.getSurfaceColor(context);
    final borderColor = DesignTokens.getBorderColor(context);
    final textPrimary = DesignTokens.getTextPrimary(context);
    final textTertiary = DesignTokens.getTextTertiary(context);

    final hasTrend = trend != null && trend!.isNotEmpty;
    final trendColor = (trendPositive ?? true) ? DesignTokens.emerald : DesignTokens.red;

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingXs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: DesignTokens.spacingSm),
              if (hasTrend)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        (trendPositive ?? true) ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 9,
                        color: trendColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: trendColor,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: DesignTokens.numberSmall.copyWith(color: textPrimary),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textTertiary,
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}