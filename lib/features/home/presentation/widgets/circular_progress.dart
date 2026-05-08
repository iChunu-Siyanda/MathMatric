import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  final double value;
  final String label;
  final bool isGamified;

  const CircularProgress({super.key, required this.value, required this.label, this.isGamified = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isGamified) // The "Aura" Glow
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.white.withValues(alpha: 0.2), blurRadius: 10, spreadRadius: 5),
              ],
            ),
          ),
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: 8, // Thicker looks more like a game
            strokeCap: StrokeCap.round, // Rounded ends look premium
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(isGamified ? Colors.amber : Colors.white),
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
      ],
    );
  }
}
