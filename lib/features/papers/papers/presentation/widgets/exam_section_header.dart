import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class ExamSectionHeader extends StatelessWidget {
  const ExamSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          24,
          16,
          12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Past Papers & Exams',
              style: TextStyle(
                color: AppColours.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Test your exam readiness.',
              style: TextStyle(
                color: AppColours.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
