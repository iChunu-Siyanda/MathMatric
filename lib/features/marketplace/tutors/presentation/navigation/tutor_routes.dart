import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/marketplace/tutors/presentation/bloc/profile/tutor_profile_bloc.dart';

import 'package:math_matric/features/marketplace/tutors/presentation/pages/tutor_profile_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/registrations/dependencies/register_app_database_module.dart';

class TutorRoutes {
  const TutorRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.tutorProfile,
      builder: (context, state) {
        final tutorId = state.extra as String;
        return BlocProvider(
          create: (_) => getIt<TutorProfileBloc>(),
          child: TutorProfilePage(tutorId: tutorId),
        );
      },
    ),
  ];
}
