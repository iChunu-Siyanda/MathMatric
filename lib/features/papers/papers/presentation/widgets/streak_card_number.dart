import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class StreakCardNumber extends StatelessWidget {
  final int current;
  final bool hasStreak;

  const StreakCardNumber({
    super.key, 
    required this.current,
    required this.hasStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return AppColours.mathMatricGradient.createShader(
              Rect.fromLTWH(
                0,
                0,
                bounds.width,
                bounds.height,
              ),
            );
          },
          child: Text(
            '$current',
            style: const TextStyle(
              fontSize: 72,
              height: 0.95,
              fontWeight: FontWeight.w900,
              letterSpacing: -3,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 8),

        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'days',
            style: TextStyle(
              color: AppColours.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
