import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/quiz/data/local/quiz_data_source.dart';
import 'package:math_matric/features/papers/quiz/data/repositories/quiz_questions_repository_impl.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/quiz/domain/usecases/load_quiz_questions_use_case.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_bloc.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_event.dart';
import 'package:math_matric/features/papers/practice/presentation/bloc/practice_state.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:math_matric/features/papers/quiz/presentation/bloc/quiz_event.dart';
import 'package:math_matric/features/papers/practice/presentation/pages/quiz_page.dart';
import 'package:math_matric/features/papers/practice/presentation/widgets/practice_level_tile.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/quizzes_header.dart';

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

  String toCamelCase(String input) {
    // Split the string by spaces or underscores
    final words = input.trim().split(RegExp(r'[\s_]+'));
    if (words.isEmpty) return '';

    // Keep the first word entirely lowercase
    String result = words[0].toLowerCase();

    // Capitalize the first letter of all subsequent words
    for (int i = 1; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        result += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }

    return result;
  }

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
                          final targetSubjectTopic = SubjectTopic.values.firstWhere((e){
                              final cleanEnumName = e.name.toLowerCase().replaceAll('_', '');
                              final cleanTopicId = currentTopicId.toLowerCase().replaceAll('_', '');
                              return cleanEnumName == cleanTopicId;
                            },
                            orElse: () => throw Exception("Could not find matching SubjectTopic enum value for ID: $currentTopicId"),
                          );
                          final practiceBloc = context.read<PracticeBloc>();
                          final localDataSource = QuizDataSource();
                          final quizRepository = QuizQuestionsRepositoryImpl(localDataSource);
                          final getQuizQuestions = LoadQuizQuestionsUseCase(quizRepository);

                          Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(value: practiceBloc),
                                  BlocProvider(
                                    create: (context) => QuizBloc(getQuizQuestions)..add(StartQuizEvent(level.levelId, targetSubjectTopic)),
                                  ),
                                ],
                                child: QuizPage(topicId: toCamelCase(widget.topicId), xpEarned: state.data.earnedXp, levelId: level.levelId,),
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
