import 'package:flutter/material.dart';
import 'package:math_matric/theme/app_colours.dart';

class StudySectionCard extends StatefulWidget {
  const StudySectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.stats,
    required this.image,
    required this.buttonText,
    this.onTap,
  });

  final String title;
  final String description;
  final String stats;
  final String image;
  final String buttonText;
  final VoidCallback? onTap;

  @override
  State<StudySectionCard> createState() => _StudySectionCardState();
}

class _StudySectionCardState extends State<StudySectionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 130,
          padding: const EdgeInsets.all(12), // Inner padding floats the inner content
          decoration: BoxDecoration(
            color: AppColours.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? AppColours.primaryAccent.withValues(alpha: .5)
                  : AppColours.border.withValues(alpha: .6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColours.primaryAccent.withValues(alpha: .15)
                    : Colors.black.withValues(alpha: .04),
                blurRadius: _hovered ? 20 : 10,
                offset: Offset(0, _hovered ? 8 : 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. FLOATING IMAGE WITH HOVER ZOOM
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 100,
                  height: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale: _hovered ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Soft gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: .3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // 2. TEXT & INTERACTION CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge / Stats Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColours.cobaltBlue.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.stats,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColours.cobaltBlue,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColours.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Subtitle / Description
                    Text(
                      widget.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColours.textSecondary,
                      ),
                    ),

                    const Spacer(),

                    // Action Link with Sliding Arrow Animation
                    Row(
                      children: [
                        Text(
                          widget.buttonText,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _hovered
                                ? AppColours.primaryAccent
                                : AppColours.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        AnimatedTranslate(
                          offset: Offset(_hovered ? 4 : 0, 0),
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: _hovered
                                ? AppColours.primaryAccent
                                : AppColours.textPrimary,
                          ),
                        ),
                      ],
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

// Helper Widget for easy smooth translations
class AnimatedTranslate extends StatelessWidget {
  const AnimatedTranslate({
    super.key,
    required this.offset,
    required this.duration,
    required this.child,
  });

  final Offset offset;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(offset.dx, offset.dy, 0),
      child: child,
    );
  }
}
