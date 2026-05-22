import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/quiz_page.dart';

class QuizResults extends StatefulWidget {
  final int score;
  final int totalScore;
  final int selectedIndex;
  final Function getTotalQuestions;
  final Function getQuestionByIndex;
  final Function reset;
  final SubjectTopic topic;
  final List<int> userAnswers;
  final Map<SubjectTopic, List<QuizQuestion>> savedTopic;

  const QuizResults({
    super.key,
    required this.score,
    required this.totalScore,
    required this.getTotalQuestions,
    required this.getQuestionByIndex,
    required this.topic,
    required this.userAnswers,
    required this.selectedIndex,
    required this.reset,
    required this.savedTopic,
  });

  @override
  State<QuizResults> createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final totalQuestions = widget.getTotalQuestions(widget.topic);
    final double accuracy = totalQuestions > 0 ? (widget.score / totalQuestions) * 100 : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Quiz Summary', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Beautiful Header Score Dashboard
            Container(
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
            ),
      
            const SizedBox(height: 24),
            
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Review Questions",
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 12),
      
            /// Scrollable Memo
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: totalQuestions,
                itemBuilder: (context, index) {
                  final question = widget.getQuestionByIndex(index, widget.topic);
                  final options = question.options;
                  final correctIndex = question.correctAnswerIndex;
                  final userIndex = widget.userAnswers[index];
      
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
            ),
            const SizedBox(height: 10),
      
            /// Properly Scaled Action Control Strip
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.reset(widget.topic);
                      widget.userAnswers.clear();
                    
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage(
                            topic: widget.savedTopic, // Passing the expected map structure back to your QuizPage instance
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text("Back to Quizzes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}