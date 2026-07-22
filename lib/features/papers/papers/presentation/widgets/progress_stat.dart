import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class ProgressStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const ProgressStat({
    super.key, 
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(22),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 19,
          ),
        ),

        const SizedBox(width: 9),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColours.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              style: const TextStyle(
                color: AppColours.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
