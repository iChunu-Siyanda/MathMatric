import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/progress_summary.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/progress_circle.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/progress_stat.dart';
import 'package:math_matric/theme/app_colours.dart';

class CompactProgressLayout extends StatelessWidget {
  final ProgressSummary progress;

  const CompactProgressLayout({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProgressCircle(
          progress: progress.progress,
        ),

        const SizedBox(height: 12),

        Text(
          '${progress.completedTopics} of '
          '${progress.totalTopics} topics completed',
          style: const TextStyle(
            color: AppColours.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: ProgressStat(
                icon: Icons.local_fire_department_rounded,
                label: 'Current streak',
                value: '${progress.currentStreak} days',
                iconColor: AppColours.neonCoral,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ProgressStat(
                icon: Icons.emoji_events_rounded,
                label: 'Best streak',
                value: '${progress.bestStreak} days',
                iconColor: AppColours.warningAmber,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
