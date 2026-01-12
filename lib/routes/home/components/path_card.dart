import 'package:flutter/material.dart';
import 'package:math_matric/routes/home/components/animated_base_card.dart';

class PathCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgPath;
  final double progress;
  final List<Color> gradient;
  final VoidCallback onTap;

  const PathCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imgPath,
    required this.progress,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBaseCard(
      height: 200,
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: _PathCardBody(
        imgPath: imgPath,
        gradient: gradient,
        title: title,
        subtitle: subtitle,
        progress: progress,
      ),
    );
  }
}

class _PathCardBody extends StatelessWidget {
  final List<Color> gradient;
  final String imgPath;
  final String title;
  final String subtitle;
  final double progress;

  const _PathCardBody({
    required this.gradient,
    required this.imgPath,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          //Background image
          Image.asset(
            imgPath,
            fit: BoxFit.cover,
          ),

          //Darkening layer for readability
          Container(
            color: Colors.black.withValues(alpha:isDark ? 0.45 : 0.25),
          ),

          //Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradient,
              ),
            ),
          ),

          //Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                /// Subtitle
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70.withValues(alpha: .7),
                  ),
                ),

                const Spacer(),

                /// Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),

                const SizedBox(height: 6),

                /// Progress label
                Text(
                  "${(progress * 100).round()}% complete",
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

