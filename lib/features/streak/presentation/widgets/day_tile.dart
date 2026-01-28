import 'package:flutter/material.dart';
import 'package:math_matric/features/streak/presentation/widgets/streak_intensity.dart';

class DayTile extends StatelessWidget {
  final int studyMinutes;
  final bool isToday;

  const DayTile({
    super.key,
    required this.studyMinutes,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final color = tileColorForMinutes(context, studyMinutes);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isToday
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .5),
                  blurRadius: 6,
                )
              ]
            : null,
      ),
    );
  }
}
