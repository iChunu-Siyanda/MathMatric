import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/quiz/presentation/pages/quiz_results.dart';

class QuizHeaderScore extends StatelessWidget {
  const QuizHeaderScore({
    super.key,
    required this.accuracy,
    required this.widget,
    required this.totalQuestions,
  });

  final double accuracy;
  final QuizResults widget;
  final dynamic totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "${accuracy.toStringAsFixed(0)}% Accuracy",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${widget.score} / $totalQuestions",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Total Points: ${widget.totalScore}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
