import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_state.dart';
import 'package:math_matric/features/papers/presentation/bloc/quiz/quiz_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/quiz/quiz_event.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/quiz_page.dart';
import 'package:math_matric/features/papers/presentation/widget/main/practice_level_tile.dart';
import 'package:math_matric/features/papers/presentation/widget/main/quizzes_header.dart';

class QuizzesPage extends StatefulWidget {
  final String topicId;
  const QuizzesPage({super.key, required this.topicId});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage>
    with AutomaticKeepAliveClientMixin<QuizzesPage> {
  @override
  bool get wantKeepAlive => true;

  String toSnakeCase(String? input) {
    if (input == null) return '';
    final step1 = input.replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (m) => '${m[1]}_${m[2]}',
    );

    final step2 = step1.replaceAll(RegExp(r'[\s\-]+'), '_');

    return step2.toLowerCase();
  }

  String get topicIdToSnakeCase => toSnakeCase(widget.topicId); 

  @override
  void initState() {
    super.initState();
    context.read<PracticeBloc>().add(PracticeLoadTopic(topicIdToSnakeCase));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PracticeBloc, PracticeState>(
      builder: (context, state) {
        if (state is PracticeLoaded) {
          debugPrint("BLOC REBUILD -> XP Earned: ${state.data.earnedXp} / ${state.data.totalXp}");
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: QuizzesHeader(
                  title: state.data.practiceTopic.title,
                  subtitle: state.data.practiceTopic.description,
                  progress: state.data.progress,
                  totalXpEarned: state.data.earnedXp,
                  totalXp: state.data.totalXp,
                  accentColor: state.data.practiceTopic.color,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final String currentTopicId = state.data.practiceTopic.id;
                    return PracticeLevelTile(
                      level: state.data.levels[index],
                      progressScore: state.data.levels[index].progress, 
                      onTap: () {
                        final level = state.data.levels[index];
                        if (level.isUnlocked) {
                          final targetSubjectTopic = SubjectTopic.values.firstWhere(
                            (e) => e.name == currentTopicId,
                          );
                          final practiceBloc = context.read<PracticeBloc>();
                          final quizBloc = context.read<QuizBloc>()..add(StartQuizEvent(level.levelId, targetSubjectTopic));

                          Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(value: practiceBloc),
                                  BlocProvider.value(value: quizBloc),
                                ],
                                child: QuizPage(topicId: topicIdToSnakeCase, xpEarned: state.data.earnedXp, levelId: level.levelId,),
                              ),
                            ),
                          );
                        }  
                      },
                    );
                  },
                  childCount: state.data.levels.length,
                ),
              ),
            ],
          );
        }

        if (state is PracticeError) {
          return Center(child: Text(state.message));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
