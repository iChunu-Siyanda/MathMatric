import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/features/papers/presentation/bloc/practice/practice_state.dart';
import 'package:math_matric/features/papers/presentation/widget/main/practice_level_tile.dart';
import 'package:math_matric/features/papers/presentation/widget/main/quizzes_header.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});


  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> with AutomaticKeepAliveClientMixin<QuizzesPage>{
  @override
  bool get wantKeepAlive => true;

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
                  title: state.practiceTopic.title,
                  subtitle: state.practiceTopic.description,
                  progress: state.progress,
                  xpEarned: state.earnedXp,
                  totalXp: state.totalXp,
                  accentColor: state.practiceTopic.color,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PracticeLevelTile(
                      level: state.levels[index],
                      onTap: () {},
                    );
                  },
                  childCount: state.levels.length,
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
