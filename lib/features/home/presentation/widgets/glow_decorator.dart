import 'package:flutter/material.dart';

class GlowDecorator extends StatelessWidget {
  final Widget child;
  final bool isGlowing;
  final Color color;

  const GlowDecorator({super.key, required this.child, this.isGlowing = false, required this.color});

  @override
  Widget build(BuildContext context) {
    if (!isGlowing) return child;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}