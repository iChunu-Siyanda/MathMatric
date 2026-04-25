import 'package:math_matric/features/papers/domain/entities/SubjectTopicQuiz.dart';
import 'package:math_matric/features/papers/domain/entities/quiz_question.dart';

final Map<SubjectTopic, int> questionNumberIndices = {
  SubjectTopic.algebra: 0,
  SubjectTopic.number_patterns: 0,
  SubjectTopic.functions: 0,
  SubjectTopic.calculus: 0,
  SubjectTopic.finance: 0,
  SubjectTopic.probability: 0,
};

class QuizDataSource {
  static final Map<SubjectTopic, List<QuizQuestion>> questionBanksP1 = {
    SubjectTopic.algebra: [
      QuizQuestion(
        questionText: 'What is the derivative of x²?',
        options: ['x', '2x', 'x²', '2'],
        correctAnswerIndex: 1,
        levelId: 'algebra_level1',
      ),
      QuizQuestion(
        questionText: 'What is the integral of 2x?',
        options: ['x²', '2x²', 'x² + C', '2x² + C'],
        correctAnswerIndex: 2,
        levelId: 'algebra_level1',
      ),
    ],
    SubjectTopic.number_patterns: [
      QuizQuestion(
        questionText: 'Next number: 2,4,6?',
        options: ['8', '10', '12', '14'],
        correctAnswerIndex: 0,
        levelId: 'number_patterns_level1',
      ),
      QuizQuestion(
        questionText:
            'What is the common difference in the sequence: 3, 7, 11, ...?',
        options: ['2', '3', '4', '5'],
        correctAnswerIndex: 2,
        levelId: 'number_patterns_level1',
      ),
    ],
    SubjectTopic.functions: [
      QuizQuestion(
        questionText: 'What is the value of f(2) if f(x) = 3x + 1?',
        options: ['5', '6', '7', '8'],
        correctAnswerIndex: 0,
        levelId: 'functions_level1',
      ),
      QuizQuestion(
        questionText: 'What is the inverse of the function f(x) = 2x - 3?',
        options: [
          'f⁻¹(x) = (x + 3)/2',
          'f⁻¹(x) = (x - 3)/2',
          'f⁻¹(x) = (x + 3)/4',
          'f⁻¹(x) = (x - 3)/4'
        ],
        correctAnswerIndex: 0,
        levelId: 'functions_level1',
      ),
    ],
    SubjectTopic.calculus: [
      QuizQuestion(
        questionText: 'What is the integral of 2x?',
        options: ['x²', '2x²', 'x² + C', '2x² + C'],
        correctAnswerIndex: 2,
        levelId: 'calculus_level1',
      ),
      QuizQuestion(
        questionText: 'What is the derivative of sin(x)?',
        options: ['cos(x)', '-cos(x)', 'sin(x)', '-sin(x)'],
        correctAnswerIndex: 0,
        levelId: 'calculus_level1',
      ),
    ],
    SubjectTopic.finance: [
      QuizQuestion(
        questionText: 'What is the formula for simple interest?',
        options: ['I = PRT', 'I = P + RT', 'I = P - RT', 'I = P × RT'],
        correctAnswerIndex: 0,
        levelId: 'finance_level1',
      ),
      QuizQuestion(
        questionText: 'What is the formula for compound interest?',
        options: [
          'A = P(1 + r/n)^(nt)',
          'A = P + Prt',
          'A = P - Prt',
          'A = P × (1 + r/n)^(nt)'
        ],
        correctAnswerIndex: 0,
        levelId: 'finance_level1',
      ),
    ],
    SubjectTopic.probability: [
      QuizQuestion(
        questionText: 'What is the probability of rolling a 6 on a fair die?',
        options: ['1/6', '1/2', '1/3', '1/4'],
        correctAnswerIndex: 0,
        levelId: 'probability_level1',
      ),
      QuizQuestion(
        questionText:
            'What is the probability of drawing an ace from a standard deck of cards?',
        options: ['1/13', '1/52', '4/52', '1/4'],
        correctAnswerIndex: 0,
        levelId: 'probability_level1',
      ),
    ],
  };
}
