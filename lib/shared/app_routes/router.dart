import 'package:math_matric/features/auth/presentation/navigation/auth_routes.dart';
import 'package:math_matric/features/home/presentation/navigation/home_routes.dart';
import 'package:math_matric/features/papers/exam/presentation/navigation/exam_routes.dart';
import 'package:math_matric/features/papers/papers/presentation/navigation/paper_type_routes.dart';
import 'package:math_matric/features/papers/papers/presentation/navigation/section_type_routes.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.initial,
    routes: [
      ...AuthRoutes.routes,

      ...HomeRoutes.routess,

      ...PaperTypeRoutes.routes,

      ...SectionPageRoutes.routes,

      ...ExamRoutes.routes,
    ],
  );
}
