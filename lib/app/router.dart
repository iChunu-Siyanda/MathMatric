import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/auth/presentation/navigation/auth_firebase.dart';
import 'package:math_matric/features/auth/presentation/page/login_page.dart';
import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/data/local/papers_item_local_data.dart';
import 'package:math_matric/features/papers/data/respositories/exam_repository_impl.dart';
import 'package:math_matric/features/papers/data/respositories/papers_respository_impl.dart';
import 'package:math_matric/features/papers/domain/entities/exam_page_arguments.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/usercases/get_paper_data.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_bloc.dart';
import 'package:math_matric/features/papers/presentation/pages/exam/exam_paper_page.dart';
import 'package:math_matric/features/home/page/home_page.dart';
import 'package:math_matric/features/papers/presentation/pages/papers_page.dart';

class Routes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String paperTypePage = '/paperTypePage';
  static const String examPage = 'examPage';
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

      case Routes.paperTypePage:
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

      case Routes.examPage:
        final args = settings.arguments as ExamPageArguments;
        final localExamDataSource = ExamPaperData();
        final repository = ExamPaperRepositoryImpl(localExamDataSource);
        final getExamPaperData = GetExamPaperData(repository);
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ExamBloc(getExamPaperData),
            child: ExamPaperPage(
              contextData: args.contextData,
              mode: args.mode,
              paperType: args.paperType,
            ),
          ),
        );

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
// Navigator.pushNamed(
//   context,
//   Routes.examPage,
//   arguments: ExamPageArguments(
//     paperType: PaperType.paper1,
//     mode: ExamPageMode.paper,
//     contextData: contextData,
//   ),
// );
