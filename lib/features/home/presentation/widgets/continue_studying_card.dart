import 'package:flutter/material.dart';
import 'package:math_matric/features/home/presentation/widgets/animated_base_card.dart';

class ContinueStudyingCard extends StatelessWidget {
  final String topic;
  final double progress; // 0 → 100%
  final VoidCallback onTap;
  final String? backgroundImg;
  final EdgeInsets margin;

  const ContinueStudyingCard({
    super.key,
    required this.topic,
    required this.progress,
    required this.onTap,
    this.backgroundImg,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final gradientColors = backgroundImg != null
        ? [
            Colors.black.withValues(alpha: 0.05),
            Colors.black.withValues(alpha: 0.65),
          ]
        : [colors.primary, colors.primaryContainer];

    return AnimatedBaseCard(
      height: 180,
      margin: margin,
      onTap: onTap,
      child: Stack(children: [
        if (backgroundImg != null)
          Positioned.fill(
              child: Image.asset(
            backgroundImg!,
            fit: BoxFit.cover,
          )),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Continue Studying",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                topic,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${(progress * 100).toInt()}% complete",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
