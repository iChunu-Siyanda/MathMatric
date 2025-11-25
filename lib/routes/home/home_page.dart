import 'package:flutter/material.dart';
import 'package:math_matric/routes/paper1/presentation/components/main_card.dart';
import 'package:math_matric/routes/paper1/presentation/pages/paper1_page.dart';

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
            leading: Icon(Icons.menu, color: colorScheme.onPrimary),
            expandedHeight: 300,
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

          // CarouselView
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: CarouselView.weighted(
                flexWeights: const <int>[1, 3, 1],
                shrinkExtent: 50.0,
                itemSnapping: true,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Card ${index + 1}',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Paper 1:
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Paper 1", style: TextStyle(fontSize: 30)),
            ),
          ),

          SliverToBoxAdapter(
            child: MainCard(
              text: "Paper 1",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Paper1Page()),
                );
              },
            ),
          ),

          //Paper 2:
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Paper 2", style: TextStyle(fontSize: 30)),
            ),
          ),

          SliverToBoxAdapter(
            child: MainCard(
              text: "Paper 2",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Paper1Page()),
                );
              },
            ),
          ),

          //Community
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Community", style: TextStyle(fontSize: 30)),
            ),
          ),

          SliverToBoxAdapter(
            child: MainCard(
              text: "Community",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Paper1Page()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
