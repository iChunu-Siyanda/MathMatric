import 'package:flutter/material.dart';
import 'package:math_matric/features/papers/data/local/quiz_data_source.dart';
import 'package:math_matric/features/papers/domain/entities/SubjectTopicQuiz.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.topic});

  final Map<SubjectTopic, List<QuizQuestion>> topic;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int selectedIndex = -1;
  int score = 0;
  List<int> userAnswers = [];

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
    if (selectedIndex == getCorrectAnswerIndex(widget.topic.keys.first)) {
      score++;
    }

    setState(() {
      if (isFinished(widget.topic.entries.first.key)) {
        showResults();
      } else {
       nextQuestion(widget.topic.entries.first.key);
        selectedIndex = -1;
      }
    });
  }

  void showResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFFF5F7FB),
              child: Column(
                children: [
                  /// Header
                  Text(
                    "Final Score: $score / $getTotalQuestions(widget.topic.entries.first.key)",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Scrollable Memo
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: getTotalQuestions(widget.topic.entries.first.key),
                      itemBuilder: (context, index) {
                        final question = getQuestionByIndex(index, widget.topic.entries.first.key);
                        final options = question.options;
                        final correctIndex = question.correctAnswerIndex;
                        final userIndex = userAnswers[index];

                        bool isCorrect = userIndex == correctIndex;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCorrect ? Colors.green : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Question
                              Text(
                                "Q${index + 1}: ${question.questionText}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// Options List
                              ...List.generate(options.length, (i) {
                                bool isUser = i == userIndex;
                                bool isAnswer = i == correctIndex;

                                Color? bgColor;

                                if (isAnswer) {
                                  bgColor = Colors.green.shade100;
                                } else if (isUser && !isCorrect) {
                                  bgColor = Colors.red.shade100;
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: bgColor ?? Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        String.fromCharCode(65 + i),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(options[i])),
                                      if (isAnswer)
                                        const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      if (isUser && !isCorrect)
                                        const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
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

                  /// Retry Button & Back to Quizzes Page Button
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              reset(widget.topic.entries.first.key);
                              score = 0;
                              selectedIndex = -1;
                              userAnswers.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Retry", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Back to Quizzes", style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = getQuestionText(widget.topic.entries.first.key).questionText;
    final options = getOptions(widget.topic.entries.first.key);
    final totalQuestions = getTotalQuestions(widget.topic.entries.first.key);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Progress
              LinearProgressIndicator(
                value: (questionNumberIndices[widget.topic.entries.first.key]! + 1) / totalQuestions,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blue,
                minHeight: 6,
              ),

              const SizedBox(height: 30),

              /// Question
              Text(
                "Question ${questionNumberIndices[widget.topic.entries.first.key]! + 1}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 10),

              Text(
                question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              /// Options
              ...List.generate(options.length, (index) {
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        /// A B C D Label
                        Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.blue : Colors.black54,
                          ),
                        ),

                        const SizedBox(width: 15),

                        /// Option Text
                        Expanded(
                          child: Text(
                            options[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        /// Radio Dot
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Spacer(),

              /// Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextQuestionText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
