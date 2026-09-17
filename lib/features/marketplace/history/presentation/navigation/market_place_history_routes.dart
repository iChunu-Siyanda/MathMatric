import 'package:go_router/go_router.dart';
import 'package:math_matric/features/marketplace/history/presentation/pages/market_place_history_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class MarketPlaceHistoryRoutes {
  const MarketPlaceHistoryRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.marketPlaceHistory,
      builder: (context, state) => const MarketPlaceHistoryPage(),
    ),
  ];
}
