import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/paper_tile.dart';

class PapersExamGrid extends StatelessWidget {
  final List<PaperItem> items; // Full list of items
  final PaperType paperType;

  const PapersExamGrid({
    super.key,
    required this.items,
    required this.paperType,
  });

  @override
  Widget build(BuildContext context) {
    // Offset by 3 to start from the 4th item
    final gridItems = items.skip(3).take(5).toList();
    final double width = MediaQuery.of(context).size.width;

    // Detect small phones (width < 380) to render square cards
    final double childAspectRatio = width < 380 ? 1.0 : 0.78;

    // -------------------------------------------------------------
    // CASE 1: Large Screens / Web (width > 900) -> 5 cards on 1 row
    // -------------------------------------------------------------
    if (width > 900) {
      return SliverPadding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20,),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => PaperTile(
              data: gridItems[index],
              paperType: paperType,
              animation: kAlwaysCompleteAnimation,
            ),
            childCount: gridItems.length,
          ),
        ),
      );
    }

    // -------------------------------------------------------------
    // CASE 2: Tablets (600 < width <= 900)
    // Row 1: 3 cards | Row 2: 2 equal-width cards spanning remaining space
    // -------------------------------------------------------------
    if (width > 600) {
      return SliverPadding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20,),
        sliver: SliverMainAxisGroup(
          slivers: [
            // Row 1: First 3 cards
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => PaperTile(
                  data: gridItems[index],
                  paperType: paperType,
                  animation: kAlwaysCompleteAnimation,
                ),
                childCount: 3,
              ),
            ),
        
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
        
            // Row 2: Last 2 cards (2 equal columns taking full row width)
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1, // Slightly wider aspect ratio for row 2
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => PaperTile(
                  data: gridItems[index + 3],
                  paperType: paperType, 
                  animation: kAlwaysCompleteAnimation,
                ),
                childCount: 2,
              ),
            ),
          ],
        ),
      );
    }

    // -------------------------------------------------------------
    // CASE 3: Mobile (width <= 600)
    // Row 1 & 2: 2x2 Grid (4 cards) | Row 3: 1 Full-width card (5th card)
    // -------------------------------------------------------------
    return SliverPadding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20,),
      sliver: SliverMainAxisGroup(
        slivers: [
          // First 4 cards in a 2-column grid
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => PaperTile(
                data: gridItems[index],
                paperType: paperType, 
                animation: kAlwaysCompleteAnimation,
              ),
              childCount: 4,
            ),
          ),
      
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
      
          // 5th Card occupying the full width of the last row
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180, // Sleek landscape height for the full-width card
              child: PaperTile(
                data: gridItems[4],
                paperType: paperType, 
                animation: kAlwaysCompleteAnimation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
