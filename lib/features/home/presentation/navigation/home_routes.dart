import 'package:go_router/go_router.dart';
import 'package:math_matric/features/home/presentation/page/home_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class HomeRoutes {
  const HomeRoutes._();

  static final routess = <RouteBase>[
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return const HomePage();
      },
    ),
  ];
}
