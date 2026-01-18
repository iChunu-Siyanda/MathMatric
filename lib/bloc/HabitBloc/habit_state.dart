//“What does the UI need to know right now?”
import 'package:math_matric/routes/papers/resources/widgets/my_progress/models/habit_entry_model.dart';
import 'package:math_matric/routes/papers/resources/widgets/my_progress/models/habit_summary.dart';

class HabitState {
  final List<HabitEntry> entries;
  final HabitSummary summary;

  const HabitState({required this.entries, required this.summary});

  // factory: This keyword tells Dart that this constructor has special logic for creating the object. Unlike a standard constructor, a factory can return an existing instance or even a subclass.
  // HabitState.initial(): This is a named constructor. Instead of just calling HabitState(), you call HabitState.initial() to make it clear that you are requesting the default, starting state of the habit.
  factory HabitState.initial() {
    return HabitState(entries: const [], summary: HabitSummary.initial());
  }

  //copyWitn() creates a "modified clone" of your current HabitState, since it is immutable.
  HabitState copyWith({
    List<HabitEntry>? entries,
    HabitSummary ? summary,
    
  }) {
    return HabitState(
      entries: entries ?? this.entries,
      summary: summary ?? this.summary,
    );
  }
  
  //get keyword defines a getter. A getter is a special method that provides read-only access to a property
  //When you ask for the currentStreak, Dart dynamically looks up the value inside the summary object and returns it. Instead of storing new piece of data
  int get currentStreak => summary.currentStreak;
  int get longestStreak => summary.longestStreak;
  int get weeklyProgressScore => summary.weeklyProgressScore;
}
