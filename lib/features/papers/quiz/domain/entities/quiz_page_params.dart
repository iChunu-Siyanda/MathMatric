import 'package:math_matric/features/papers/papers/domain/entities/subject_topic_quiz.dart';

class QuizPageParams {
  final String topicId;
  final String currentTopicId;
  final int xp;
  final String levelId;

  QuizPageParams({
    required this.topicId,
    required this.currentTopicId, 
    required this.xp, 
    required this.levelId,
  });

   
  SubjectTopic get targetSubjectTopic => SubjectTopic.values.firstWhere((e){
      final cleanEnumName = e.name.toLowerCase().replaceAll('_', '');
      final cleanTopicId = currentTopicId.toLowerCase().replaceAll('_', '');
      return cleanEnumName == cleanTopicId;
    },
    orElse: () => throw Exception("Could not find matching SubjectTopic enum value for ID: $currentTopicId"),
  );                     
}

