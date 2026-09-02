import 'package:math_matric/features/ui/exam/domain/entities/exam_session.dart';
import 'package:math_matric/features/ui/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/ui/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/ui/papers/domain/entities/topic_item.dart';

class SectionContext {
  final PaperItem paper;
  final TopicItem topic;
  final PaperType paperType;
  final ExamSession? session;
  final int? year; 

  const SectionContext({
    required this.paper,
    required this.topic,
    required this.paperType,
    this.session,
    this.year,
  });
}
