import 'package:math_matric/core/database/app_database.dart';
import 'package:math_matric/features/curriculum/questions/domain/entities/questions_entity.dart';

class QuestionsModel extends QuestionsEntity{
  const QuestionsModel({
    required super.id, 
    required super.levelId, 
    required super.questionText, 
    required super.options, 
    required super.explanation, 
    required super.difficulty, 
    required super.correctAnswerIndex,
  });

  factory QuestionsModel.fromFirestore(Map<String,dynamic> json) {
    return QuestionsModel(
      id: json['id'] as String? ?? '', 
      levelId: json['levelId'] as String? ?? '', 
      questionText: json['questionText'] as String? ?? '', 
      options: List<String>.from(json['options'] ?? const []), 
      explanation: json['explanation'] as String? ?? '', 
      difficulty: (json['difficulty'] as num?)?.toDouble() ?? 0.0, 
      correctAnswerIndex: json['correctAnswerIndex'] as int? ?? 0,
    );
  }

  Map<String,dynamic> toFirestore() {
    return {
      'id': id,
      'levelId': levelId,
      'questionText': questionText,
      'options': options,
      'explanation': explanation,
      'difficulty': difficulty,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  QuestionsEntity toEntity() {
    return QuestionsEntity(
      id: id, 
      levelId: levelId, 
      questionText: questionText, 
      options: options, 
      explanation: explanation, 
      difficulty: difficulty, 
      correctAnswerIndex: correctAnswerIndex,
    );
  }

  factory QuestionsModel.fromEntity(QuestionsEntity question) {
    return QuestionsModel(
      id: question.id, 
      levelId: question.levelId, 
      questionText: question.questionText, 
      options: question.options, 
      explanation: question.explanation, 
      difficulty: question.difficulty, 
      correctAnswerIndex: question.correctAnswerIndex,
    );
  }

  factory QuestionsModel.fromDrift(Question question) {
    return QuestionsModel(
      id: question.id, 
      levelId: question.levelId, 
      questionText: question.question, 
      options: [question.optionA, question.optionB,question.optionC,question.optionD], 
      explanation: question.explanation, 
      difficulty: question.difficulty, 
      correctAnswerIndex: question.correctAnswerIndex,
    );
  }

  QuestionsCompanion toCompanion(
    int version,
    DateTime updatedAt,
  ){
    return QuestionsCompanion.insert(
      id: id, 
      levelId: levelId, 
      question: questionText, 
      optionA: options.first, 
      optionB: options[1], 
      optionC: options[2], 
      optionD: options.last, 
      correctAnswerIndex: correctAnswerIndex, 
      difficulty: difficulty, 
      explanation: explanation, 
      version: version, 
      updatedAt: updatedAt,
    );
  }
}
