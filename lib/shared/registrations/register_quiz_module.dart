import 'package:get_it/get_it.dart';
import 'package:math_matric/features/ui/quiz/data/repositories/quiz_questions_repository_impl.dart';
import 'package:math_matric/features/ui/quiz/domain/repositories/quiz_questions_repository.dart';
import 'package:math_matric/features/ui/quiz/domain/usecases/load_quiz_questions_use_case.dart';
import 'package:math_matric/features/ui/quiz/presentation/bloc/quiz_bloc.dart';

final getIt = GetIt.instance;

void registerQuizModule() {
  getIt.registerLazySingleton<QuizQuestionsRepository>(
    () => QuizQuestionsRepositoryImpl(getIt(),),
  );

  getIt.registerLazySingleton(
    () => LoadQuizQuestionsUseCase(getIt(),),
  );

  getIt.registerFactory(
    () => QuizBloc(getIt(),),
  );
}
