import 'package:flutter/material.dart';
import 'package:math_matric/features/streak/domain/entities/habit_entry_model.dart';
import 'package:math_matric/features/streak/presentation/widgets/section_header.dart';
import 'package:math_matric/features/streak/presentation/widgets/calender_grid.dart';
import 'package:math_matric/features/streak/presentation/widgets/weekday_header.dart';


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
