import 'package:get_it/get_it.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/usecases/process_level_attempt_use_case.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/usecases/update_topic_progress_use_case.dart';

final getIt = GetIt.instance;

void registerUserProgressModule() {
  //Use Cases:
  getIt.registerLazySingleton<UpdateTopicProgressUseCase>(
    () => UpdateTopicProgressUseCase(
      topicProgressRepository: getIt(),
      levelProgressRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton<ProcessLevelAttemptUseCase>(
    () => ProcessLevelAttemptUseCase(
      levelProgressRepository: getIt(),
      questionAttemptRepository: getIt(),
      progressCalculator: getIt(),
      xpCalculator: getIt(),
      updateTopicProgress: getIt(),
    ),
  );
}
