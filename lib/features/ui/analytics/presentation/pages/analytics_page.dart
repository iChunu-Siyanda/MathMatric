import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/ui/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_event.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_state.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/chart_card.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/kpi_grid.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/streak_header_card.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/time_picker_frame.dart';
import 'package:math_matric/features/ui/analytics/presentation/widgets/topic_progress_list.dart';
import 'package:math_matric/features/ui/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/features/ui/streak/presentation/bloc/habit_state.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final int _selectedTimeframe = 0; // 0: 7 Days, 1: 30 Days, 2: All Time
  bool _showLineGraph = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        backgroundColor: AppColours.background,
        elevation: 0,
        //scaffoldWillScaffold: false,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: AppColours.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.menu,
            color: AppColours.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColours.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocBuilder<AnalyticsBloc,AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AnalyticsError) {
              return Center(child: Text(state.message),);
            }

            if (state is AnalyticsLoaded) {
              final metrics = state.metrics;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<HabitBloc, HabitState>(
                    builder: (context, habitState) {
                      return switch (habitState) {
                        HabitLoaded() => StreakHeaderCard(
                            currentStreak: habitState.currentStreak,
                            longestStreak: habitState.longestStreak,
                            weeklyScore: habitState.weeklyProgressScore,
                          ),
                        _ => const StreakHeaderCard(
                            currentStreak: 0,
                            longestStreak: 0,
                            weeklyScore: 0,
                          ),
                      };
                    },
                  ),

                  const SizedBox(height: 16),

                  TimeframePicker(
                    selectedIndex: _selectedTimeframe,
                    onChanged: (index) {
                      context.read<AnalyticsBloc>().add(
                        AnalyticsTimeframeChanged(
                          AnalyticsTimeframe.values[index],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  ChartCard(
                    sessions: metrics.sessions,
                    timeframe: state.selectedTimeframe,
                    isLineGraph: _showLineGraph,
                    onToggleGraph: () {
                      setState(() {
                        _showLineGraph = !_showLineGraph;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  KpiGrid(
                    totalEarnedXP: metrics.totalEarnedXP.toString(),
                    overallAccuracy: metrics.overallAccuracy.toStringAsFixed(1),
                    overallCompletionRate: metrics.overallCompletionRate.toStringAsFixed(1),
                    avgTime: metrics.avgTimePerQuestionSeconds.toStringAsFixed(1),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Topics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColours.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TopicProgressList(
                    topicCards: state.metrics.topicProgressCards,
                  ),

                  const SizedBox(height: 24),
                ],
              );
            }

            return SizedBox.shrink();
        },),
      ),
    );
  }
}
