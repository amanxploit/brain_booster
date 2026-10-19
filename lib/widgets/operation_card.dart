import 'package:flutter/material.dart';
import '../models/math_question.dart';

class OperationCard extends StatelessWidget {
  final MathOperation operation;
  final bool isSelected;
  final VoidCallback onTap;

  const OperationCard({
    super.key,
    required this.operation,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getOperationColor(operation);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).dividerTheme.color ?? Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              operation.symbol,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              operation.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white.withOpacity(0.9) : color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
        return Colors.purple;
      case MathOperation.modulo:
        return Colors.red;
    }
  }
}