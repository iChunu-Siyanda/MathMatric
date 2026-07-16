import 'package:go_router/go_router.dart';
import 'package:math_matric/features/auth/presentation/navigation/auth_firebase.dart';
import 'package:math_matric/features/auth/presentation/page/forgot_password_page.dart';
import 'package:math_matric/features/auth/presentation/page/login_page.dart';
import 'package:math_matric/features/auth/presentation/page/register_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class AuthRoutes {
  const AuthRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.initial,
      builder: (context, state) {
        return const AuthFirebase();
      },
    ),

    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    
    GoRoute(
      path: Routes.register,
      builder: (context, state) {
        return const RegisterPage();
      },
    ),

    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) {
        return const ForgotPasswordPage();
      },
    ),
  ];
}
