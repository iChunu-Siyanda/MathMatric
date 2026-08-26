import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:math_matric/core/network/repositories/connectivity_service.dart';
import 'package:math_matric/core/network/repositories/internet_checker.dart';
import 'package:math_matric/core/network/services/connectivity_service_impl.dart';
import 'package:math_matric/core/network/services/internet_checker_impl.dart';
import 'package:math_matric/core/network/services/sync_progress_manager.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';
import 'package:math_matric/features/progress/services/user_progress_calculator.dart';
import 'package:math_matric/features/progress/services/xp_calculator.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/repositories/curriculum_bundle_repository.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/services/content_sync_service.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/services/content_sync_service_impl.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/domain/usecases/download_and_install_bundle_use_case.dart';
import 'package:math_matric/features/sync/user-data-progress/services/sync_progress_coordinator.dart';
import 'package:math_matric/shared/services/app_clock.dart';
import 'package:math_matric/shared/services/id_generator.dart';
import 'package:uuid/uuid.dart';

final getIt = GetIt.instance;

void registerServiceModule() {
  getIt.registerLazySingleton<AppClock>(
    () => AppClockImpl(),
  );

  getIt.registerLazySingleton<IdGenerator>(
    () => UuidGenerator(
      Uuid(),
    ),
  );
  //Connectivity:
  getIt.registerLazySingleton<Connectivity>(
    () => Connectivity(),
  );
  
  //Curriculum Installation/Updates:
  getIt.registerFactory(
    () => DownloadAndInstallBundleUseCase(
      getIt<CurriculumBundleRepository>(),
    ),
  );

  //Curriculum Sync:
  getIt.registerLazySingleton<ContentSyncService>(
    () => ContentSyncServiceImpl(
      subjectLocal: getIt(),
      topicLocal: getIt(),
      levelLocal: getIt(),
      questionLocal: getIt(),
      examPaperLocal: getIt(),
      bundleLocal: getIt(), 

      subjectRemote: getIt(), 
      topicRemote: getIt(), 
      levelRemote: getIt(), 
      questionRemote: getIt(), 
      examPaperRemote: getIt(),
      bundleRemote: getIt(),
    ),
  );
  
  //User Progress Sync:
  getIt.registerLazySingleton<ConnectivityService>(
    () =>ConnectivityServiceImpl(getIt<Connectivity>()),
  );

  getIt.registerLazySingleton<InternetChecker>(
    () => InternetCheckerImpl(),
  );

  getIt.registerLazySingleton(
    () => SyncProgressCoordinator(
      auth: getIt<FirebaseAuth>(),
      questionAttempts: getIt<QuestionAttemptRepository>(), 
      topicProgress: getIt<UserTopicProgressRepository>(), 
      levelProgress: getIt<UserLevelProgressRepository>(), 
      studySessions: getIt<StudySessionRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => SyncProgressManager(
      connectivityService: getIt(), 
      internetChecker: getIt(), 
      syncCoordinator: getIt(),
    ),
  );

  // Calculators:
  getIt.registerLazySingleton<UserProgressCalculator>(
    () => UserProgressCalculator(),
  );

  getIt.registerLazySingleton<XPCalculator>(
    () => XPCalculator(),
  );
}
