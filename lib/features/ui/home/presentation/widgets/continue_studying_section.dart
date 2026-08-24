import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/ui/home/presentation/bloc/study_history_state.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/continue_studying_card.dart';
import 'package:math_matric/shared/app_routes/routes.dart';

class ContinueStudyingSection extends StatelessWidget {
  const ContinueStudyingSection({
    super.key,
    required this.state,
  });

  final StudyHistoryState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final int totalItems = state.recentTopics.length;
        const double gap = 12.0;         // Space between cards
        const double peekAmount = 48.0;  // Visible portion of the next card
        const double outerPadding = 16.0; // Horizontal screen margins
    
        //Columns based on screen width
        int targetColumns;
        if (availableWidth < 420) {
          targetColumns = 1; // Standard Phone
        } else if (availableWidth < 768) {
          targetColumns = 2; // Large Phone / Small Tablet
        } else if (availableWidth < 1100) {
          targetColumns = 3; // Tablet / Laptop
        } else {
          targetColumns = 4; // Desktop
        }
    
        //Determine if we actually need a peek or if items fit exact columns
        final int visibleColumns = totalItems < targetColumns ? totalItems : targetColumns;
        final bool showPeek = totalItems > visibleColumns;
    
        //Compute Card Width mathematically
        double cardWidth;
        if (showPeek) {
          // Subtract outer padding, gaps, and the peek area from screen width
          final double usedSpace = (outerPadding * 2) + (gap * visibleColumns) + peekAmount;
          cardWidth = (availableWidth - usedSpace) / visibleColumns;
        } else {
          // Fits items exactly across the available width without extra peek space
          final double usedSpace = (outerPadding * 2) + (gap * (visibleColumns - 1));
          cardWidth = (availableWidth - usedSpace) / visibleColumns;
        }
    
        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: outerPadding,
              right: showPeek ? outerPadding : outerPadding,
            ),
            itemCount: totalItems,
            separatorBuilder: (_, __) => SizedBox(width: gap),
            itemBuilder: (context, index) {
              final topic = state.recentTopics[index];
              return SizedBox(
                width: cardWidth,
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
              );
            },
          ),
        );
      },
    );
  }
}
