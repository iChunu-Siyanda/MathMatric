import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';

class StreakHeaderCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int weeklyScore;

  const StreakHeaderCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.weeklyScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColours.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColours.border),
      ),
      child: Row(
        children: [
          // Fire Icon Avatar
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColours.warningAmber.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColours.warningAmber,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Main Streak Stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$currentStreak Day Streak',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColours.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Best: $longestStreak days • $weeklyScore% weekly consistency',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColours.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
