import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_state.dart';
import 'package:math_matric/features/streak/presentation/widgets/steak_footer_sliver.dart';
import 'package:math_matric/features/streak/presentation/widgets/streak_insight_sliver.dart';
import 'package:math_matric/features/streak/presentation/widgets/streak_pattern_sliver.dart';
import 'package:math_matric/features/streak/presentation/widgets/streak_timeline_sliver.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HabitBloc, HabitState>(
          builder: (context, state) {
            final entries = state.entries;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 100,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  centerTitle: true,
                  title: Text("Your Streak"),
                ),

                // Calendar timeline
                StreakTimelineSliver(entries: entries),

                // Pattern analysis (we will make this data-driven next)
                const StreakPatternSliver(),

                // Insight card
                const StreakInsightSliver(),

                //Footer
                const StreakFooterSliver(),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
