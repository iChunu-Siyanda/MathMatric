import 'package:flutter/material.dart';
import 'package:math_matric/features/home/presentation/widgets/animated_base_card.dart';
import 'package:math_matric/shared/widgets/paper_badge.dart';
import 'package:math_matric/theme/app_colours.dart';

class PathCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final VoidCallback onTap;

  const PathCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imgPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 220;
        final double internalPadding = isCompact ? 12.0 : 18.0;

        return AnimatedBaseCard(
          onTap: onTap,
          height: null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColours.border.withValues(alpha: 0.8),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColours.ambientGlow,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Stack(
                children: [
                  // 1. Sharp Background Image
                  Positioned.fill(
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      cacheWidth: 800,
                    ),
                  ),

                  // 2. Multi-Tone Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColours.textPrimary.withValues(alpha: 0.92),
                            AppColours.textPrimary.withValues(alpha: 0.50),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: const [0.0, 0.65, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // 3. Card Content (Flexible Column prevents overflow)
                  Padding(
                    padding: EdgeInsets.all(internalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Badge
                        PaperBadge(title: title),

                        const Spacer(),

                        // Main Title
                        Text(
                          title,
                          style: TextStyle(
                            color: AppColours.surface,
                            fontSize: isCompact ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Subtitle
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: AppColours.surface.withValues(alpha: 0.88),
                            fontSize: isCompact ? 11 : 13,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        // Glassmorphism Action Button
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 10 : 14,
                            vertical: isCompact ? 6 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColours.cobaltBlue.withValues(alpha: 0.30),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColours.primaryAccent,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Explore Paper",
                                style: TextStyle(
                                  color: AppColours.surface,
                                  fontSize: isCompact ? 11 : 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColours.surface,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
