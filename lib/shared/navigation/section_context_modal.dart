import 'package:math_matric/features/papers/data/local/exam_paper_data.dart';
import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/entities/paper_type.dart';
import 'package:math_matric/features/papers/domain/entities/topic_item.dart';

class SectionContext {
  final PaperItem paper;
  final TopicItem topic;
  final PaperType paperType;
  final ExamSession session;
  final int? year; // Add year as an optional parameter

  const SectionContext({
    required this.paper,
    required this.topic,
    required this.paperType,
    required this.session,
    this.year,
  });
}
