import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class PaperBadge extends StatelessWidget {
  final String title;

  const PaperBadge({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColours.surface.withAlpha(220),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColours.cobaltBlue,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
