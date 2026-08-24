import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/exam/domain/entities/exam_page_arguments.dart';
import 'package:math_matric/features/ui/exam/presentation/bloc/exam_bloc.dart';
import 'package:math_matric/features/ui/exam/presentation/pages/exam_paper_page.dart';
import 'package:math_matric/features/ui/exam/presentation/pages/exam_paper_viewer.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/registrations/ui/register_exams_module.dart';

class ExamRoutes {
  const ExamRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.examPage,
      builder: (context, state) {
        final examArgs = state.extra as ExamPageArguments;
        return BlocProvider(
          create: (_) => getIt<ExamBloc>(),
          child: ExamPaperPage(
            contextData: examArgs.contextData,
            mode: examArgs.mode,
            paperId: examArgs.paperId,
          ),
        );
      },
    ),

    GoRoute(
      path: Routes.examPaperViewer,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return ExamPaperViewer(
          pagePaths: List<String>.from(args['pagePathss']), 
          title: args['title'],
          topicId: args['topicId'],
        );
      },
    ),
  ];
}
