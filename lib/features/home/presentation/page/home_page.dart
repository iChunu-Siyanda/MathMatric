import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_matric/app/router.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_bloc.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_state.dart';
import 'package:math_matric/features/home/presentation/widgets/featured_topic_card.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/drawer/math_matric_drawer.dart';
import 'package:math_matric/features/home/presentation/widgets/auto_sliding_carousel.dart';
import 'package:math_matric/features/home/presentation/widgets/continue_studying_card.dart';
import 'package:math_matric/features/home/presentation/widgets/path_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver AppBar
          SliverAppBar(
            backgroundColor: colorScheme.primary,
            //leading: Icon(Icons.menu, color: colorScheme.onPrimary),
            expandedHeight: 200,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "MathMatric",
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ),

          // Smart Coach carousel placeholder
          AutoSlidingCarousel(),

          // Hero card
          SliverToBoxAdapter(
            child: BlocBuilder<StudyHistoryBloc, StudyHistoryState>(
              builder: (context, state) {
                if (state.recentTopics.isEmpty) {
                  return FeaturedTopicCard(
                    topic: "Calculus",
                    backgroundImg: "assets/images/calc.webp",
                    onTap: () {
                      // Navigate to exam paper viewer
                    },
                  );
                }

                return SizedBox(
                  height: 200, // Fixed height for carousel
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.recentTopics.length,
                    itemBuilder: (context, index) {
                      final topic = state.recentTopics[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ContinueStudyingCard(
                            topic: topic.title,
                            backgroundImg: topic.backgroundImg,
                            progress: topic.progress,
                            onTap: () {
                              // Navigate to viewer
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              children: [
                PathCard(
                  title: "Paper 1",
                  subtitle: "Algebra • Functions",
                  imgPath: "assets/images/steps_img.webp",
                  progress: 0.6,
                  gradient: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  //gradient: [Colors.blue, Colors.indigo],
                  onTap: () {
                    Navigator.pushNamed(context, Routes.paperTypePage,
                        arguments: PaperType.paper1);
                  },
                ),
                PathCard(
                  title: "Paper 2",
                  subtitle: "Geometry • Trig",
                  imgPath: "assets/images/globe_img.webp",
                  progress: 0.3,
                  gradient: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  //gradient: [ Colors.teal,Colors.green,],
                  onTap: () {},
                ),
              ],
            ),
          ),

          //Discussions Card
          //SliverToBoxAdapter(child: DiscussionsCard(onTap: () {}, backgroundImg: "assets/images/hands_img.webp",)),
        ],
      ),
      drawer: MathMatricDrawer(
        streak: 8,
      ),
    );
  }
}
