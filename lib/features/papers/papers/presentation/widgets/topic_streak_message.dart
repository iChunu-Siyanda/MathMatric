import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class TopicStreakMessage extends StatelessWidget {
  final int currentStreak;

  const TopicStreakMessage({
    super.key, 
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final String message = currentStreak == 0
        ? 'Complete a study session to start your streak.'
        : currentStreak == 1
            ? 'One day down. The next session keeps the streak alive.'
            : 'You have studied for $currentStreak consecutive days.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColours.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColours.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: AppColours.secondaryAccent,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColours.textSecondary,
                fontSize: 12.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
