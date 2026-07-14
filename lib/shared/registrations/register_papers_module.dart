import 'package:get_it/get_it.dart';
import 'package:math_matric/features/papers/papers/data/local/papers_item_local_data.dart';
import 'package:math_matric/features/papers/papers/data/repositories/papers_respository_impl.dart';
import 'package:math_matric/features/papers/papers/domain/usecases/get_paper_data.dart';
import 'package:math_matric/features/papers/papers/presentation/bloc/papers_bloc.dart';

final getIt = GetIt.instance;

void registerPapersModule () {
  getIt.registerLazySingleton(
    () => PaperTileLocalData(),
  );

  getIt.registerLazySingleton(
    () => PapersRepositoryImpl(getIt(),),
  );

  getIt.registerLazySingleton(
    () => GetPaperData(getIt(),),
  );

  getIt.registerFactory(
    () => PapersBloc(getIt(),),
  );
}
