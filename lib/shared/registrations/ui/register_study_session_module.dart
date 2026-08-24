import 'package:get_it/get_it.dart';
import 'package:math_matric/features/progress/studysession/bloc/study_session_bloc.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/complete_study_session_use_case.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/get_active_study_session_use_case.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/start_study_session_use_case.dart';
import 'package:math_matric/features/progress/studysession/domain/usecases/update_study_session_use_case.dart';

final getIt = GetIt.instance;

void registerStudySessionModule() {
  getIt.registerLazySingleton(
    () => StartStudySessionUseCase(getIt<StudySessionRepository>(),)
  );

  getIt.registerLazySingleton(
    () => GetActiveStudySessionUseCase(getIt<StudySessionRepository>(),),
  );

  getIt.registerLazySingleton(
    () => UpdateStudySessionProgressUseCase(getIt<StudySessionRepository>(),),
  );

  getIt.registerLazySingleton(
    () => CompleteStudySessionUseCase(getIt<StudySessionRepository>(),),
  );

  getIt.registerFactory(
    () => StudySessionBloc(
      startSession: getIt(), 
      getActiveSession: getIt(), 
      updateProgress: getIt(), 
      completeSession: getIt(),
    ),
  );
}
