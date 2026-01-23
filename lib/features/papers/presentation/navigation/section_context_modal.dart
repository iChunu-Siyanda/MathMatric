import 'package:math_matric/features/papers/domain/entities/paper_item.dart';
import 'package:math_matric/features/papers/domain/entities/topic_item.dart';

class SectionContext {
  final PaperItem paper;
  final TopicItem topic;

  const SectionContext({
    required this.paper,
    required this.topic,
  });
}
