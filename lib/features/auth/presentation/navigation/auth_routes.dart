import 'package:flutter/material.dart';
import 'package:math_matric/features/auth/presentation/navigation/auth_firebase.dart';
import 'package:math_matric/features/auth/presentation/page/login_page.dart';

class AuthRoutes {
  const AuthRoutes._();

  static Route get authInitial => MaterialPageRoute(builder: (_) => const AuthFirebase());
  static Route get login => MaterialPageRoute(builder: (_) => const LoginPage());
}
