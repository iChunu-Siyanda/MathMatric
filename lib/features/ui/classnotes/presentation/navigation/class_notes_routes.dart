import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/classnotes/presentation/bloc/class_notes_bloc.dart';
import 'package:math_matric/features/ui/classnotes/presentation/pages/class_notes_page.dart';
import 'package:math_matric/features/ui/classnotes/presentation/pages/class_notes_tips.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/registrations/ui/register_analytics_streak_module.dart';

class ClassNotesRoutes {
  const ClassNotesRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.classNotePage,
      builder: (context, state) {
        final topicId = state.extra as String;

        return BlocProvider(
          create: (_) => getIt<ClassNotesBloc>(),
          child: ClassNotesPage(topicId: topicId,),
        );
      },
    ),
    GoRoute(
      path: Routes.classNoteTips,
      builder: (context, state) {
        return ClassNotesTips();
      },
    ),
  ];
}
