import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/quiz/domain/entities/quiz_page_params.dart';
import 'package:math_matric/features/papers/quiz/domain/entities/quiz_results_params.dart';
import 'package:math_matric/features/papers/quiz/presentation/pages/quiz_page.dart';
import 'package:math_matric/features/papers/quiz/presentation/pages/quiz_results.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class QuizRoutes {
  const QuizRoutes._();

  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.quizPage,
      builder: (context, state) {
        final args = state.extra as QuizPageParams;

        return QuizPage(
          topicId: args.topicId,
          xpEarned: args.xp,
          levelId: args.levelId,
        );
      },
    ),

    GoRoute(
      path: Routes.quizResults,
      builder: (context, state) {
        final args = state.extra as QuizResultsParams;

        return QuizResults(
          score: args.score, 
          totalScore: args.totalScore, 
          getTotalQuestions: args.getTotalQuestions, 
          getQuestionByIndex: args.getQuestionByIndex, 
          topic: args.topic, 
          userAnswers: args.userAnswers, 
          selectedIndex: args.selectedIndex,  
          topicId: args.topicId, 
          xpEarned: args.xpEarned, 
          levelId: args.levelId,
        );
      },
    ),
  ];
}
