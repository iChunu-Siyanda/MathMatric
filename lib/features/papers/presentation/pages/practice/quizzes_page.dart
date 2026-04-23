import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_event.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_state.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<PracticeBloc>().add(PracticeLoadTopic(widget.topicId.replaceAll('','_').toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PracticeBloc, PracticeState>(
      builder: (context, state) {
        if (state is PracticeLoaded) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: QuizzesHeader(
                  title: state.data.practiceTopic.title,
                  subtitle: state.data.practiceTopic.description,
                  progress: state.data.progress,
                  xpEarned: state.data.earnedXp,
                  totalXp: state.data.totalXp,
                  accentColor: state.data.practiceTopic.color,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PracticeLevelTile(
                      level: state.data.levels[index],
                      onTap: () {},
                    );
                  },
                  childCount: state.data.levels.length,
                ),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
