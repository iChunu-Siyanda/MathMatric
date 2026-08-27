import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/home/presentation/page/home_page.dart';
import 'package:math_matric/features/ui/home/presentation/page/study_history_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class HomeRoutes {
  const HomeRoutes._();

  static final routess = <RouteBase>[
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    
    GoRoute(
      path: Routes.studyHistoryPage,
      builder: (context, state) => const StudyHistoryPage(),
    ),
  ];
}
