import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/practice/presentation/pages/quiz_results.dart';

class BackToQuizzesBtn extends StatelessWidget {
  const BackToQuizzesBtn({
    super.key,
    required this.widget,
  });

  final QuizResults widget;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        widget.reset(widget.topic);
        Navigator.pop(context);
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text("Back to Quizzes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
    );
  }
}