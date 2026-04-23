import 'package:math_matric/features/streak/domain/entities/habit_entry.dart';

abstract class HabitEvent {
  const HabitEvent();
}

//Handles existing day and new check-in:
class HabitEntryLogged extends HabitEvent {
  final HabitEntry entry;

  const HabitEntryLogged(this.entry);
}

class HabitEntriesLoaded extends HabitEvent {
  final List<HabitEntry> entries;

  const HabitEntriesLoaded(this.entries);
}
