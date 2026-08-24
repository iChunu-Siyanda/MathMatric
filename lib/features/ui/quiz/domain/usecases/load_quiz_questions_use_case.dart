import 'package:math_matric/features/curriculum/questions/domain/entities/questions_entity.dart';
import 'package:math_matric/features/ui/quiz/domain/repositories/quiz_questions_repository.dart';

class LoadQuizQuestionsUseCase{
  final QuizQuestionsRepository quizRepository;
  LoadQuizQuestionsUseCase(this.quizRepository);

  Future<List<QuestionsEntity>> call({
    required String levelId,
  }) async {
    return await quizRepository.getQuestionsForLevel(levelId,);
  }
}
