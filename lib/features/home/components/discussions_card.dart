import 'package:flutter/material.dart';
import 'package:math_matric/features/home/components/animated_base_card.dart';

class DiscussionsCard extends StatelessWidget {
  final VoidCallback onTap;
  final String ? backgroundImg;
  const DiscussionsCard({super.key, required this.onTap, this.backgroundImg});
  

  @override
  Widget build(BuildContext context) {
    final gradientColors = backgroundImg != null
                ? [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.6),
                  ]
                : [Colors.teal, Colors.green];
    return AnimatedBaseCard(
      height: 130,
      onTap: onTap,
      child: Stack(
        children: [
          if (backgroundImg != null) Positioned.fill(child: Image.asset(backgroundImg!, fit: BoxFit.cover,)),

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

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // center horizontally too
                children: [
                  Text(
                    "Discussions",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), 
                  Text(
                    "Ask questions, help others, study together",
                    textAlign: TextAlign.center, 
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withAlpha(180), 
                    ),
                  ),
                ],
              ),
            ),
          ),]
        ),
      );
  }
}
