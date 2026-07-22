import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class MiniCardStat extends StatelessWidget {
  final String label;
  final String value;

  const MiniCardStat({
    super.key, 
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColours.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          value,
          style: const TextStyle(
            color: AppColours.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
