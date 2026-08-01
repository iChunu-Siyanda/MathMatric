import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:math_matric/features/analytics/presentation/pages/analytics_page.dart';
import 'package:math_matric/features/streak/presentation/bloc/habit_bloc.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/registrations/register_services_module.dart';

class AnalyticsRoutes {
  const AnalyticsRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.analytics,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AnalyticsBloc>(),),
            BlocProvider(create: (_) => getIt<HabitBloc>(),),
          ], 
          child: const AnalyticsPage(),
        );
      },
    ),
  ];
}
