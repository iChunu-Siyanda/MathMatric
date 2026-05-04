import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/app/factories/topic_factory.dart';
import 'package:math_matric/features/auth/presentation/navigation/auth_firebase.dart';
import 'package:math_matric/features/auth/presentation/page/login_page.dart';
import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/data/local/papers_item_local_data.dart';
import 'package:math_matric/features/papers/data/respositories/exam_repository_impl.dart';
import 'package:math_matric/features/papers/data/respositories/local_practice_repository.dart';
import 'package:math_matric/features/papers/data/respositories/local_user_progress_impl.dart';
import 'package:math_matric/features/papers/data/respositories/papers_respository_impl.dart';
import 'package:math_matric/features/papers/domain/entities/exam_page_arguments.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/entities/section_type_arguments.dart';
import 'package:math_matric/features/papers/domain/usercases/get_exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/usercases/get_paper_data.dart';
import 'package:math_matric/features/papers/domain/usercases/load_practice_topic.dart';
import 'package:math_matric/features/papers/presentation/bloc/exam/exam_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/paper/papers_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_event.dart';
import 'package:math_matric/features/papers/presentation/pages/exam/exam_paper_page.dart';
import 'package:math_matric/features/home/page/home_page.dart';
import 'package:math_matric/features/papers/presentation/pages/papers_page.dart';
import 'package:math_matric/features/papers/presentation/pages/section_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String paperTypePage = '/paperTypePage';
  static const String examPage = 'examPage';
  static const String sectionPage = "sectionPage";
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(
      RouteSettings settings, SharedPreferences prefs) {
    final localExamDataSource = ExamPaperData();
    final repository = ExamPaperRepositoryImpl(localExamDataSource);
    final getExamPaperData = GetExamPaperData(repository);

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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ExamBloc(getExamPaperData),
            child: ExamPaperPage(
              contextData: args.contextData,
              mode: args.mode,
              paperId: args.paperId,
            ),
          ),
        );

      case Routes.sectionPage:
        final args = settings.arguments as SectionTypeArguments;
        if (args.tabType == TabType.exam) {
          debugPrint(
              "args.tabType = ${args.tabType}, sectionContext = ${args.sectionContext}, tabs: ${args.tabs}, pageTitle: ${args.pageTitle}, getExamPaperDara: $getExamPaperData");
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => ExamBloc(getExamPaperData),
              child: SectionType(
                pageTitle: args.pageTitle,
                sectionContext: args.sectionContext,
                tabs: args.tabs,
              ),
            ),
          );
        } else if (args.tabType == TabType.practice) {
          String toSnakeCase(String? input) {
            if (input == null) return '';
            final step1 = input.replaceAllMapped(
              RegExp(r'([a-z0-9])([A-Z])'),
              (m) => '${m[1]}_${m[2]}',
            );

            final step2 = step1.replaceAll(RegExp(r'[\s\-]+'), '_');

            return step2.toLowerCase();
          }

          String topicID = toSnakeCase(args.topicId);

          final getPracticeRepository = LocalPracticeRepository();
          final getProgressRepository = LocalUserProgressRepository(prefs);
          final practiceData = LoadPracticeTopicUseCase(
              practiceRepository: getPracticeRepository,
              progressRepository: getProgressRepository);
          debugPrint(
              "args.tabType = ${args.tabType}, TopicId = $topicID, tabs: ${args.tabs}, pageTitle: ${args.pageTitle}, PracticeData: $practiceData");
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => PracticeBloc(loadPractice: practiceData)
                ..add(PracticeLoadTopic(topicID)),
              child: SectionType(
                pageTitle: args.pageTitle,
                sectionContext: args.sectionContext,
                tabs: args.tabs,
              ),
            ),
          );
        } else {
          return MaterialPageRoute(
              builder: (_) => SectionType(
                    pageTitle: args.pageTitle,
                    sectionContext: args.sectionContext,
                    tabs: args.tabs,
                  ));
        }

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page/route not found')),
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
