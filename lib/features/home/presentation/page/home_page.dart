import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_bloc.dart';
import 'package:math_matric/features/home/presentation/bloc/study_history_state.dart';
import 'package:math_matric/features/home/presentation/widgets/featured_topic_card.dart';
import 'package:math_matric/features/home/presentation/widgets/header_icon_button.dart';
import 'package:math_matric/features/home/presentation/widgets/home_section_header.dart';
import 'package:math_matric/features/home/presentation/widgets/quiz_alert_card.dart';
import 'package:math_matric/features/home/presentation/widgets/streak_alert_card.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/drawer/math_matric_drawer.dart';
import 'package:math_matric/features/home/presentation/widgets/continue_studying_card.dart';
import 'package:math_matric/features/home/presentation/widgets/path_card.dart';
import 'package:math_matric/shared/app_routes/routes.dart';
import 'package:math_matric/theme/app_colours.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<StudyHistoryBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final hasRecentQuiz = true;
    return Scaffold(
      backgroundColor: AppColours.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 112,
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false, // Prevents Flutter from automatically showing a back button if routed
            backgroundColor: AppColours.background.withValues(alpha: 0.85),
            surfaceTintColor: Colors.transparent,

            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(
                    left: 20, // Reset to standard content edge alignment
                    bottom: 14,
                  ),
                  expandedTitleScale: 1.3,
                  title: const Text(
                    'MathMatric',
                    style: TextStyle(
                      color: AppColours.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            ),

            actions: [
              HeaderIconButton(
                icon: Icons.notifications_none_rounded,
                badgeCount: 2,
                onTap: () {},
              ),
              HeaderIconButton(
                icon: Icons.person_outline_rounded,
                onTap: () {},
              ),
              const SizedBox(width: 12),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  StreakAlertCard(onTap: () {  }, currentStreak: 1, personalBest: 35, userName: 'Siya',),

                  if (hasRecentQuiz) ...[
                    const SizedBox(height: 10),
                    QuizAlertCard(),
                  ],
                ],
              ),
            ),
          ),


          // Hero card
          SliverToBoxAdapter(
            child: HomeSectionHeader(
              title: "Continue Studying",
            ),
          ),
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
                
                //Scrolls horizontally, 
                return SizedBox(
                  height: 200, 
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
                            margin: EdgeInsets.zero,
                            topic: topic.title,
                            backgroundImg: topic.backgroundImg,
                            progress: topic.progress,
                            onTap: () {
                              context.push(
                                Routes.examPaperViewer,
                                extra: {
                                  "title": topic.title,
                                  "pageAssets": topic.assets,
                                },
                              );
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

          // Papers
          SliverToBoxAdapter(
            child: HomeSectionHeader(
              title: "Papers",
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 480, // Switches to 1 column below ~480px, 2-3 cols above
                mainAxisExtent: 210,     // Gives enough vertical room without hardcoding card height
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildListDelegate([
                PathCard(
                  title: "Paper 1",
                  subtitle: "Algebra • Functions • Calculus",
                  imgPath: "assets/images/summation.webp",
                  onTap: () {
                    context.push(Routes.paperTypePage, extra: PaperType.paper1);
                  },
                ),
                PathCard(
                  title: "Paper 2",
                  subtitle: "Geometry • Trigonometry • Stats",
                  imgPath: "assets/images/calc.webp",
                  onTap: () {},
                ),
              ]),
            ),
          ),
        ],
      ),

      drawer: MathMatricDrawer(
        streak: 8,
      ),
    );
  }
}
