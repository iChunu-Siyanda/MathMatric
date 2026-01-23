import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/presentation/widget/supporting/streak_card.dart';
import 'package:math_matric/routes/papers/resources/models/streak_variant_modal.dart';
import 'package:math_matric/routes/papers/resources/my_progress/streak/screen/streak_screen.dart';

class StreakSliver extends StatelessWidget {
  final StreakContent content;

  const StreakSliver({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Header(title: content.topicTitle),
            StreakCard(
              current: content.currentStreak,
              best: content.bestStreak,
              onTapStreak: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StreakScreen(), //Receives content
                  ),
                );
              },
              onTapScore: () {
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
