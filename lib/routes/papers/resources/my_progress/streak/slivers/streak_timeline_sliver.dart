import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/my_progress/models/habit_entry_model.dart';
import 'package:math_matric/routes/papers/resources/my_progress/streak/components/section_header.dart';
import 'package:math_matric/routes/papers/resources/my_progress/streak/slivers/calender_grid.dart';
import 'package:math_matric/routes/papers/resources/my_progress/streak/slivers/weekday_header.dart';


class StreakTimelineSliver extends StatelessWidget {
  final List<HabitEntry> entries;

  const StreakTimelineSliver({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Recent Activity'),
            const SizedBox(height: 12),
            const WeekdayHeader(),
            const SizedBox(height: 8),
            CalendarTileGrid(entries: entries),
          ],
        ),
      ),
    );
  }
}
