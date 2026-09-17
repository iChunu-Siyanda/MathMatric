import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/marketplace/history/presentation/pages/market_place_history_page.dart';
import 'package:math_matric/features/marketplace/masterclasses/presentation/pages/masterclasses_page.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/search/tutor_search_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/tutor/tutor_bloc.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/pages/tutor_discovery_page.dart';
import 'package:math_matric/features/ui/home/presentation/page/home_page.dart';
import 'package:math_matric/shared/app_routes/main_navigation_shell.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/registrations/dependencies/register_app_database_module.dart';

class BottomNavRoutes {
  BottomNavRoutes._();

  static final StatefulShellRoute route = StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.tutorDiscovery,
                builder: (context, state) { 
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => getIt<TutorSearchBloc>(),),
                      BlocProvider(create: (_) => getIt<TutorBloc>(),)
                    ],
                    child: TutorDiscoveryPage(),
                  );
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.masterclasses,
                builder: (context, state) => const MasterclassesPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.marketPlaceHistory,
                builder: (context, state) => const MarketPlaceHistoryPage(),
              ),
            ],
          ),
        ],
      );
}
