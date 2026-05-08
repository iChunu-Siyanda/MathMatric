import 'package:flutter/material.dart';
import 'package:math_matric/features/home/presentation/widgets/build_base.dart';
import 'package:math_matric/features/home/presentation/widgets/circular_progress.dart';
import 'package:math_matric/features/home/presentation/widgets/glow_decorator.dart';

class SmartCarouselCard extends StatelessWidget {
  final int typeIndex;
  const SmartCarouselCard({super.key, required this.typeIndex,});

  @override
  Widget build(BuildContext context) {
    switch (typeIndex) {
      case 0: // STREAK CARD
        return buildBase(
          title: "5 Day Streak!",
          desc: "You're on fire! Don't break the chain today.",
          colors: [Colors.orange.shade800, Colors.red.shade900],
          // Animated Flame Icon
          icon: Icons.local_fire_department_rounded,
          trailing: CircularProgress(
            value: 0.7,
            label: "5/7",
            isGamified: true, // Adds a glowing ring
          ),
        );

      case 1:
        return buildBase(
          title: "Quiz Alert",
          desc: "Calculus speed run starts at 6 PM. Be ready!",
          colors: [Colors.indigo.shade800, Colors.blue.shade900],
          icon: Icons.notification_important_rounded,
          trailing:
              const Icon(Icons.timer_outlined, color: Colors.white70, size: 48),
        );
      case 2:
        return buildBase(
          title: "Keep Growing",
          desc: "Small steps every day lead to big results.",
          colors: [Colors.teal.shade700, Colors.green.shade900],
          icon: Icons.auto_awesome_rounded,
          trailing: const Icon(Icons.psychology_outlined,
              color: Colors.white70, size: 48),
        );

      case 3: // GLOBAL RANK CARD
        return GlowDecorator(
          isGlowing: true,
          color: Colors.deepPurpleAccent,
          child: buildBase(
            title: "Global Rank #4",
            desc: "Double XP Active! Earn 50 more XP to hit Top 3.",
            colors: [Colors.deepPurple.shade900, Colors.black],
            icon: Icons.auto_graph_rounded,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 32),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("2X XP",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }
}
