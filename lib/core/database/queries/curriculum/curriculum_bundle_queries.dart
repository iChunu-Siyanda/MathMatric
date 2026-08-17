import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/core/database/queries/curriculum/exam_papers_queries.dart';
import 'package:math_matric/core/database/queries/curriculum/levels_queries.dart';
import 'package:math_matric/core/database/queries/curriculum/questions_queries.dart';
import 'package:math_matric/core/database/queries/curriculum/subject_queries.dart';
import 'package:math_matric/core/database/queries/curriculum/topic_queries.dart';

extension CurriculumBundleQueries on AppDatabase {
  Future<void> installCurriculumBundle({
    required List<SubjectsCompanion> subjectsList,
    required List<TopicsCompanion> topicsList,
    required List<LevelsCompanion> levelsList,
    required List<QuestionsCompanion> questionsList,
    required List<ExamPapersCompanion> examPapersList,
  }) async {
    await transaction(() async {
      await insertSubjects(subjectsList);
      await insertTopics(topicsList);
      await insertLevels(levelsList);
      await insertQuestions(questionsList);
      await insertExamPapers(examPapersList);
    });
  }
}
