import 'package:flutter/material.dart';

class StreakSliver extends StatelessWidget {
  const StreakSliver({super.key});

  @override
  Widget build(BuildContext context) {
    // final habitState = context.watch<HabitBloc>().state;

    // final currentStreak = habitState.;
    // final longestStreak = habitState.longestStreak;

    // final bool isPersonalBest = currentStreak > 0 && currentStreak >= longestStreak;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20,20,20,28,),
        child: const Center(child: Text('Wowww'),),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       TopicStreakHeader(
      //         currentStreak: currentStreak,
      //         isPersonalBest: isPersonalBest,
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (_) => const AnalyticsPage(),
      //             ),
      //           );
      //         },
      //       ),

      //       const SizedBox(height: 14),

      //       StreakCard(
      //         current: currentStreak,
      //         best: longestStreak,
      //         onTapStreak: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (_) => const AnalyticsPage(),
      //             ),
      //           );
      //         },
      //       ),

      //       const SizedBox(height: 14),

      //       TopicStreakMessage(
      //         currentStreak: currentStreak,
      //       ),
      //     ],
      //   ),
      ),
    );
  }
}
