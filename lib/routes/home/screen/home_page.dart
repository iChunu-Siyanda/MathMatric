import 'package:flutter/material.dart';
import 'package:math_matric/app/router.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/routes/drawer/math_matric_drawer.dart';
import 'package:math_matric/routes/home/components/auto_sliding_carousel.dart';
import 'package:math_matric/routes/home/components/continue_studying_card.dart';
import 'package:math_matric/routes/home/components/discussions_card.dart';
import 'package:math_matric/routes/home/components/path_card.dart';


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
            child: ContinueStudyingCard(
              topic: "Functions",
              backgroundImg: "assets/images/summation.jpg",
              progress: 0.45,
              onTap: () {},
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
                  imgPath: "assets/images/steps_img.jpg",
                  progress: 0.6,
                  gradient: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                  //gradient: [Colors.blue, Colors.indigo],
                  onTap: () {
                    Navigator.pushNamed(context, Routes.paperTypePage, arguments: PaperType.paper1);
                  },
                ),
                PathCard(
                  title: "Paper 2",
                  subtitle: "Geometry • Trig",
                  imgPath: "assets/images/globe_img.jpg",
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
          SliverToBoxAdapter(child: DiscussionsCard(onTap: () {}, backgroundImg: "assets/images/hands_img.jpg",)),
        ],
      ),

      drawer: MathMatricDrawer(streak: 8,),
    );
  }
}
