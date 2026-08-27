import 'package:flutter/material.dart';
import 'package:math_matric/features/ui/home/domain/entities/last_studied.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/continue_studying_card.dart';
import 'package:math_matric/features/ui/home/presentation/widgets/view_actions.dart';

class BuildGridView extends StatelessWidget {
  final List<LastStudied> topics;
  const BuildGridView({super.key, required this.topics,});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int crossAxisCount = 1;
        if (width >= 1100) {
          crossAxisCount = 4;
        } else if (width >= 700) {
          crossAxisCount = 3;
        } else if (width >= 450) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          key: const ValueKey('grid_view'),
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 210, // Adjust height matching ContinueStudyingCard
          ),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return Stack(
              children: [
                ContinueStudyingCard(
                  margin: EdgeInsets.zero,
                  topic: topic.title,
                  backgroundImg: topic.backgroundImg,
                  progress: topic.progress,
                  onTap: () => ViewActions.navigateToPaper(context, topic),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => ViewActions.removeTopic(context, topic.title),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
