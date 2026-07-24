import 'package:flutter/material.dart';

class AnimatedBaseCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? height; // Changed from 'required double height' to optional 'double?'
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  const AnimatedBaseCard({
    super.key,
    required this.child,
    required this.onTap,
    this.height, // Optional height parameter
    this.margin = EdgeInsets.zero, // Defaulting to zero avoids double-padding inside grids
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  State<AnimatedBaseCard> createState() => _AnimatedBaseCardState();
}

class _AnimatedBaseCardState extends State<AnimatedBaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 160),
      lowerBound: 0,
      upperBound: 0.08,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _down(TapDownDetails _) => _controller.forward();
  void _up(TapUpDetails _) => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final scale = 1 - _controller.value;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: _down,
        onTapUp: (up) {
          _up(up);
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: widget.margin,
                height: widget.height, // If null, stretches/expands to fit parent flex or grid
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _hover ? 0.18 : 0.08),
                      blurRadius: _hover ? 20 : 10,
                      offset: Offset(0, _hover ? 10 : 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
