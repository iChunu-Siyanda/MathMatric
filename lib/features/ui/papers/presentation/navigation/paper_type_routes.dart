import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/ui/papers/presentation/bloc/papers_bloc.dart';
import 'package:math_matric/features/ui/papers/presentation/pages/papers_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/registrations/ui/register_exams_module.dart';

class PaperTypeRoutes {
  const PaperTypeRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.paperTypePage,
      builder: (context, state) {
        final paperType = state.extra as PaperType;
        return BlocProvider(
          create: (_) => getIt<PapersBloc>(),
          child: PapersPage(paperType: paperType),
        );
      },
    ),
  ];
}
