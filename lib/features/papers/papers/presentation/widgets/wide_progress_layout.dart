import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/progress_summary.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/progress_circle.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/progress_stat.dart';
import 'package:math_matric/theme/app_colours.dart';

class WideProgressLayout extends StatelessWidget {
  final ProgressSummary progress;

  const WideProgressLayout({
    super.key, 
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProgressCircle(
          progress: progress.progress,
        ),

        const SizedBox(width: 28),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${progress.completedTopics} of '
                '${progress.totalTopics} topics completed',
                style: const TextStyle(
                  color: AppColours.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Keep going. Every topic brings you closer to exam readiness.',
                style: TextStyle(
                  color: AppColours.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  ProgressStat(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Current streak',
                    value: '${progress.currentStreak} days',
                    iconColor: AppColours.neonCoral,
                  ),

                  const SizedBox(width: 24),

                  ProgressStat(
                    icon: Icons.emoji_events_rounded,
                    label: 'Best streak',
                    value: '${progress.bestStreak} days',
                    iconColor: AppColours.warningAmber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
