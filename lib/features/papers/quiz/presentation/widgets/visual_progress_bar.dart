import 'package:flutter/material.dart';

class VisualProgressBar extends StatelessWidget {
  const VisualProgressBar({
    super.key,
    required this.currentQuestionNum,
    required this.totalQuestions,
  });

  final int currentQuestionNum;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: currentQuestionNum / totalQuestions,
        backgroundColor: Colors.grey.shade200,
        color: Colors.blue,
        minHeight: 8,
      ),
    );
  }
}
