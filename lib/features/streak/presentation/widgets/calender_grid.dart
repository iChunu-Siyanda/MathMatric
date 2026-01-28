import 'package:flutter/material.dart';
import 'package:math_matric/features/streak/domain/usercase/habit_entry_helper.dart';
import 'package:math_matric/features/streak/domain/entities/habit_entry_model.dart';
import 'day_tile.dart';

class CalendarTileGrid extends StatelessWidget {
  final List<HabitEntry> entries;

  const CalendarTileGrid({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, HabitEntry> map = {
      for (final entry in entries) normalizeDate(entry.date): entry
    };

    final today = normalizeDate(DateTime.now());

    final days = List.generate(14, (i) {
      return today.subtract(Duration(days: 13 - i));
    });

    return Column(
      children: [
        for (int row = 0; row < 2; row++)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (col) {
                final day = days[row * 7 + col];
                final entry = map[day];

                return DayTile(
                  studyMinutes: entry?.studyMinutes ?? 0,
                  isToday: day == today,
                );
              }),
            ),
          ),
      ],
    );
  }
}
