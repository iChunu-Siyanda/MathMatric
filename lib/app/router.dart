import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/auth/auth_firebase.dart';
import 'package:math_matric/auth/login_page.dart';
import 'package:math_matric/features/papers/data/local/papers_item_local_data.dart';
import 'package:math_matric/features/papers/data/respositories/papers_respository_impl.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/usercases/get_paper_data.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_bloc.dart';
import 'package:math_matric/routes/home/screen/home_page.dart';
import 'package:math_matric/features/papers/presentation/pages/papers_page.dart';

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
        return MaterialPageRoute(builder: (_) => const AuthFirebase());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );

      case Routes.papers:
        final paperType = settings.arguments as PaperType;
        //Create data source -> creater respository -> usercase
        final localDataSource = PaperTileLocalData(); //data source
        final repository = PapersRepositoryImpl(localDataSource); //respository
        final getPaperData = GetPaperData(repository); //usercase
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (_) => PapersBloc(getPaperData),
                  child: PapersPage(paperType: paperType),
                ));

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
