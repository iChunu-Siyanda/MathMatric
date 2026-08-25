import 'package:get_it/get_it.dart';
import 'package:math_matric/features/curriculum/exams/data/repositories/local/exam_paper_local_repo_impl.dart';
import 'package:math_matric/features/curriculum/exams/data/repositories/repos/exam_paper_repository_impl.dart';
import 'package:math_matric/features/curriculum/exams/domain/repositories/exam_paper_repository.dart';
import 'package:math_matric/features/curriculum/levels/data/repositories/levels_local_datasoure.dart';
import 'package:math_matric/features/curriculum/levels/data/repositories/levels_repository_imple.dart';
import 'package:math_matric/features/curriculum/levels/domain/repositories/levels_repository.dart';
import 'package:math_matric/features/curriculum/notes/data/datasource/class_note_local_data_source.dart';
import 'package:math_matric/features/curriculum/notes/data/repositories/class_note_repository_impl.dart';
import 'package:math_matric/features/curriculum/notes/domain/repositories/class_note_repository.dart';
import 'package:math_matric/features/curriculum/questions/data/repositories/questions_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/questions/data/repositories/questions_repository_impl.dart';
import 'package:math_matric/features/curriculum/questions/domain/repositories/questions_repository.dart';
import 'package:math_matric/features/curriculum/subjects/data/repositories/subjects_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/subjects/data/repositories/subjects_repository_impl.dart';
import 'package:math_matric/features/curriculum/subjects/domain/repositories/subjects_repository.dart';
import 'package:math_matric/features/curriculum/topics/data/repositories/topic_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/topics/data/repositories/topic_repository_impl.dart';
import 'package:math_matric/features/curriculum/topics/domain/repositories/topic_repository.dart';
import 'package:math_matric/features/progress/questionattempts/data/datasource/local/questions_attempt_local_data_source.dart';
import 'package:math_matric/features/progress/questionattempts/data/datasource/remote/question_attempt_remote_data_source.dart';
import 'package:math_matric/features/progress/questionattempts/data/repositories/questions_attempts_repository.dart';
import 'package:math_matric/features/progress/questionattempts/domain/repositories/question_atempts_repository.dart';
import 'package:math_matric/features/progress/services/user_progress_calculator.dart';
import 'package:math_matric/features/progress/services/xp_calculator.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/local/study_session_local_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/remote/study_session_remote_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/repositories/study_session_repository_impl.dart';
import 'package:math_matric/features/progress/studysession/domain/repositories/study_session_repository.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/local/user_level_progress_local_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/remote/user_level_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/repositories/user_level_progress_repository_impl.dart';
import 'package:math_matric/features/progress/userlevelprogress/domain/repositories/user_level_progress_repository.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/datasource/local/user_topic_progress_local_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/datasource/remote/user_topic_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/repositories/user_topic_progress_repository_impl.dart';
import 'package:math_matric/features/progress/usertopicprogress/domain/repositories/user_topic_progress_repository.dart';
import 'package:math_matric/features/ui/analytics/data/datasource/analytics_local_data_source.dart';
import 'package:math_matric/features/ui/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:math_matric/features/ui/analytics/domain/repositories/analytics_repository.dart';
import 'package:math_matric/features/ui/streak/domain/repositories/habit_repository.dart';
import 'package:math_matric/shared/services/app_clock.dart';
import 'package:math_matric/shared/services/id_generator.dart';

final getIt = GetIt.instance;

void registerRepositoryModule() {

  getIt.registerLazySingleton<SubjectsRepository>(
    () => SubjectsRepositoryImpl(
      getIt<SubjectsLocalDatasourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<TopicRepository>(
    () => TopicRepositoryImpl(
      getIt<TopicLocalDataSourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<QuestionsRepository>(
    () => QuestionsRepositoryImpl(
      getIt<QuestionsLocalDatasourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<LevelsRepository>(
    () => LevelsRepositoryImpl(
      getIt<LevelsLocalDatasourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<ExamPapersRepository>(
    () => ExamPapersRepositoryImpl(
      getIt<ExamPaperLocalDataSourceImpl>(),
    ),
  );

  getIt.registerLazySingleton<QuestionAttemptRepository>(
    () => QuestionAttemptRepositoryImpl(
      getIt<QuestionAttemptLocalDataSource>(),
      getIt<QuestionAttemptRemoteDataSource>(),
    )
  );

  getIt.registerLazySingleton<StudySessionRepository>(
    () => StudySessionRepositoryImpl(
      getIt<StudySessionLocalDataSource>(),
      getIt<StudySessionRemoteDataSource>(),
      getIt<AppClock>(),
      getIt<IdGenerator>(),
    ),
  );

  getIt.registerLazySingleton<UserLevelProgressRepository>(
    () => UserLevelProgressRepositoryImpl(
      getIt<UserLevelProgressLocalDataSource>(),
      getIt<UserLevelProgressRemoteDataSource>(),
      getIt<UserProgressCalculator>(),
      getIt<XPCalculator>(),
    ),
  );

  getIt.registerLazySingleton<UserTopicProgressRepository>(
    () => UserTopicProgressRepositoryImpl(
      getIt<UserTopicProgressLocalDataSource>(),
      getIt<UserTopicProgressRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<ClassNoteRepository>(
    () => ClassNoteRepositoryImpl(getIt<ClassNoteLocalDataSource>()),
  );

  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(getIt<AnalyticsLocalDataSource>())
  );

  getIt.registerLazySingleton(
    () => HabitRepository(getIt(),getIt<AppClock>()),
  );
}
