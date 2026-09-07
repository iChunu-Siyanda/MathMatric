import 'package:get_it/get_it.dart';
import 'package:math_matric/features/marketplace/tutors/domain/repositories/tutor_repository.dart';
import 'package:math_matric/features/marketplace/tutors/domain/services/tutor_search_key_builder.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/get_tutor_profile_use_case.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/get_tutors_use_case.dart';
import 'package:math_matric/features/marketplace/tutors/domain/usecases/search_tutors_use_case.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/profile/tutor_profile_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor/tutor_bloc.dart';

final getIt = GetIt.instance;

void registerTutorsModule() {
  //usecases:
  getIt.registerLazySingleton(
    () => GetTutorsUseCase(getIt<TutorRepository>(),),
  );

  getIt.registerLazySingleton(
    () => SearchTutors(
      repository: getIt<TutorRepository>(),
      keyBuilder: getIt<TutorSearchKeyBuilder>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetTutorProfileUseCase(getIt<TutorRepository>(),),
  );

  //Bloc:
  getIt.registerFactory(
    () => TutorBloc(getTutors: getIt(),),
  );

  getIt.registerFactory(
    () => TutorSearchBloc(searchTutors: getIt(),)
  );

  getIt.registerFactory(
    () => TutorProfileBloc(getTutorProfile: getIt(),),
  );
}
