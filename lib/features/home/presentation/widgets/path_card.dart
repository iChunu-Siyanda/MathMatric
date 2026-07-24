import 'package:flutter/material.dart';
import 'package:math_matric/features/home/presentation/widgets/animated_base_card.dart';
import 'package:math_matric/shared/widgets/paper_badge.dart';
import 'package:math_matric/theme/app_colours.dart';

class PathCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final List<Color> gradient;
  final VoidCallback onTap;

  const PathCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imgPath,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBaseCard(
      height: 185,
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColours.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColours.ambientGlow,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Stack(
            children: [
              // 1. Unblurred Sharp Background Image
              Positioned.fill(
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                  cacheWidth: 1000,
                ),
              ),

              // 2. Multi-Tone Gradient Overlay
              // Ensures white math papers/diagrams are visible at the top right,
              // while text stays perfectly crisp over the cobalt slate gradient at the bottom left.
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColours.textPrimary.withValues(alpha: 0.88),
                        AppColours.textPrimary.withValues(alpha: 0.40),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. Card Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    PaperBadge(title: title,),
                    const Spacer(),

                    // Main Title
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColours.surface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Subtitle / Description
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColours.surface.withValues(alpha: 0.85),
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 14),

                    // Glassmorphism Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColours.cobaltBlue.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColours.cobaltBlue,
                          width: 1.2,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Explore Paper",
                            style: TextStyle(
                              color: AppColours.surface,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
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
  }
}
