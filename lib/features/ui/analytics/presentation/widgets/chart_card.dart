import 'package:flutter/material.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/build_bar_chart.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/build_line_chart.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/chart_card_header.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/daily_chart_data_builder.dart';

class ChartCard extends StatelessWidget {
  final List<StudySessionEntity> sessions;
  final AnalyticsTimeframe timeframe;
  final bool isLineGraph;
  final VoidCallback onToggleGraph;

  const ChartCard({
    super.key,
    required this.sessions,
    required this.timeframe,
    required this.isLineGraph,
    required this.onToggleGraph,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = DailyChartDataBuilder.build(
      sessions: sessions,
      timeframe: timeframe,
    );

    final totalMinutes = chartData.fold<int>(
      0,
      (sum, data) => sum + data.minutes,
    );

    final daysWithQuestions = chartData
        .where((data) => data.totalQuestions > 0)
        .toList();

    final averageAccuracy = daysWithQuestions.isEmpty
        ? 0.0
        : daysWithQuestions.fold<double>(
              0.0,
              (sum, data) => sum + data.accuracy,
            ) /
            daysWithQuestions.length;

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
          ),
        ],
      ),
      child: Column(
        children: [
          ChartCardHeader(
            totalMinutes: totalMinutes,
            averageAccuracy: averageAccuracy,
            isLineGraph: isLineGraph,
            onToggleGraph: onToggleGraph,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: isLineGraph
                ? BuildLineChart(data: chartData)
                : BuildBarChart(data: chartData),
          ),
        ],
      ),
    );
  }
}
