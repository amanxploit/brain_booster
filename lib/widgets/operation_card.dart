import 'package:flutter/material.dart';
import '../models/math_question.dart';
import '../theme/design_tokens.dart';

/// Clean, accessible operation card with proper text handling
class OperationCard extends StatelessWidget {
  final MathOperation operation;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showLabel;

  const OperationCard({
    super.key,
    required this.operation,
    required this.isSelected,
    required this.onTap,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = DesignTokens.getSurfaceColor(context);
    final borderColor = DesignTokens.getBorderColor(context);
    
    final color = _getOperationColor(operation);

    return Semantics(
      label: '${operation.name} operation${isSelected ? ', selected' : ''}',
      button: true,
      child: AnimatedContainer(
        duration: DesignTokens.animationNormal,
        curve: DesignTokens.curveDefault,
        width: 88,
        padding: const EdgeInsets.symmetric(
          vertical: DesignTokens.spacingMd,
          horizontal: DesignTokens.spacingSm,
        ),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingXs,
                vertical: DesignTokens.spacingXs,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Operation symbol
                  Text(
                    operation.symbol,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : color,
                      height: 1.0,
                    ),
                  ),
                  if (showLabel) ...[
                    const SizedBox(height: DesignTokens.spacingXs),
                    // Operation name
                    Flexible(
                      child: Text(
                        operation.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? Colors.white.withValues(alpha: 0.95) 
                              : color,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getOperationColor(MathOperation operation) {
    switch (operation) {
      case MathOperation.addition:
        return DesignTokens.primaryBlue;
      case MathOperation.subtraction:
        return DesignTokens.emerald;
      case MathOperation.multiplication:
        return DesignTokens.amber;
      case MathOperation.division:
        return DesignTokens.purple;
      case MathOperation.modulo:
        return DesignTokens.red;
    }
  }
}

/// Compact operation chip for smaller spaces
class OperationChip extends StatelessWidget {
  final MathOperation operation;
  final bool isSelected;
  final VoidCallback onTap;

  const OperationChip({
    super.key,
    required this.operation,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getOperationColor(operation);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: '${operation.name} operation${isSelected ? ', selected' : ''}',
      button: true,
      child: AnimatedContainer(
        duration: DesignTokens.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd,
          vertical: DesignTokens.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : (isDark ? color.withValues(alpha: 0.12) : color.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingXs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    operation.symbol,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingXs),
                  Flexible(
                    child: Text(
                      operation.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white.withValues(alpha: 0.95) : color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getOperationColor(MathOperation operation) {
    switch (operation) {
      case MathOperation.addition:
        return DesignTokens.primaryBlue;
      case MathOperation.subtraction:
        return DesignTokens.emerald;
      case MathOperation.multiplication:
        return DesignTokens.amber;
      case MathOperation.division:
        return DesignTokens.purple;
      case MathOperation.modulo:
        return DesignTokens.red;
    }
  }
}