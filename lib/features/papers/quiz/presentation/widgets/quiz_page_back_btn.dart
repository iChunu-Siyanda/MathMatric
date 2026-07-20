import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizPageBackBtn extends StatelessWidget {
  const QuizPageBackBtn({
    super.key,
    required this.currentQuestionNum,
    required this.totalQuestions,
  });

  final int currentQuestionNum;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => context.pop(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "$currentQuestionNum / $totalQuestions",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
