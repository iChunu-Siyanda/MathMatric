import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/presentation/widget/supporting/streak_card.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/features/streak/presentation/pages/streak_screen.dart';

class StreakSliver extends StatelessWidget {
  const StreakSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final habitState = context.watch<HabitBloc>().state;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Header(title: "Your Streak"),
            StreakCard(
              current: habitState.currentStreak,
              best: habitState.longestStreak,
              onTapStreak: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StreakScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
