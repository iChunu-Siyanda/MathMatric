import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/topic_item.dart';

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
    final double scale = _pressed ? 0.975 : 1.0;
    final double elevation = _hover ? 18 : 6;
    final BorderRadius borderRadius = BorderRadius.circular(12);

    return MouseRegion(
      onEnter: (context) => setState(() => _hover = true),
      onExit: (context) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: (d) {
          _handleTapUp(d);
          widget.onTap();
        },
        onTapCancel: _handleTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.12),
                blurRadius: elevation,
                offset: Offset(0, elevation / 3),
              )
            ],
          ),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // circular thumbnail
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.item.color.withValues(alpha:0.95),
                          widget.item.color.withValues(alpha:0.7),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.item.color.withValues(alpha:0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        widget.item.icon,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.item.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha:0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // trailing chevron or action
                  const Icon(Icons.chevron_right_rounded, size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
