import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/home/presentation/page/study_history_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class HomeRoutes {
  const HomeRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.studyHistory,
      builder: (context, state) => const StudyHistoryPage(),
    ),
  ];
}
