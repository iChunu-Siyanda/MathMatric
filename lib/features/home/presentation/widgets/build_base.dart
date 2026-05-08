import 'package:flutter/material.dart';

Widget buildBase({
    required String title,
    required String desc,
    required List<Color> colors,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(
        children: [
          // Background floating icon for depth
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, size: 120, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(desc, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, height: 1.2)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }