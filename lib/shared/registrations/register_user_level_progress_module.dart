import 'package:get_it/get_it.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/usecases/process_level_attempt_use_case.dart';

final getIt = GetIt.instance;

void registerUserLevelProgressModule() {
  //Use Cases:
  getIt.registerLazySingleton<ProcessLevelAttemptUseCase>(
    () => ProcessLevelAttemptUseCase(
      levelProgressRepository: getIt(),
      questionAttemptRepository: getIt(),
      progressCalculator: getIt(),
      xpCalculator: getIt(),
    ),
  );
}
