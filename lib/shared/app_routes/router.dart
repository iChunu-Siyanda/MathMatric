import 'package:math_matric/features/ui/analytics/presentation/navigation/analytics_routes.dart';
import 'package:math_matric/features/auth/presentation/navigation/auth_routes.dart';
import 'package:math_matric/features/ui/home/presentation/navigation/home_routes.dart';
import 'package:math_matric/shared/app_routes/practice_shell.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.initial,
    routes: [
      ...AuthRoutes.routes,

      ...HomeRoutes.routess,

      ...AnalyticsRoutes.routes,

      PracticeShell.route,
    ],
  );
}
