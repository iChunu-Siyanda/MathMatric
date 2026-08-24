import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/build_line_chart.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';

class ChartCard extends StatelessWidget {
  final List<StudySessionEntity> sessions;
  final bool isLineGraph;
  final VoidCallback onToggleGraph;

  const ChartCard({
    super.key, 
    required this.sessions,
    required this.isLineGraph,
    required this.onToggleGraph,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColours.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColours.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // Header Row inside Graph Card
          Row(
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
                  Row(
                    children: [
                      Text(
                        isLineGraph ? '88.4%' : '42 mins',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColours.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColours.correctGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '+4.2%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColours.correctGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Graph Toggle Button
              InkWell(
                onTap: onToggleGraph,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          ),

          const SizedBox(height: 20),

          // Dynamic Graph Output
          SizedBox(
            height: 160,
            child: isLineGraph ? BuildLineChart() : _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeBarGroup(0, 20),
          _makeBarGroup(1, 35),
          _makeBarGroup(2, 15),
          _makeBarGroup(3, 40),
          _makeBarGroup(4, 50),
          _makeBarGroup(5, 30),
          _makeBarGroup(6, 42),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
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
            toY: 60,
            color: AppColours.surfaceSecondary,
          ),
        ),
      ],
    );
  }
}
