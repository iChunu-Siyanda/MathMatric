import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class TopicStreakHeader extends StatelessWidget {
  final int currentStreak;
  final bool isPersonalBest;
  final VoidCallback onTap;

  const TopicStreakHeader({
    super.key, 
    required this.currentStreak,
    required this.isPersonalBest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColours.primaryAccent.withAlpha(18),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            color: AppColours.primaryAccent,
            size: 23,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Your Streak',
                    style: TextStyle(
                      color: AppColours.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),

                  if (isPersonalBest) ...[
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColours.warningAmber.withAlpha(20),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'BEST',
                        style: TextStyle(
                          color: AppColours.warningAmber,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 3),

              Text(
                _subtitle,
                style: const TextStyle(
                  color: AppColours.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: onTap,
          tooltip: 'View streak history',
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColours.textMuted,
          ),
        ),
      ],
    );
  }

  String get _subtitle {
    if (currentStreak == 0) {
      return 'Start your study streak today.';
    }

    if (currentStreak == 1) {
      return 'A strong start. Come back tomorrow.';
    }

    if (currentStreak < 7) {
      return 'Keep building your study momentum.';
    }

    if (currentStreak < 30) {
      return 'Consistency is becoming a habit.';
    }

    return 'Outstanding discipline. Keep going.';
  }
}
