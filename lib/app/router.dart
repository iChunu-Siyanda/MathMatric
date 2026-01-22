import 'package:flutter/material.dart';
import 'package:math_matric/auth/login_page.dart';
import 'package:math_matric/auth/splash_page.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/routes/home/screen/home_page.dart';
import 'package:math_matric/features/papers/presentation/page/papers_page.dart';

class Routes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String papers = '/papers';
}

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.initial:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );

      case Routes.papers:
        final paperType = settings.arguments as PaperType;
        return MaterialPageRoute(builder: (_) => PapersPage(paperType: paperType,));

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}

//Use Navigator.pushNamed(context, Routes.papers), throughout the app.