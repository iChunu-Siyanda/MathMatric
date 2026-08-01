import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/core/theme/app_colours.dart';
import 'package:math_matric/features/analytics/domain/entites/analytics_time_frame.dart';
import 'package:math_matric/features/analytics/domain/services/analytics_loaded_topic_cards.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:math_matric/features/analytics/domain/services/analytics_state_extension.dart';
import 'package:math_matric/features/analytics/presentation/widgets/chart_card.dart';
import 'package:math_matric/features/analytics/presentation/widgets/kpi_grid.dart';
import 'package:math_matric/features/analytics/presentation/widgets/streak_header_card.dart';
import 'package:math_matric/features/analytics/presentation/widgets/time_picker_frame.dart';
import 'package:math_matric/features/analytics/presentation/widgets/topic_progress_list.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_state.dart';

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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<HabitBloc, HabitState>(
                    builder: (context, habitState) {
                      return StreakHeaderCard(
                        currentStreak: habitState.currentStreak,
                        longestStreak: habitState.longestStreak,
                        weeklyScore: habitState.weeklyProgressScore,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  TimeframePicker(
                    selectedIndex: _selectedTimeframe, 
                    onChanged: (index){
                      context.read<AnalyticsBloc>().add(
                        ChangeAnalyticsTimeframe(AnalyticsTimeframe.values[index])
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  ChartCard(
                    sessions: state.sessions, 
                    isLineGraph: _showLineGraph, 
                    onToggleGraph: (){setState(() {
                      _showLineGraph = !_showLineGraph;
                    });},
                  ),
                  const SizedBox(height: 16,),

                  KpiGrid(
                    totalEarnedXP: state.totalEarnedXP.toString(), 
                    overallAccuracy: state.overallAccuracy.toStringAsFixed(1), 
                    overallCompletionRate: state.overallCompletionRate.toStringAsFixed(1), 
                    avgTime: state.avgTimePerQuestionSeconds.toStringAsFixed(1),
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
                  const SizedBox(height: 12,),

                  TopicProgressList(topicCards: state.topicProgressCards,),
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
