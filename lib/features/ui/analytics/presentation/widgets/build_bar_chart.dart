import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/daily_chart_data.dart';

class BuildBarChart extends StatelessWidget {
  final List<DailyChartData> data;

  const BuildBarChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final maxMinutes = data.fold<double>(
      0.0,
      (max, item) => item.minutes > max ? item.minutes.toDouble() : max,
    );

    final maxY = maxMinutes <= 0 ? 60.0 : maxMinutes * 1.2;

    return BarChart(
      BarChartData(
        maxY: maxY,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (int i = 0; i < data.length; i++)
            _makeBarGroup(
              i,
              data[i].minutes.toDouble(),
              maxY,
            ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: AppColours.mathMatricGradient,
          width: 14,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: AppColours.surfaceSecondary,
          ),
        ),
      ],
    );
  }
}
