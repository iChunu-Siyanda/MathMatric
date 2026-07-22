import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/streak_card.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/topic_streak_header.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/topic_streak_message.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/features/streak/presentation/pages/streak_screen.dart';

class StreakSliver extends StatelessWidget {
  const StreakSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final habitState = context.watch<HabitBloc>().state;

    final currentStreak = habitState.currentStreak;
    final longestStreak = habitState.longestStreak;

    final bool isPersonalBest =
        currentStreak > 0 && currentStreak >= longestStreak;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopicStreakHeader(
              currentStreak: currentStreak,
              isPersonalBest: isPersonalBest,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StreakScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            StreakCard(
              current: currentStreak,
              best: longestStreak,
              onTapStreak: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StreakScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 14),

            TopicStreakMessage(
              currentStreak: currentStreak,
            ),
          ],
        ),
      ),
    );
  }
}
