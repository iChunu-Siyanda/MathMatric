import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/remote/exam_paper_remote_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/datasource/storage/remote/exam_paper_remote_storage_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/repositories/remote/exam_paper_remote_data_source.dart';
import 'package:math_matric/features/curriculum/exams/data/repositories/storage/exam_paper_storage_storage_data_source_impl.dart';
import 'package:math_matric/features/curriculum/levels/data/datasource/remote/levels_remote_data_source.dart';
import 'package:math_matric/features/curriculum/levels/data/repositories/levels_remote_data_source_impl.dart';
import 'package:math_matric/features/curriculum/questions/data/datasource/remote/questions_remote_datasource.dart';
import 'package:math_matric/features/curriculum/questions/data/repositories/questions_remote_data_source_impl.dart';
import 'package:math_matric/features/curriculum/subjects/data/datasource/remote/subjects_remote_datasource.dart';
import 'package:math_matric/features/curriculum/subjects/data/repositories/subjects_remote_datasource_repository.dart';
import 'package:math_matric/features/curriculum/topics/data/datasource/remote/topic_remote_datasource.dart';
import 'package:math_matric/features/curriculum/topics/data/repositories/topic_remote_datasource_impl.dart';
import 'package:math_matric/features/marketplace/booking/data/datasource/booking_remote_datasource.dart';
import 'package:math_matric/features/marketplace/booking/data/datasource/tutor_availability_remaote_data_source.dart';
import 'package:math_matric/features/marketplace/booking/data/repositories/availability/tutor_availability_remaote_data_source_impl.dart';
import 'package:math_matric/features/marketplace/booking/data/repositories/booking/booking_remote_datasource_impl.dart';
import 'package:math_matric/features/marketplace/payments/data/datasources/payment_remote_datasource.dart';
import 'package:math_matric/features/marketplace/payments/data/repositories/payment_remote_datasource_impl.dart';
import 'package:math_matric/features/marketplace/tutors/data/datasources/remote/tutor_remote_data_source.dart';
import 'package:math_matric/features/marketplace/tutors/data/repositories/tutor_remote_data_source_impl.dart';
import 'package:math_matric/features/progress/questionattempts/data/datasource/remote/question_attempt_remote_data_source.dart';
import 'package:math_matric/features/progress/questionattempts/data/repositories/question_attempt_remote_data_source_impl.dart';
import 'package:math_matric/features/progress/studysession/data/datasource/remote/study_session_remote_data_source.dart';
import 'package:math_matric/features/progress/studysession/data/repositories/study_session_remote_data_source_impl.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/datasource/remote/user_level_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/userlevelprogress/data/repositories/user_level_progress_remote_data_source_impl.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/datasource/remote/user_topic_progress_remote_data_source.dart';
import 'package:math_matric/features/progress/usertopicprogress/data/repositories/user_topic_progress_remote_data_source_impl.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/datasource/remote/bundle_remote_data_source.dart';
import 'package:math_matric/features/sync/curriculum-bundle-manager/data/repositories/bundel_remote_data_source_impl.dart';

final getIt = GetIt.instance;

void registerRemoteDataSourceModule() {
  getIt.registerLazySingleton<BundleRemoteDataSource>(
    () => BundleRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(), 
      subjectRemote: getIt<SubjectsRemoteDataSource>(), 
      topicRemote: getIt<TopicRemoteDataSource>(), 
      levelRemote: getIt<LevelsRemoteDataSource>(), 
      questionRemote: getIt<QuestionsRemoteDataSource>(), 
      examPaperRemote: getIt<ExamPaperRemoteDataSource>(),
    ),
  );

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

  getIt.registerLazySingleton<ExamPaperRemoteStorageDataSource>(
    () => ExamPaperRemoteStorageDataSourceImpl(
      getIt<FirebaseStorage>(),
    ),
  );

  getIt.registerLazySingleton<LevelsRemoteDataSource>(
    () => LevelsRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<QuestionsRemoteDataSource>(
    () => QuestionsRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<ExamPaperRemoteDataSource>(
    () => ExamPaperRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<QuestionAttemptRemoteDataSource>(
    () => QuestionAttemptRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<StudySessionRemoteDataSource>(
    () => StudySessionRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<UserLevelProgressRemoteDataSource>(
    () => UserLevelProgressRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<UserTopicProgressRemoteDataSource>(
    () => UserTopicProgressRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<TutorRemoteDataSource>(
    () => TutorRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>(),),
  );

  getIt.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(), 
      functions: getIt<FirebaseFunctions>(),
    ),
  );

  getIt.registerLazySingleton<TutorAvailabilityRemoteDataSource>(
    () => TutorAvailabilityRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>(),),
  );

  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(
      functions: getIt<FirebaseFunctions>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
}
