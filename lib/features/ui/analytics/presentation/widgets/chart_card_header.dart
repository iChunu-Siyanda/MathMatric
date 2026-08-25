import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';

class ChartCardHeader extends StatelessWidget {
  final int totalMinutes;
  final double averageAccuracy;
  final bool isLineGraph;
  final VoidCallback onToggleGraph;

  const ChartCardHeader({
    super.key,
    required this.totalMinutes,
    required this.averageAccuracy,
    required this.isLineGraph,
    required this.onToggleGraph,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLineGraph ? 'Recall Accuracy' : 'Study Volume',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColours.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isLineGraph
                  ? '${averageAccuracy.toStringAsFixed(1)}%'
                  : '$totalMinutes mins',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColours.textPrimary,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onToggleGraph,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColours.surfaceSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  isLineGraph
                      ? Icons.bar_chart_rounded
                      : Icons.show_chart_rounded,
                  size: 16,
                  color: AppColours.cobaltBlue,
                ),
                const SizedBox(width: 4),
                Text(
                  isLineGraph ? 'Bar View' : 'Line View',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColours.cobaltBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
