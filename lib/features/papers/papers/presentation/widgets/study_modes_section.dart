import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/study_mode.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/study_section_card.dart';
import 'package:math_matric/features/papers/papers/presentation/widgets/verticle_study_mode_tile.dart';
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
                  return Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 240, // Height tuned for vertical tiles
                          child: VerticalStudyModeTile(
                            mode: StudyMode.practice,
                            onTap: () {
                              // Navigate to practice
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 240,
                          child: VerticalStudyModeTile(
                            mode: StudyMode.classnotes,
                            onTap: () {
                              // Navigate to notes
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Narrow View / Mobile Fallback (Stacked Slim Cards)
                return Column(
                  children: [
                    StudySectionCard(
                      title: StudyMode.practice.title,
                      description: StudyMode.practice.description,
                      stats: StudyMode.practice.stats,
                      image: StudyMode.practice.imageAsset,
                      buttonText: StudyMode.practice.buttonText,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    StudySectionCard(
                      title: StudyMode.classnotes.title,
                      description: StudyMode.classnotes.description,
                      stats: StudyMode.classnotes.stats,
                      image: StudyMode.classnotes.imageAsset,
                      buttonText: StudyMode.classnotes.buttonText,
                      onTap: () {},
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
