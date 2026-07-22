import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/study_mode.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/study_mode_card.dart';
import 'package:math_matric/theme/app_colours.dart';

class StudyModesSection extends StatelessWidget {
  const StudyModesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Study',
              style: TextStyle(
                color: AppColours.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;

                if (isWide) {
                  return  Row(
                    children: [
                      Expanded(
                        child: StudyModeCard(
                          mode: StudyMode.practice, 
                          onTap: () {},
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: StudyModeCard(
                          mode: StudyMode.classnotes, 
                          onTap: () {  },
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    StudyModeCard(
                      mode: StudyMode.practice, 
                      onTap: () {  },
                    ),
                    SizedBox(height: 12),
                    StudyModeCard(
                      mode: StudyMode.classnotes, 
                      onTap: () {  },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
