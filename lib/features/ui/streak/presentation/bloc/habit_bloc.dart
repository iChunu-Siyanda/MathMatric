import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:math_matric/features/ui/streak/domain/repositories/habit_repository.dart';
import 'package:math_matric/features/ui/streak/presentation/bloc/habit_event.dart';
import 'package:math_matric/features/ui/streak/presentation/bloc/habit_state.dart';
import 'package:math_matric/features/ui/streak/domain/entities/habit_summary.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _repository;
  
  HabitBloc(
    this._repository,
  ) : super(const HabitInitial()) {
    on<HabitStarted>(_onStarted);
    on<HabitSummaryUpdated>(_onSummaryUpdated);
  }

  StreamSubscription<HabitSummary>? _subscription;

  Future<void> _onStarted(
    HabitStarted event,
    Emitter<HabitState> emit,
  ) async {
    emit(const HabitLoading());

    await _subscription?.cancel();

    _subscription = _repository.watchSummary().listen(
      (summary) {
        add(HabitSummaryUpdated(summary),);
      },
    );
  }

  void _onSummaryUpdated(
    HabitSummaryUpdated event,
    Emitter<HabitState> emit,
  ) {
    emit(HabitLoaded(event.summary));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
