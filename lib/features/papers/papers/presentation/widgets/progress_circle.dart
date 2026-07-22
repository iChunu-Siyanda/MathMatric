import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class ProgressCircle extends StatelessWidget {
  final double progress;

  const ProgressCircle({
    super.key, 
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return SizedBox(
      width: 138,
      height: 138,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 138,
            height: 138,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 11,
              backgroundColor: AppColours.surface.withAlpha(110),
              valueColor: AlwaysStoppedAnimation(
                AppColours.primaryAccent.withAlpha(25),
              ),
            ),
          ),

          SizedBox(
            width: 138,
            height: 138,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 11,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation(
                AppColours.cobaltBlue,
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: AppColours.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),

              const Text(
                'complete',
                style: TextStyle(
                  color: AppColours.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
