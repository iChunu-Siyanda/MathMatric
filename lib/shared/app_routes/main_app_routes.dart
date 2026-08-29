import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/home/presentation/page/home_page.dart';
import 'package:math_matric/features/ui/profile/presentation/pages/profile_page.dart';
import 'package:math_matric/features/ui/search/presentation/pages/search_page.dart';
//import 'package:math_matric/features/ui/tutors/presentation/pages/tutor_page.dart';
import 'package:math_matric/shared/app_routes/main_navigation_shell.dart';

class MainAppRoutes {
  MainAppRoutes._();

  final GoRouter appRouter = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),

          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: '/tutors',
          //       builder: (context, state) => const TutorPage(),
          //     ),
          //   ],
          // ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
