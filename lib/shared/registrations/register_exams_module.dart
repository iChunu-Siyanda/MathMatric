import 'package:get_it/get_it.dart';
import 'package:math_matric/features/papers/exam/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/exam/data/repositories/exam_repository_impl.dart';
import 'package:math_matric/features/papers/exam/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_bloc.dart';

final getIt = GetIt.instance;

void registerExamsModule () {
  //final localExamDataSource = ExamPaperData();
  getIt.registerLazySingleton(
    () => ExamPaperData(),
  );

  //final repository = ExamPaperRepositoryImpl(localExamDataSource);
  getIt.registerLazySingleton(
    () => ExamPaperRepositoryImpl(getIt(),),
  );

  //final getExamPaperData = GetExamPaperData(repository);
  getIt.registerLazySingleton(
    () => GetExamPaperData(getIt(),),
  );

  getIt.registerFactory(
    () => ExamBloc(getIt(),),
  );
}
