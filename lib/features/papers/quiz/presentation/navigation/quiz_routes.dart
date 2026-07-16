import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/papers/quiz/domain/entities/quiz_page_params.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';
import 'package:math_matric/features/papers/quiz/presentation/pages/quiz_page.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/shared/registrations/register_exams_module.dart';

class QuizRoutes {
  const QuizRoutes._();
        // Navigator.push(context, 
        //                     MaterialPageRoute(
        //                       builder: (_) => MultiBlocProvider(
        //                         providers: [
        //                           BlocProvider.value(value: practiceBloc),
        //                           BlocProvider(
        //                             create: (context) => getIt<QuizBloc>()..add(StartQuizEvent(level.levelId, targetSubjectTopic)),
        //                           ),
        //                         ],
        //                         child: QuizPage(topicId: toCamelCase(widget.topicId), xpEarned: state.data.earnedXp, levelId: level.levelId,),
        //                       ),
        //                     ),
        //                   );
  static final routes = <RouteBase>[
    GoRoute(
      path: Routes.quizPage,
      builder: (context, state) {
        final args = state.extra as QuizPageParams;
        final practiceBloc = context.read<PracticeBloc>();

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: practiceBloc),
            BlocProvider(
              create: (context) => getIt<QuizBloc>()..add(
                StartQuizEvent(args.levelId, args.targetSubjectTopic),
              ),
            ),
          ],
          child: QuizPage(
            topicId: args.topicId, 
            xpEarned: args.xp, 
            levelId: args.levelId,
          ),
        );
      },
    ),
  ];
}
