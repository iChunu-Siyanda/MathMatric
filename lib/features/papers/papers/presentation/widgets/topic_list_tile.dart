import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/papers/domain/entities/topic_item.dart';
import 'package:math_matric/theme/app_colours.dart';

class TopicListTile extends StatefulWidget {
  final TopicItem item;
  final VoidCallback onTap;

  const TopicListTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<TopicListTile> createState() => _TopicListTileState();
}

class _TopicListTileState extends State<TopicListTile> {
  bool _hover = false;
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) {
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _hover || _pressed;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: (details) {
          _handleTapUp(details);
          widget.onTap();
        },
        onTapCancel: _handleTapCancel,
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColours.surfaceElevated
                  : AppColours.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isActive
                    ? AppColours.primaryAccent.withAlpha(90)
                    : AppColours.border,
                width: isActive ? 1.2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? AppColours.ambientGlow
                      : Colors.black.withAlpha(8),
                  blurRadius: isActive ? 18 : 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Light-blue-first icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isActive
                        ? AppColours.mathMatricGradient
                        : const LinearGradient(
                            colors: [
                              Color(0xFFE0F2FE),
                              Color(0xFFDBEAFE),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: isActive
                            ? AppColours.ambientGlow
                            : AppColours.cobaltBlue.withAlpha(18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.item.icon,
                    size: 26,
                    color: isActive
                        ? AppColours.surface
                        : AppColours.cobaltBlue,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColours.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        widget.item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColours.textSecondary,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Animated navigation affordance
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColours.primaryAccent.withAlpha(20)
                        : AppColours.surfaceSecondary.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 180),
                    offset: isActive
                        ? const Offset(0.08, 0)
                        : Offset.zero,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: isActive
                          ? AppColours.primaryAccent
                          : AppColours.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
