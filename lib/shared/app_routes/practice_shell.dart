import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/exam/presentation/navigation/exam_routes.dart';
import 'package:math_matric/features/papers/papers/presentation/navigation/paper_type_routes.dart';
import 'package:math_matric/features/papers/papers/presentation/navigation/section_type_routes.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/navigation/quiz_routes.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';

class PracticeShell {
  const PracticeShell._();

  static final RouteBase route = ShellRoute(
    builder: (context, state, child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<PracticeBloc>(),
          ),
          BlocProvider(
            create: (_) => getIt<QuizBloc>(),
          ),
        ],
        child: child,
      );
    },
    routes: [
      ...PaperTypeRoutes.routes,
      ...SectionPageRoutes.routes,
      ...ExamRoutes.routes,
      ...QuizRoutes.routes,
    ],
  );
}
