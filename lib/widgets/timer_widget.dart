import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int timeLimit;
  final int timeElapsed;
  final Animation<double> pulseAnimation;

  const TimerWidget({
    super.key,
    required this.timeLimit,
    required this.timeElapsed,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = timeLimit - timeElapsed;
    final progress = timeElapsed / timeLimit;
    final isWarning = progress > 0.7;
    final isCritical = progress > 0.9;

    Color progressColor;
    if (isCritical) progressColor = Colors.red;
    else if (isWarning) progressColor = Colors.orange;
    else progressColor = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: (isWarning || isCritical) && progress < 1.0 ? pulseAnimation.value : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: progressColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: progressColor.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 16,
                  color: progressColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '$remaining',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: progressColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 40,
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: 1 - progress.clamp(0.0, 1.0),
                      backgroundColor: progressColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}