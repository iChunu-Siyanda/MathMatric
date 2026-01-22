import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/routes/papers/resources/components/main/paper_tile.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/routes/papers/paper_1/data/paper_item_data.dart';
import 'package:math_matric/routes/papers/resources/animations/grid_insertion_controller.dart';
import 'package:math_matric/routes/papers/paper_1/data/streak_data.dart';
import 'package:math_matric/routes/papers/resources/models/streak_variant_modal.dart';

class PapersPage extends StatefulWidget {
  final PaperType paperType;
  const PapersPage({super.key, required this.paperType});

  @override
  State<PapersPage> createState() => _PaperGridPageState();
}

class _PaperGridPageState extends State<PapersPage> {
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
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(widget.paperType == PaperType.paper1 ? 'Paper 1':'Paper 2'),
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

                return  PaperTile(
                    data: data,
                    animation: animation,
                    variant: index == 0 ? SheetVariant.streak:SheetVariant.topics,
                    streakData: index == 0 ? StreakData.streakData:null,
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
