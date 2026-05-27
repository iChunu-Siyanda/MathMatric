import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/quiz_page.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/quiz_results.dart';

class RetryQuizBtn extends StatelessWidget {
  const RetryQuizBtn({
    super.key,
    required this.widget,
    required this.topicId,
    required this.xpEarned,
    required this.levelId,
  });

  final QuizResults widget;
  final String topicId;
  final int xpEarned;
  final String levelId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.reset(widget.topic);
        widget.userAnswers.clear();
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              topic: widget.savedTopic, topicId: widget.topicId, xpEarned: widget.xpEarned, levelId: widget.levelId, // Passing the expected map structure back to your QuizPage instance
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text("Retry Quiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
