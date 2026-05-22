import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/data/local/quiz_data_source.dart';
import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/presentation/pages/practice/quiz_results.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.topic});

  final Map<SubjectTopic, List<QuizQuestion>> topic;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int selectedIndex = -1;
  int score = 0;
  int totalScore = 0;
  List<int> userAnswers = [];

  // Helper variable to keep build code clean
  late final SubjectTopic currentTopic;

  @override
  void initState() {
    super.initState();
    currentTopic = widget.topic.keys.first;
  }

  void nextQuestion(SubjectTopic subjectTopic) {
    if (questionNumberIndices[subjectTopic]! < QuizDataSource.questionBanksP1[subjectTopic]!.length - 1) {
      questionNumberIndices[subjectTopic] = questionNumberIndices[subjectTopic]! + 1;
    }
  }

  QuizQuestion getQuestionText(SubjectTopic subjectTopic) {
    return QuizDataSource.questionBanksP1[subjectTopic]![questionNumberIndices[subjectTopic]!];
  }

  List<String> getOptions(SubjectTopic subjectTopic) {
    return getQuestionText(subjectTopic).options;
  }

  int getCorrectAnswerIndex(SubjectTopic subjectTopic) {
    return getQuestionText(subjectTopic).correctAnswerIndex;
  }

  QuizQuestion getQuestionByIndex(int index, SubjectTopic subjectTopic) {
    return QuizDataSource.questionBanksP1[subjectTopic]![index];
  }

  int getQuestionNumber(SubjectTopic subjectTopic) {
    return questionNumberIndices[subjectTopic]!;
  }

  int getTotalQuestions(SubjectTopic subjectTopic) {
    return QuizDataSource.questionBanksP1[subjectTopic]!.length;
  }

  bool isFinished(SubjectTopic subjectTopic) {
    return questionNumberIndices[subjectTopic]! >= QuizDataSource.questionBanksP1[subjectTopic]!.length - 1;
  }

  void reset(SubjectTopic subjectTopic) {
    questionNumberIndices[subjectTopic] = 0;
  }

  void nextQuestionText() {
    if (selectedIndex == -1) return;
    userAnswers.add(selectedIndex);
    if (selectedIndex == getCorrectAnswerIndex(currentTopic)) {
      score++;
    }

    totalScore += getQuestionText(currentTopic).scoreValue;

    setState(() {
      if (isFinished(currentTopic)) {
        showQuizResults();
      } else {
        nextQuestion(currentTopic);
        selectedIndex = -1;
      }
    });
  }

  void showQuizResults() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return QuizResults(
        score: score,
        totalScore: totalScore,
        getTotalQuestions: getTotalQuestions,
        getQuestionByIndex: getQuestionByIndex,
        topic: currentTopic,
        savedTopic: widget.topic,
        userAnswers: userAnswers,
        selectedIndex: selectedIndex,
        reset: reset,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final question = getQuestionText(currentTopic).questionText;
    final options = getOptions(currentTopic);
    final totalQuestions = getTotalQuestions(currentTopic);
    final currentQuestionNum = questionNumberIndices[currentTopic]! + 1;
    final isOptionSelected = selectedIndex != -1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Action Bar (Back button + Progress tracking text)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
                    onPressed: () => Navigator.pop(context),
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
              ),
              const SizedBox(height: 15),

              /// Visual Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: currentQuestionNum / totalQuestions,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.blue,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 25),

              /// Scrollable Content Area (Prevents Layout Overflow)
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Question Number Tag
                      Text(
                        "QUESTION $currentQuestionNum",
                        style: TextStyle(
                          fontSize: 13, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.grey.shade500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// Question Body Text
                      Text(
                        question,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 25),

                      /// Animated Interactive Options
                      ...List.generate(options.length, (index) {
                        bool isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.withValues(alpha: 0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                /// Container Index Bubble (A, B, C, D)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.blue : Colors.grey.shade100,
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + index),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                /// Option Text
                                Expanded(
                                  child: Text(
                                    options[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected ? Colors.blue.shade900 : const Color(0xFF334155),
                                    ),
                                  ),
                                ),

                                /// Custom Check indicator
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_off,
                                  color: isSelected ? Colors.blue : Colors.grey.shade400,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Pinned Next Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isOptionSelected ? nextQuestionText : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: isOptionSelected ? 3 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Next Question", 
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: isOptionSelected ? Colors.white : Colors.black26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}