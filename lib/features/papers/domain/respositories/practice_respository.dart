import 'package:math_matric/features/papers/domain/entities/pactice_level.dart';
import 'package:math_matric/features/papers/domain/entities/practice_topic.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/domain/entities/SubjectTopicQuiz.dart'; 

abstract class PracticeRepository {
  Future<List<PracticeTopic>> getPracticeTopics();
  Future<PracticeTopic> getPracticeTopicById(String topicId);
  Future<List<PracticeLevel>> getLevelsForTopic(String topicId);
  Future<Map<SubjectTopic, List<QuizQuestion>>> getQuizQuestionsForLevel(SubjectTopic subject, String levelId);
}
