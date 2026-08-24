import 'package:get_it/get_it.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_bloc.dart';

final getIt = GetIt.instance;

void registerStudyHistoryModule() {
  getIt.registerFactory(
    () => StudyHistoryBloc()
  );
}
