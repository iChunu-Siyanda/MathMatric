import 'package:math_matric/routes/papers/resources/my_progress/models/habit_entry_model.dart';

abstract class HabitEvent {
  const HabitEvent();
}

//Handles existing day and new check-in:
class HabitEntryLogged extends HabitEvent {
  final HabitEntry entry;

  const HabitEntryLogged(this.entry);
}

//lets us inject initial data.
class HabitEntriesLoaded extends HabitEvent {
  final List<HabitEntry> entries;

  const HabitEntriesLoaded(this.entries);
}
