import 'package:flutter/material.dart';
import 'package:math_matric/features/home/presentation/widgets/animated_base_card.dart';
import 'package:math_matric/shared/widgets/paper_badge.dart';
import 'package:math_matric/theme/app_colours.dart';

class ContinueStudyingCard extends StatelessWidget {
  final String topic;
  final double progress; // 0 → 1.0
  final VoidCallback onTap;
  final String? backgroundImg;
  final EdgeInsets margin;

  const ContinueStudyingCard({
    super.key,
    required this.topic,
    required this.progress,
    required this.onTap,
    this.backgroundImg,
    this.margin = EdgeInsets.zero, // Default set to zero for clean list spacing
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final gradientColors = backgroundImg != null
        ? [
            AppColours.textPrimary.withValues(alpha: 0.8),
            AppColours.textPrimary.withValues(alpha: 0.50),
            Colors.transparent,
          ]
        : [colors.primary, colors.primaryContainer];

    return AnimatedBaseCard(
      height: 180,
      margin: margin,
      onTap: onTap,
      child: Stack(
        children: [
          if (backgroundImg != null)
            Positioned.fill(
              child: Image.asset(
                backgroundImg!,
                fit: BoxFit.cover,
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PaperBadge(title: "Continue Studying"),
                const SizedBox(height: 6),
                Text(
                  topic,
                  style: const TextStyle(
                    color: AppColours.surface,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${(progress * 100).toInt()}% complete",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
