import 'package:drift/drift.dart';
import 'package:math_matric/core/database/app_database.dart';

extension QuestionsQueries on AppDatabase {
  Future<List<Question>> getAllQuestions() {
    return select(questions).get();
  }

  Future<Question?> getQuestion(String questionId) {
    return (select(questions)
          ..where((q) => q.id.equals(questionId)))
        .getSingleOrNull();
  }

  Future<List<Question>> getQuestionsByLevel(String levelId) {
    return (select(questions)
          ..where((q) => q.levelId.equals(levelId)))
        .get();
  }

  // Future<List<Question>> getQuestionsByTopic(
  //   String topicId,
  // ) async {
  //   final query = select(questions).join([
  //     innerJoin(
  //       levels,
  //       levels.id.equalsExp(questions.levelId),
  //     ),
  //   ])
  //     ..where(levels.topicId.equals(topicId));
  //   final rows = await query.get();
  //   return rows
  //       .map((row) => row.readTable(questions))
  //       .toList();
  // }

  Future<int> getQuestionCount(String levelId) async {
    final query = selectOnly(questions)
      ..addColumns([questions.id.count()])
      ..where(questions.levelId.equals(levelId));

    final result = await query.getSingle();

    return result.read(questions.id.count()) ?? 0;
  }

  Future<int> insertQuestion(QuestionsCompanion question) {
    return into(questions).insert(question);
  }

  Future<void> insertQuestions(
    List<QuestionsCompanion> questionList,
  ) {
    return batch((batch) {
      batch.insertAll(questions, questionList);
    });
  }

  Future<bool> updateQuestion(Question question) {
    return update(questions).replace(question);
  }

  Future<int> deleteQuestion(String questionId) {
    return (delete(questions)
          ..where((q) => q.id.equals(questionId)))
        .go();
  }

  Future<int> deleteQuestionsByLevel(String levelId) {
    return (delete(questions)
          ..where((q) => q.levelId.equals(levelId)))
        .go();
  }

  Future<int> clearQuestions() {
    return delete(questions).go();
  }

  Future<bool> hasQuestions() async {
    final count = await getAllQuestions();

    return count.isNotEmpty;
  }
}
