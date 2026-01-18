import 'package:flutter/material.dart';
import 'package:math_matric/routes/papers/resources/widgets/my_progress/streak/components/section_header.dart';

class StreakPatternSliver extends StatelessWidget {
  const StreakPatternSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionHeader(title: 'Your Pattern'),
            SizedBox(height: 8),
            Text(
              'You tend to study more consistently on weekdays.',
            ),
          ],
        ),
      ),
    );
  }
}
