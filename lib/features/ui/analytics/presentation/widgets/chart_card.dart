import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/progress/studysession/domain/entities/study_session_entity.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/daily_chart_data.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/build_line_chart.dart';

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
    final chartData = _buildDailyData();

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
        border: Border.all(
          color: AppColours.border,
        ),
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
          _buildHeader(
            totalMinutes: totalMinutes,
            averageAccuracy: averageAccuracy,
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 160,
            child: isLineGraph
                ? BuildLineChart(
                    data: chartData,
                  )
                : _buildBarChart(chartData),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required int totalMinutes,
    required double averageAccuracy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isLineGraph
                  ? 'Recall Accuracy'
                  : 'Study Volume',
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
                  isLineGraph
                      ? 'Bar View'
                      : 'Line View',
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

  // ============================================================
  // DAILY CHART DATA
  // ============================================================

  List<DailyChartData> _buildDailyData() {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final numberOfDays = switch (timeframe) {
      AnalyticsTimeframe.days7 => 7,
      AnalyticsTimeframe.days30 => 30,
      AnalyticsTimeframe.allTime => _calculateAllTimeDays(today),
    };

    // Always produce exactly the last 7 days.
    // This means days with no study still appear as zero.
    final result = List.generate(
      numberOfDays,
      (index) {
        final date = today.subtract(
          Duration(days: numberOfDays - 1 - index),
        );

        return DailyChartData(
          date: date,
          minutes: 0,
          correctAnswers: 0,
          totalQuestions: 0,
        );
      },
    );

    for (final session in sessions) {
      // Ignore incomplete/active sessions.
      if (session.endedAt == null) {
        continue;
      }

      final sessionDate = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );

      final index = result.indexWhere(
        (data) => data.date == sessionDate,
      );

      if (index == -1) {
        continue;
      }

      final current = result[index];

      final duration = session.endedAt!
          .difference(session.startedAt)
          .inMinutes;

      result[index] = DailyChartData(
        date: current.date,
        minutes: current.minutes + duration,
        correctAnswers:
            current.correctAnswers +
            session.correctAnswers,
        totalQuestions:
            current.totalQuestions +
            session.questionsAnswered,
      );
    }

    return result;
  }

  // ============================================================
  // Calculate AllTime Days
  // ============================================================
  int _calculateAllTimeDays(DateTime today) {
    if (sessions.isEmpty) return 7;

    final oldestSession = sessions
        .map((session) => session.startedAt)
        .reduce((a,b) => a.isBefore(b) ? a : b);
    
    final oldestDate = DateTime(
      oldestSession.year,
      oldestSession.month,
      oldestSession.day,
    );

    return today.difference(oldestDate).inDays + 1;
  }

  // ============================================================
  // BAR CHART
  // ============================================================

  Widget _buildBarChart(
    List<DailyChartData> data,
  ) {
    final maxMinutes = data.fold<double>(
      0.0,
      (max, item) {
        return item.minutes > max
            ? item.minutes.toDouble()
            : max;
      },
    );

    final maxY = maxMinutes <= 0
        ? 60.0
        : maxMinutes * 1.2;

    return BarChart(
      BarChartData(
        maxY: maxY,
        gridData: const FlGridData(
          show: false,
        ),
        titlesData: const FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
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

  BarChartGroupData _makeBarGroup(
    int x,
    double y,
    double maxY,
  ) {
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
