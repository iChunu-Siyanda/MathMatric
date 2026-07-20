import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/quiz/presentation/pages/quiz_results.dart';

class ScrollableMemo extends StatelessWidget {
  const ScrollableMemo({
    super.key,
    required this.controller,
    required this.totalQuestions,
    required this.widget,
  });

  final ScrollController controller;
  final dynamic totalQuestions;
  final QuizResults widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: controller,
        itemCount: totalQuestions,
        itemBuilder: (context, index) {
          final question = widget.getQuestionByIndex(index, widget.topic);
          final options = question.options;
          final correctIndex = question.correctAnswerIndex;
          final int? userIndex = index < widget.userAnswers.length 
                                ? widget.userAnswers[index] 
                                : null;
          
          bool isCorrect = userIndex == correctIndex;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Question & Header Indicator Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Q${index + 1}: ${question.questionText}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 14),
          
                /// Options List Loop
                ...List.generate(options.length, (i) {
                  bool isUser = i == userIndex;
                  bool isAnswer = i == correctIndex;
          
                  Color bgColor = Colors.grey.shade50;
                  Color textColor = const Color(0xFF475569);
                  FontWeight textWeight = FontWeight.normal;
          
                  if (isAnswer) {
                    bgColor = Colors.green.withValues(alpha: 0.1);
                    textColor = Colors.green.shade900;
                    textWeight = FontWeight.bold;
                  } else if (isUser && !isCorrect) {
                    bgColor = Colors.red.withValues(alpha: 0.1);
                    textColor = Colors.red.shade900;
                  }
          
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          String.fromCharCode(65 + i),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAnswer ? Colors.green : (isUser ? Colors.red : Colors.black54),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            options[i],
                            style: TextStyle(color: textColor, fontWeight: textWeight),
                          ),
                        ),
                        if (isAnswer)
                          const Icon(Icons.check, color: Colors.green, size: 18),
                        if (isUser && !isCorrect)
                          const Icon(Icons.close, color: Colors.red, size: 18),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
