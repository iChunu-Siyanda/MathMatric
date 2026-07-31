import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';

class BuildLineChart extends StatelessWidget {
  const BuildLineChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => AppColours.textPrimary,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toInt()}% Accuracy',
                  const TextStyle(
                    color: AppColours.surface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 65),
              FlSpot(1, 72),
              FlSpot(2, 68),
              FlSpot(3, 85),
              FlSpot(4, 78),
              FlSpot(5, 92),
              FlSpot(6, 88),
            ],
            isCurved: true,
            curveSmoothness: 0.35,
            gradient: AppColours.mathMatricGradient,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: AppColours.mathMatricGradientColors
                    .map((c) => c.withValues(alpha: 0.18))
                    .toList(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
