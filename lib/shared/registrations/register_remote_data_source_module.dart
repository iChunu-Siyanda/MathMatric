import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/remote/subjects_remote_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/repositories/subjects_remote_datasource_repository.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/remote/topic_remote_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/repositories/topic_remote_datasource_impl.dart';

final getIt = GetIt.instance;

void regiserRemoteDatasourceModule() {
  getIt.registerLazySingleton<SubjectsRemoteDataSource>(
    () => SubjectsRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<TopicRemoteDataSource>(
    () => TopicRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  // getIt.registerLazySingleton<LevelsRemoteDataSource>(
  //   () => LevelsRemoteDatasourceImpl(
  //     getIt<FirebaseFirestore>(),
  //   ),
  // );

  // getIt.registerLazySingleton<QuestionsRemoteDataSource>(
  //   () => QuestionsRemoteDataSourceImpl(
  //     getIt<FirebaseFirestore>(),
  //   ),
  // );

  // getIt.registerLazySingleton<ExamPaperRemoteDataSource>(
  //   () => ExamPaperRemoteDataSourceImpl(
  //     getIt<FirebaseFirestore>(),
  //   ),
  // );

  // getIt.registerLazySingleton<QuestionAttemptRemoteDataSource>(
  //   () => QuestionAttemptRemoteDataSourceImpl(
  //     getIt<FirebaseFirestore>(),
  //   ),
  // );

  // getIt.registerLazySingleton<StudySessionRemoteDataSource>(
  //   () => StudySessionRemoteDataSourceImpl(
  //     getIt<FirebaseFirestore>(),
  //   ),
  // );

  // getIt.registerLazySingleton<UserLevelProgressRemoteDataSource>(
  //   () => UserLevelProgressRemotelDataSourceImpl(
  //     getIt<FirebaseFirestore>(),
  //   ),
  // );

  // getIt.registerLazySingleton<UserTopicProgressRemoteDataSource>(
  //   () => UserTopicProgressRemoteDataSourceImpl(
  //     getIt<FirebaseFirestore>(),
  //   ),
  // );
}
