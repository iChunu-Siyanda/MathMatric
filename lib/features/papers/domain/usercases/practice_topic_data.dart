import 'package:math_matric/features/papers/domain/entities/SubjectTopicQuiz.dart';
import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';

class PracticeTopicData {
  final PracticeTopic practiceTopic;
  final List<PracticeLevel> levels;
  final int earnedXp;
  final int totalXp;
  final double progress;
  final Map<SubjectTopic, List<QuizQuestion>> subjectData; // Add this line to include quiz questions

  const PracticeTopicData({
    required this.practiceTopic,
    required this.levels,
    required this.earnedXp,
    required this.totalXp,
    required this.progress,
    required this.subjectData,
  });
}

//PracticeTopicData calculates the info of the user amd provides the relevant quiz questions for the practice topic.
