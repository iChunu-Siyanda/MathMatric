import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/back_to_quizzes_btn.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/quiz_header_score.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/retry_quiz_btn.dart';
import 'package:math_matric/features/papers/quiz/presentation/widgets/scrollable_memo.dart';

class QuizResults extends StatefulWidget {
  final int score;
  final int totalScore;
  final int selectedIndex;
  final Function getTotalQuestions;
  final Function getQuestionByIndex;
  final SubjectTopic topic;
  final List<int> userAnswers;
  final String topicId;
  final int xpEarned;
  final String levelId;

  const QuizResults({
    super.key,
    required this.score,
    required this.totalScore,
    required this.getTotalQuestions,
    required this.getQuestionByIndex,
    required this.topic,
    required this.userAnswers,
    required this.selectedIndex,
    required this.topicId,
    required this.xpEarned,
    required this.levelId,
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
            //Header Score Dashboard
            QuizHeaderScore(accuracy: accuracy, widget: widget, totalQuestions: totalQuestions),
      
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
      
            //Scrollable Memo
            ScrollableMemo(
              controller: controller, 
              totalQuestions: totalQuestions, 
              widget: widget,
            ),
            const SizedBox(height: 10),
      
            // Properly Scaled Action Control Strip
            Row(
              children: [
                Expanded(
                  child: RetryQuizBtn(
                    topic: widget.topic, 
                    topicId: widget.topicId, 
                    xpEarned: widget.xpEarned, 
                    levelId: widget.levelId, 
                    targetSubjectTopic: widget.topic,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BackToQuizzesBtn(
                    reset: () {
                      context.pop();
                    },
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
