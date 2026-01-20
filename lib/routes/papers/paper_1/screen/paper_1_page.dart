import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/components/paper_tile.dart';
import 'package:math_matric/routes/papers/resources/models/paper_item.dart';
import 'package:math_matric/routes/papers/paper_1/data/paper_item_data.dart';
import 'package:math_matric/routes/papers/resources/animations/grid_insertion_controller.dart';

class Paper1Page extends StatefulWidget {
  const Paper1Page({super.key});

  @override
  State<Paper1Page> createState() => _PaperGridPageState();
}

class _PaperGridPageState extends State<Paper1Page> {
  final GlobalKey<SliverAnimatedGridState> _gridKey = GlobalKey();

  final List<PaperItem> _items = PaperItemData.items;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = GridInsertionController(
        gridState: _gridKey.currentState!,
        totalItems: _items.length,
      );
      controller.staggerInsert();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Paper 1'),
            ),
          ),

          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverAnimatedGrid(
              key: _gridKey,
              initialItemCount: 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index, animation) {
                final data = _items[index];
                return PaperTile(data: data, animation: animation);
              },
            ),
          ),
        ],
      ),
    );
  }
}
