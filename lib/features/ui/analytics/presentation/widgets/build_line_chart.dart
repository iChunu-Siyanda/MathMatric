import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/daily_chart_data.dart';

class BuildLineChart extends StatelessWidget {
  final List<DailyChartData> data;

  const BuildLineChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final spots = [
      for (int i = 0; i < data.length; i++)
        FlSpot(
          i.toDouble(),
          data[i].accuracy,
        ),
    ];

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => AppColours.textPrimary,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}% Accuracy',
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
            spots: spots,
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
                    .map(
                      (c) => c.withValues(alpha: 0.18),
                    )
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
