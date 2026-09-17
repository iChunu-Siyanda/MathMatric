import 'package:go_router/go_router.dart';
import 'package:math_matric/features/marketplace/masterclasses/presentation/pages/masterclasses_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class MasterclassesRoutes {
  const MasterclassesRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.masterclasses,
      builder: (context,state) => const MasterclassesPage(),
    ),
  ];
}
