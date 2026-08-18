import 'package:get_it/get_it.dart';
import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/local/exam_paper_local_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/repositories/local/exam_paper_local_repo_impl.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/local/levels_local_datasource.dart';
import 'package:math_matric/features/curriculum/levels/data/repositories/levels_local_datasoure.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/local/questions_local_datasource.dart';
import 'package:math_matric/features/curriculum/questions/data/repositories/questions_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/local/subjects_local_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/repositories/subjects_local_datasource_impl.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/local/topic_local_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/repositories/topic_local_datasource_impl.dart';
import 'package:math_matric/features/progress/questionattempts/data/datasource/local/questions_attempt_local_data_source.dart';
import 'package:math_matric/features/progress/questionattempts/data/repositories/questions_attempts_local_data_source_impl.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/local/study_session_local_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/repositories/study_session_local_data_source_impl.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/local/user_level_progress_local_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/repositories/user_level_progress_local_data_source_impl.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/datasource/local/user_topic_progress_local_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/repositories/user_topic_progress_local_data_source_impl.dart';

final getIt = GetIt.instance;

void registerLocalDataSourceModule() {
  getIt.registerLazySingleton<SubjectsLocalDataSource>(
    () => SubjectsLocalDatasourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<TopicLocalDataSource>(
    () => TopicLocalDataSourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<LevelsLocalDatasource>(
    () => LevelsLocalDatasourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<QuestionsLocalDatasource>(
    () => QuestionsLocalDatasourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<ExamPaperLocalDataSource>(
    () => ExamPaperLocalDataSourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<QuestionAttemptLocalDataSource>(
    () => QuestionAttemptLocalDataSourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<StudySessionLocalDataSource>(
    () => StudySessionLocalDataSourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<UserLevelProgressLocalDataSource>(
    () => UserLevelProgressLocalDataSourceImpl(
      getIt<AppDatabase>(),
    ),
  );

  getIt.registerLazySingleton<UserTopicProgressLocalDataSource>(
    () => UserTopicProgressLocalDataSourceImpl(
      getIt<AppDatabase>(),
    ),
  );
}
