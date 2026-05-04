import 'package:math_matric/features/papers/domain/entities/exam_page_mode.dart.dart';
import 'package:math_matric/app/navigation/section_context_modal.dart';

class ExamPageArguments {
  final String paperId;
  final ExamPageMode mode;
  final SectionContext contextData;
  final int year;

  ExamPageArguments({
    required this.paperId,
    required this.mode,
    required this.contextData,
    required this.year,
  });
}
