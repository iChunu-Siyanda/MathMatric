import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class StreakCardHeader extends StatelessWidget {
  final int current;
  final bool isPersonalBest;

  const StreakCardHeader({
    super.key, 
    required this.current,
    required this.isPersonalBest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColours.surface.withAlpha(190),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColours.primaryAccent.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            color: AppColours.neonCoral,
            size: 25,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Streak',
                style: TextStyle(
                  color: AppColours.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Consistency compounds.',
                style: TextStyle(
                  color: AppColours.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        if (isPersonalBest)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColours.warningAmber.withAlpha(22),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 14,
                  color: AppColours.warningAmber,
                ),
                SizedBox(width: 4),
                Text(
                  'BEST',
                  style: TextStyle(
                    color: AppColours.warningAmber,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
