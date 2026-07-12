import 'package:math_matric/features/papers/exam/domain/entities/exam_session.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/papers/domain/entities/topic_item.dart';

class SectionContext {
  final PaperItem paper;
  final TopicItem topic;
  final PaperType paperType;
  final ExamSession? session;
  final int? year; // Add year as an optional parameter

  const SectionContext({
    required this.paper,
    required this.topic,
    required this.paperType,
    this.session,
    this.year,
  });
}
