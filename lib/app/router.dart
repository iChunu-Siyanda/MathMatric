import 'package:flutter/material.dart';
import 'package:math_matric/features/auth/presentation/navigation/auth_routes.dart';
import 'package:math_matric/features/home/presentation/navigation/home_routes.dart';
import 'package:math_matric/features/papers/exam/presentation/navigation/exam_routes.dart';
import 'package:math_matric/features/papers/papers/presentation/navigation/paper_type_routes.dart';
import 'package:math_matric/features/papers/papers/presentation/navigation/section_type_routes.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, 
  ) {
    switch (settings.name) {
      case Routes.initial:
        return AuthRoutes.authInitial;

      case Routes.login:
        return AuthRoutes.login;

      case Routes.home:
        return HomeRoutes.routes;

      case Routes.paperTypePage:
        return PaperTypeRoutes.paperTypeRoute(settings);

      case Routes.examPage:
        return ExamRoutes.examRoute(settings);

      case Routes.examPaperViewer:
        return ExamRoutes.examPaperViewerRoute(settings);

      case Routes.sectionPage:
        return SectionPageRoutes.sectionPageRoute(settings);

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page/route not found')),
          ),
        );
    }
  }
}
