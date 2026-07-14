import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_page_arguments.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_bloc.dart';
import 'package:math_matric/features/papers/exam/presentation/pages/exam_paper_page.dart';
import 'package:math_matric/features/papers/exam/presentation/pages/exam_paper_viewer.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';

class ExamRoutes {
  const ExamRoutes._();

  static Route<dynamic> examRoute(RouteSettings settings) {
    final args = settings.arguments as ExamPageArguments;
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => getIt<ExamBloc>(),
        child: ExamPaperPage(
          contextData: args.contextData,
          mode: args.mode,
          paperId: args.paperId,
        ),
      ),
    );
  }

  static Route<dynamic> examPaperViewerRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (_) => ExamPaperViewer(
        title: args["title"],
        pageAssets: List<String>.from(args["pageAssets"]),
      ),
    );  
  }
}
