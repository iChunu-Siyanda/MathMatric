import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';
import 'package:math_matric/features/papers/domain/entities/subject_topic_quiz.dart';
import 'package:math_matric/features/papers/domain/respositories/practice_respository.dart';

class LoadQuizQuestionsUseCase{
  final PracticeRepository practiceRepository;
  LoadQuizQuestionsUseCase({required this.practiceRepository});

  Future<List<QuizQuestion>> call({
    required SubjectTopic subjectTopic,
    required String levelId,
  }) async {
    return await practiceRepository.getQuizQuestionsForLevel(subjectTopic, levelId);
  }
}


