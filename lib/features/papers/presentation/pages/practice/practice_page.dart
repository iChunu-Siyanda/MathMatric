import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/presentation/widget/main/practice_card.dart';

class PracticePage extends StatelessWidget {
  final List<Map<String, String>> practiceQuestions = [
    {
      "image": "assets/images/trig_img.jpg",
      "memo": "Step 1: Expand the brackets...\nStep 2: Simplify..."
    },
    {
      "image": "assets/images/summation.jpg",
      "memo": "Use factorization..."
    },
  ];

  PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice - Algebra"),
      ),
      body: ListView.builder(
        itemCount: practiceQuestions.length,
        itemBuilder: (context, index) {
          final question = practiceQuestions[index];

          return PracticeCard(
            key: ValueKey(index), // IMPORTANT for stability
            imageUrl: question["image"]!,
            memoText: question["memo"]!,
          );
        },
      ),
    );
  }
}