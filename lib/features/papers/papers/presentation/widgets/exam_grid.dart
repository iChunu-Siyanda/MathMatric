import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/paper_tile.dart';

class ExamGrid extends StatelessWidget {
  final List<PaperItem> items;
  final GlobalKey<SliverAnimatedGridState> gridKey;
  final PaperType paperType;

  const ExamGrid({
    super.key,
    required this.items,
    required this.gridKey,
    required this.paperType,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        40,
      ),
      sliver: SliverAnimatedGrid(
        key: gridKey,
        initialItemCount: 0,
        gridDelegate:
            const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 360,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index, animation) {
          if (index >= items.length) {
            return const SizedBox.shrink();
          }

          final data = items[index];

          return PaperTile(
            data: data,
            animation: animation,
            paperType: paperType,
          );
        },
      ),
    );
  }
}
