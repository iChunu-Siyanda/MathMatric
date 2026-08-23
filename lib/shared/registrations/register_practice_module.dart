import 'package:get_it/get_it.dart';
import 'package:math_matric/features/papers/practice/data/repositories/practice_repository_impl.dart';
import 'package:math_matric/features/papers/practice/domain/repositories/practice_respository.dart';
import 'package:math_matric/features/papers/practice/domain/usecases/load_practice_topic.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/progress/services/level_unlock_calculator.dart';

final getIt = GetIt.instance;

void registerPracticeModule () {
  getIt.registerLazySingleton<PracticeRepository>(
    () => PracticeRepositoryImpl(topicLocal: getIt(), levelLocal: getIt()),
  );

  getIt.registerLazySingleton<LevelUnlockCalculator>(
    () => LevelUnlockCalculator(),
  );

  //usecases
  getIt.registerLazySingleton(
    () => LoadPracticeTopicUseCase(
      practiceRepository: getIt(), 
      levelProgressRepository: getIt(), 
      unlockCalculator: getIt(), 
    ),
  );

  getIt.registerFactory(
    () => PracticeBloc(
      loadPractice: getIt(), 
    ),
  );
}
