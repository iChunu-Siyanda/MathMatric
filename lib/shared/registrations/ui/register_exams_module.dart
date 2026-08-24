import 'package:get_it/get_it.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/download_exam_paper_use_case.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/get_exam_paper_pages_use_case.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/get_exam_paper_use_case.dart';
import 'package:math_matric/features/ui/exam/domain/usercases/open_exam_paper_use_case.dart';
import 'package:math_matric/features/ui/exam/presentation/bloc/exam_bloc.dart';

final getIt = GetIt.instance;

void registerExamsModule () {
  getIt.registerLazySingleton(
    () => GetExamPapersUseCase(getIt(),),
  );

  getIt.registerLazySingleton(
    () => GetExamPaperUseCase(getIt(),),
  );

  getIt.registerLazySingleton(
    () => GetExamPaperPagesUseCase(getIt(),),
  );

  getIt.registerLazySingleton(
    () => OpenExamPaperUseCase(
      storageRepository: getIt(), 
      getExamPaperPages: getIt()),
  );

  getIt.registerLazySingleton(
    () => DownloadExamPaperUseCase(getIt(),),
  );

  getIt.registerFactory(
    () => ExamBloc(
      getExamPapers: getIt<GetExamPapersUseCase>(), 
      getExamPaper: getIt<GetExamPaperUseCase>(), 
      openExamPaper: getIt<OpenExamPaperUseCase>(), 
      downloadExamPaper: getIt<DownloadExamPaperUseCase>(),
    ),
  );
}
