import 'package:get_it/get_it.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:math_matric/features/ui/streak/presentation/bloc/habit_bloc.dart';

final getIt = GetIt.instance;

void registerAnalyticsStreakModule() {
  getIt.registerFactory(
    () => AnalyticsBloc(),
  );

  getIt.registerFactory(
    () => HabitBloc(getIt(),),
  );
}
