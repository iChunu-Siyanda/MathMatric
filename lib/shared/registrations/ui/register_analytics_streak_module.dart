import 'package:get_it/get_it.dart';
import 'package:math_matric/features/ui/analytics/domain/calculator/analytics_calculator.dart';
import 'package:math_matric/features/ui/analytics/domain/repositories/analytics_repository.dart';
import 'package:math_matric/features/ui/analytics/domain/usecases/get_analytics_use_case.dart';
import 'package:math_matric/features/ui/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:math_matric/features/ui/streak/presentation/bloc/habit_bloc.dart';

final getIt = GetIt.instance;

void registerAnalyticsStreakModule() {
  getIt.registerLazySingleton(
    () => AnalyticsCalculator(),
  );

  getIt.registerLazySingleton(
    () => GetAnalyticsUseCase(
      repository: getIt<AnalyticsRepository>(), 
      calculator: getIt<AnalyticsCalculator>(),
    ),
  );

  getIt.registerFactory(
    () => AnalyticsBloc(
      getAnalytics: getIt(),
    ),
  );

  getIt.registerFactory(
    () => HabitBloc(getIt(),),
  );
}
