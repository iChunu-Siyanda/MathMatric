import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class QuizAlertCard extends StatelessWidget {
  const QuizAlertCard({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColours.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColours.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColours.ambientGlow,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColours.cobaltBlue,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz activity',
                  style: TextStyle(
                    color: AppColours.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Calculus · Chapter 3',
                  style: TextStyle(
                    color: AppColours.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColours.textMuted,
          ),
        ],
      ),
    );
  }
}
