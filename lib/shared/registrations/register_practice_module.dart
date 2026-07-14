import 'package:get_it/get_it.dart';
import 'package:math_matric/features/papers/exam/domain/repositories/user_progress_repository.dart';
import 'package:math_matric/features/papers/practice/data/repositories/local_practice_repository.dart';
import 'package:math_matric/features/papers/practice/domain/repositories/practice_respository.dart';
import 'package:math_matric/features/papers/practice/domain/usecases/complete_level_usecase.dart';
import 'package:math_matric/features/papers/practice/domain/usecases/load_practice_topic.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/papers/userProgress/data/repositories/local_user_progress_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void registerPracticeModule (SharedPreferences prefs) {
  getIt.registerLazySingleton<UserProgressRepository>(
    () => LocalUserProgressRepository(prefs),
  );

  getIt.registerLazySingleton<PracticeRepository>(
    () => LocalPracticeRepository(),
  );
  //usecases
  getIt.registerLazySingleton(
    () => LoadPracticeTopicUseCase(
      practiceRepository: getIt(), 
      progressRepository: getIt(),
    ),
  );

  getIt.registerLazySingleton(
    () => CompleteLevelUseCase(
      progressRepository: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PracticeBloc(
      loadPractice: getIt(), 
      completeLevel: getIt(),
    ),
  );
}
