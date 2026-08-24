import 'package:get_it/get_it.dart';
import 'package:math_matric/features/curriculum/notes/domain/repositories/class_note_repository.dart';
import 'package:math_matric/features/papers/classnotes/domain/usecases/get_class_note_by_topic_use_case.dart';
import 'package:math_matric/features/papers/classnotes/domain/usecases/get_class_note_use_case.dart';
import 'package:math_matric/features/papers/classnotes/presentation/bloc/class_notes_bloc.dart';

final getIt = GetIt.instance;

void registerClassNotesModule() {
  getIt.registerLazySingleton(
    () => GetClassNotesUseCase(getIt<ClassNoteRepository>(),),
  );

  getIt.registerLazySingleton(
    () => GetClassNotesByTopicUseCase(getIt<ClassNoteRepository>(),),
  );

  getIt.registerFactory(
    () => ClassNotesBloc(
      getClassNotes: getIt(), 
      getClassNotesByTopic: getIt(),
    ),
  );
}
