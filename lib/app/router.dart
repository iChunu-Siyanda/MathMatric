import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/auth/presentation/navigation/auth_firebase.dart';
import 'package:math_matric/features/auth/presentation/page/login_page.dart';
import 'package:math_matric/features/papers/exam/domain/entities/exam_page_arguments.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/domain/entities/section_type_arguments.dart';
import 'package:math_matric/features/papers/exam/presentation/bloc/exam_bloc.dart';
import 'package:math_matric/features/papers/papers/presentation/bloc/papers_bloc.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_event.dart';
import 'package:math_matric/features/papers/exam/presentation/pages/exam_paper_page.dart';
import 'package:math_matric/features/home/presentation/page/home_page.dart';
import 'package:math_matric/features/papers/exam/presentation/pages/exam_paper_viewer.dart';
import 'package:math_matric/features/papers/papers/presentation/pages/papers_page.dart';
import 'package:math_matric/features/papers/papers/presentation/pages/section_type.dart';
import 'package:math_matric/shared/entities/tab_type.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';

class Routes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String paperTypePage = '/paperTypePage';
  static const String examPage = 'examPage';
  static const String sectionPage = "sectionPage";
  static const String examPaperViewer = "examPaperViewer";
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, 
  ) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => const AuthFirebase());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage(),);

      case Routes.paperTypePage:
        final paperType = settings.arguments as PaperType; //usercase
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (_) => getIt<PapersBloc>(),
                  child: PapersPage(paperType: paperType),
                ));

      case Routes.examPage:
        final args = settings.arguments as ExamPageArguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ExamBloc>(),
            child: ExamPaperPage(
              contextData: args.contextData,
              mode: args.mode,
              paperId: args.paperId,
            ),
          ),
        );

      case Routes.examPaperViewer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ExamPaperViewer(
            title: args["title"],
            pageAssets: List<String>.from(args["pageAssets"]),
          ),
        );  

      case Routes.sectionPage:
        final args = settings.arguments as SectionTypeArguments;
        String toCamelCase(String? input) {
            if (input == null || input.isEmpty) return '';

            // Step 1: Split camelCase boundaries and replace spaces/hyphens/underscores with spaces
            // This unifies all formats into a space-separated string
            final splitBoundaries = input.replaceAllMapped(
              RegExp(r'([a-z0-9])([A-Z])'),
              (m) => '${m[1]} ${m[2]}',
            );
            
            // Replace hyphens, underscores, and multiple spaces with a single space
            final cleanString = splitBoundaries.replaceAll(RegExp(r'[\s\-_]+'), ' ');

            // Step 2: Split into individual words
            final words = cleanString.trim().split(' ');
            if (words.isEmpty) return '';

            // Step 3: Lowercase the first word, uppercase the rest
            final buffer = StringBuffer(words[0].toLowerCase());
            
            for (var i = 1; i < words.length; i++) {
              final word = words[i];
              if (word.isNotEmpty) {

                buffer.write(word[0].toUpperCase() + word.substring(1).toLowerCase());
              }
            }

            return buffer.toString();
          }
        TabType toTabType(String input) {
          final camelCase = toCamelCase(input);
          return TabType.values.firstWhere(
            (t) => toCamelCase(t.toString()) == camelCase,
            orElse: () => throw ArgumentError('No matching TabType for input: $input'),
          );
        }

        if (args.tabType == TabType.exam) {
          debugPrint(
              "args.tabType = ${args.tabType}, sectionContext = ${args.sectionContext}, tabs: ${args.tabs}, pageTitle: ${args.pageTitle},");
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<ExamBloc>(),
              child: SectionType(
                pageTitle: args.pageTitle,
                sectionContext: args.sectionContext,
                tabs: args.tabs,
              ),
            ),
          );
        } else if (toTabType(args.tabType.toString()) == TabType.practicePapers) {
          String topicID = toCamelCase(args.topicId);
          debugPrint( "args.tabType = ${args.tabType}, TopicId = $topicID, tabs: ${args.tabs}, pageTitle: ${args.pageTitle}");
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<PracticeBloc>()..add(PracticeLoadTopic(topicID)),
              child: SectionType(
                pageTitle: args.pageTitle,
                sectionContext: args.sectionContext,
                tabs: args.tabs,
              ),
            ),
          );
        } 
        else if (toTabType(args.tabType.toString()) == TabType.classNotes) {
          String topicID = toCamelCase(args.topicId);
          debugPrint(
              "args.tabType = ${args.tabType}, TopicId = $topicID, tabs: ${args.tabs}, pageTitle: ${args.pageTitle}");
          return MaterialPageRoute(
            builder: (_) => SectionType(
              pageTitle: args.pageTitle,
              sectionContext: args.sectionContext,
              tabs: args.tabs,
            ),
          );
        }
        else {
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
